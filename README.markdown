# BOSH tmux console

## Synopsis

```
$ bosh-tmux-console cf-warden | xargs tmux
```

will create a new tmux session 'bosh-cf-warden'. Within that new tmux session, the command will then, for each VM, create a new tmux window with two panes, one running `watch -n 1 monit summary`, and one with a prompt where you are already `root` and changed into `/var/vcap`.

`bosh-tmux-console` simply creates a list of tmux commands. Instead of feeding them into tmux using xargs, you might as well inspect them on STDOUT by calling `bosh-tmux-console` as is:

```
$ bosh-tmux-console cf-warden | xargs tmux
new-session -d -s bosh-cf-warden -n postgres/0 bosh ssh postgres/0;
send-keys -t bosh-cf-warden:postgres/0 'sudo su -' C-m;
...
```

## Prerequisites

* You'll need to be authenticated to a BOSH director (`bosh target`)
* `bosh deployment` must be set

## Goodies

* Fix the stemcell's annoying `$PS1` error:

  ```bash
  apt-get install jq
  jq -r '.id' < /var/vcap/bosh/spec.json > /var/vcap/instance/id
  jq -r '.job.name' < /var/vcap/bosh/spec.json > /var/vcap/instance/name
  ```
