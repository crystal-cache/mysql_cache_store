# Cache::MySqlCacheStore

[![Crystal CI](https://github.com/crystal-cache/mysql_cache_store/actions/workflows/crystal.yml/badge.svg)](https://github.com/crystal-cache/mysql_cache_store/actions/workflows/crystal.yml)
[![GitHub release](https://img.shields.io/github/release/crystal-cache/mysql_cache_store.svg)](https://github.com/crystal-cache/maysql_cache_store/releases)

A [cache](https://github.com/crystal-cache/cache) store implementation which stores everything in the MySQL database,
using [crystal-mysql](https://github.com/crystal-lang/crystal-mysql) as the backend.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     mysql_cache_store:
       github: crystal-cache/mysql_cache_store
   ```

2. Run `shards install`

## Usage

Before using this shard make sure you have created MySQL database. For example `cache_production`:

```console
mysql -u root

mysql> CREATE DATABASE cache_production character set utf8mb4 collate utf8mb4_unicode_ci;
```

A MySQL database can be opened with:

```crystal
db = DB.open("mysql://root@localhost/cache_production")
```

Open and use the new cache instance:

```crystal
require "mysql_cache_store"

cache = Cache::MySqlCacheStore(String, String).new(1.minute, db)

cache.write("foo", "bar")

cache.read("foo") # => "bar"
```

## Development

### Run specs

Before run specs make sure you have created MySQL database `cache_test

```console
mysql -u root

mysql> CREATE DATABASE cache_test character set utf8mb4 collate utf8mb4_unicode_ci;
```

```console
crystal spec
```
## Contributing

1. Fork it (<https://github.com/crystal-cache/mysql_cache_store/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Anton Maminov](https://github.com/mamantoha) - creator and maintainer
