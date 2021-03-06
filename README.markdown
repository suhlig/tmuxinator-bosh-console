# BOSH tmuxinator console

[![Build Status](https://travis-ci.org/suhlig/tmuxinator-bosh-console.svg?branch=master)](https://travis-ci.org/suhlig/tmuxinator-bosh-console)

## Synopsis

```bash
$ tmuxinator-bosh-console cf-warden
```

will create a new tmuxinator project 'cf-warden'. Each instance (VM) will get its own tmux window with some panes, according to the provided template.

The list of instances is generated by executing `bosh instances` and therefore lists only the VMs of the current deployment.

Once created, tmuxinator can be used as usual to launch the project:

```bash
$ tmuxinator cf-warden
```

Anything appearing after a single `--` argument is appended to `bosh ssh`, e.g. `--gateway-host` etc.

## Installation

```bash
$ gem install tmuxinator-bosh-console
```

## Prerequisites

`bosh instances` must return zero or more instances.

## TODO

* Think about `bosh instances` vs. `bosh vms`. We may or may not be interested in jobs that have no VMs, as produced by `bosh vms`.
* repeated `--include`s and `--exclude`s will make less complex regexes
