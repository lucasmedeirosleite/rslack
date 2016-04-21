# RSlack [![Build Status](https://travis-ci.org/lucasmedeirosleite/rslack.svg)](https://travis-ci.org/lucasmedeirosleite/rslack)

A Slack Bot to retrieve ruby documentation through ri CLI tool.

## Installation

Clone this repository:

```git
git clone git@github.com:lucasmedeirosleite/rslack.git
```

Enter in its directory:

```
cd rslack
```

Run:

```
bin/setup
```

## In case ri documentation is not installed

If you are using [RVM](http://www.rvm.io) make sure you run this command:

```
rvm docs generate-ri
```

If not try this:

```
gem install rdoc-data && rdoc-data --install
```

## Running tests

```
bin/test
```

## Playing with it using the console

Run:

```
SLACK_API_URL=https://slack.com/api SLACK_BOT_TOKEN=your-bot-token bin/console
```

## Starting your bot

```
SLACK_API_URL=https://slack.com/api SLACK_BOT_TOKEN=your-bot-token bin/run
```

## Usage

In slack (web, desktop app or mobile app) mention your bot and ask for ruby documentation.

Supose your bot name is rubymaster and you start our bot app with rubymaster's token.

The interaction will be like this:

* ```@rubymaster: Array#first```
* ```@rubymaster: Hash Enumerable```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lucasmedeirosleite/rslack. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
