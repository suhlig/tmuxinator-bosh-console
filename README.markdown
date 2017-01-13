# BOSH tmux console

## Synopsis

```
$ bosh-tmux-console cf-warden
```

will create a new tmux session 'bosh-cf-warden'. Within that new tmux session, the command will then, for each VM, create a new tmux window with two panes, one running `watch -n 1 monit summary`, and one with a prompt where you are already `root` and changed into `/var/vcap`.

## Prerequisites

* You'll need to be authenticated to a BOSH director (`bosh target`)
* `bosh deployment` must be set
