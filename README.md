# Cache::MySqlCacheStore

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     mysql_cache_store:
       github: crystal-cache/mysql_cache_store
   ```

2. Run `shards install`

## Usage

```crystal
require "mysql_cache_store"
```

```
CREATE DATABASE cache_test character set utf8mb4 collate utf8mb4_unicode_ci;
```

## Development

## Contributing

1. Fork it (<https://github.com/crystal-cache/mysql_cache_store/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Anton Maminov](https://github.com/mamantoha) - creator and maintainer
