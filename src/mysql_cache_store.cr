require "cache"
require "mysql"

module Cache
  # A cache store implementation which stores everything in the MySQL database
  struct MySqlCacheStore(K, V) < Store(K, V)
    # Creates a new `MySqlCacheStore` attached to the provided database.
    #
    # `table_name` and `expires_in` are required for your connection.
    def initialize(@expires_in : Time::Span, @mysql : DB::Database, @table_name = "cache_entries")
      create_cache_table unless cache_table_exists?
    end

    private def write_impl(key : K, value : V, *, expires_in = @expires_in)
      sql = <<-SQL
        REPLACE INTO `#{@table_name}` (`key`, `value`, `expires_in`, `created_at`)
        VALUES (?, ?, ?, ?)
      SQL

      @mysql.exec(sql, key, value, expires_in.to_i, Time.utc.to_s("%Y-%m-%d %H:%M:%S"))
    end

    private def read_impl(key : K)
      sql = "SELECT `value`, `created_at`, `expires_in` FROM `#{@table_name}` WHERE `key` = ?"

      rs = @mysql.query_one?(sql, key, as: {String, Time, Int32})

      return unless rs

      value, created_at, expires_in = rs

      expires_at = created_at + expires_in.seconds

      if expires_at <= Time.utc
        delete(key)

        return
      end

      value
    end

    private def delete_impl(key : K) : Bool
      sql = "DELETE from `#{@table_name}` WHERE `key` = ?"

      result = @mysql.exec(sql, key)

      result.rows_affected.zero? ? false : true
    end

    private def exists_impl(key : K) : Bool
      sql = "SELECT `created_at`, `expires_in` FROM `#{@table_name}` WHERE `key` = ?"

      rs = @mysql.query_one?(sql, key, as: {Time, Int32})

      return false unless rs

      created_at, expires_in = rs

      expires_at = created_at + expires_in.seconds

      expires_at > Time.utc
    end

    def clear
      sql = "TRUNCATE TABLE `#{@table_name}`"

      @mysql.exec(sql)
    end

    # Preemptively iterates through all stored keys and removes the ones which have expired.
    def cleanup
      sql = "DELETE FROM `#{@table_name}` WHERE `created_at` + `expires_in` < NOW()"

      @mysql.exec(sql)
    end

    private def create_cache_table
      sql = <<-SQL
        CREATE TABLE `#{table_name}` (
          `key` varchar(255) NOT NULL PRIMARY KEY,
          `value` longtext,
          `expires_in` int NOT NULL,
          `created_at` datetime NOT NULL
        )
      SQL

      @mysql.exec(sql)
    end

    private def cache_table_exists? : Bool
      database_name = @mysql.uri.path.lchop('/')
      sql = "SELECT 1 FROM information_schema.tables WHERE table_schema = '#{database_name}' AND table_name = '#{table_name}'"

      @mysql.query_one?(sql, as: Int64) == 1
    end
  end
end
