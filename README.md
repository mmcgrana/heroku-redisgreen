## heroku-redisgreen

Heroku client plugin for [RedisGreen](https://addons.heroku.com/redisgreen).


### Usage

```console
$ heroku plugins:install https://github.com/stvp/heroku-redisgreen.git
$ heroku redisgreen:cli -a my-app SET mykey "hello world"
=> OK
$ heroku redisgreen:cli -a my-app GET mykey
=> "hello world"
$ heroku redisgreen:cli -a my-app
redis smart-dandelion-4.redisgreen.net:11035>
```
