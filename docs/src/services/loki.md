# Loki

Loki is the central log server that we wish to make publicly
accessible. Note that not all logs are accessible; because Loki may be
queried by anybody on the internet, we do not want to push all syslog
data to Loki.

Loki is from Grafana, and there are two main ways to interact with it,
both of which use LogQL.  If you are familiar with Prometheus, LogQL
should be fairly straightforward, as it follows the same general
design as PromQL.

## PromQL Cheat Sheet

PromQL expressions are always started by a stream selector in curly
braces.  The stream selector must specify at least one stream by the
labels that are available.  By default the following labels are
available for all tasks:

  - `nomad_job`: The top level ID of the job that is running.
  - `filename`: The filename that the log was read from.

Here's an example LogQL query that gives you the contents of the
buildsync-musl log:

```
{nomad_job="buildsync-musl"}
```

This will pull all streams that are labelled with buildsync-musl as
the Nomad job.  To select only stderr output, amend the stream
selector as follows:

```
{nomad_job="buildsync-musl", filename="/alloc/logs/rsync.stderr.0"}
```

Sometimes you might want to use regular expressions to match multiple
labels at once in the stream, such as if you want to get many logs
from a logrotated set of files.  By default Nomad rotates its logs
every 10MB.

```
{nomad_job=~"buildsync-(musl|aarch64)", filename=~"/alloc/logs/rsync.std(err|out).*"}
```

The above example demonstrates the use of a regular expression to
match multiple log streams simultaneously.  The operators for matching
are as follows:

  - `=`: Exactly Equal
  - `!=`: Does Not Equal
  - `=~`: Regex Matches
  - `!~`: Regex Does Not Match

You can also perform filtering once the log stream has been selected.
If you wanted to only match lines containing the strings `xbps` and
`repodata` you could extend the above query to the following:

```
{nomad_job=~"buildsync-(musl|aarch64)", filename=~"/alloc/logs/rsync.std(err|out).*"} |~ "(xbps|repodata)
```

A full list of expressions and matchers is available in the [Upstream
Loki Documentation](https://grafana.com/docs/loki/latest/logql/).

## Querying Logs With Grafana

Users with grafana credentials can use the "explore" page of the
grafana web interface to query logs.  If you find a particularly
useful log query, consider adding a new dashboard to quickly refer to
the query again.

## Querying Logs With LogCLI

All users can use LogCLI to query loki directly from the command line
using `logcli` from the `loki` package.  LogCLI can run the first
query from the cheat sheet above as follows:

```shell
$ export LOKI_ADDR=https://loki.s.voidlinux.org
$ logcli query '{nomad_job="buildsync-musl"}'
Common labels: {filename="/alloc/logs/rsync.stdout.0", nomad_group="rsync", nomad_job="buildsync-musl", nomad_namespace="build", nomad_task="promtail"}
2021-03-07T20:30:59-08:00 {} debug/xlunch-dbg-4.7.0_1.armv6l-musl.xbps
2021-03-07T20:30:59-08:00 {} debug/udftools-dbg-2.3_1.armv6l-musl.xbps
2021-03-07T20:30:59-08:00 {} debug/opensp-dbg-1.5.2_9.armv7l-musl.xbps
2021-03-07T20:30:59-08:00 {} debug/mDNSResponder-dbg-1310.80.1_1.armv6l-musl.xbps
2021-03-07T20:30:59-08:00 {} debug/libhunspell1.7-dbg-1.7.0_3.armv6l-musl.xbps
2021-03-07T20:30:59-08:00 {} debug/libflac-dbg-1.3.3_2.armv7l-musl.xbps
2021-03-07T20:30:59-08:00 {} debug/libaspell-dbg-0.60.8_4.armv6l-musl.xbps
2021-03-07T20:30:58-08:00 {} debug/icu-libs-dbg-67.1_2.armv7l-musl.xbps
2021-03-07T20:30:58-08:00 {} debug/icu-dbg-67.1_2.armv7l-musl.xbps
2021-03-07T20:30:58-08:00 {} debug/hunspell-dbg-1.7.0_3.armv6l-musl.xbps
2021-03-07T20:30:58-08:00 {} debug/flac-dbg-1.3.3_2.armv7l-musl.xbps
2021-03-07T20:30:58-08:00 {} debug/clucene-dbg-2.3.3.4_9.armv6l-musl.xbps
2021-03-07T20:30:58-08:00 {} debug/aspell-dbg-0.60.8_4.armv6l-musl.xbps
2021-03-07T20:30:58-08:00 {} debug/armv7l-musl-repodata
2021-03-07T20:30:58-08:00 {} debug/armv6l-musl-repodata
2021-03-07T20:30:58-08:00 {} xlunch-4.7.0_1.armv6l-musl.xbps
2021-03-07T20:30:58-08:00 {} udftools-2.3_1.armv6l-musl.xbps
2021-03-07T20:30:58-08:00 {} opensp-devel-1.5.2_9.armv7l-musl.xbps
2021-03-07T20:30:58-08:00 {} opensp-1.5.2_9.armv7l-musl.xbps
2021-03-07T20:30:57-08:00 {} nomad-1.0.4_1.armv6l-musl.xbps
2021-03-07T20:30:57-08:00 {} mDNSResponder-1310.80.1_1.armv6l-musl.xbps
2021-03-07T20:30:57-08:00 {} libhunspell1.7-1.7.0_3.armv6l-musl.xbps
2021-03-07T20:30:57-08:00 {} libflac-devel-1.3.3_2.armv7l-musl.xbps
2021-03-07T20:30:57-08:00 {} libflac-1.3.3_2.armv7l-musl.xbps
2021-03-07T20:30:57-08:00 {} libaspell-0.60.8_4.armv6l-musl.xbps
2021-03-07T20:30:56-08:00 {} icu-libs-67.1_2.armv7l-musl.xbps
2021-03-07T20:30:55-08:00 {} icu-devel-67.1_2.armv7l-musl.xbps
2021-03-07T20:30:55-08:00 {} icu-67.1_2.armv7l-musl.xbps
2021-03-07T20:30:55-08:00 {} hunspell-devel-1.7.0_3.armv6l-musl.xbps
2021-03-07T20:30:55-08:00 {} hunspell-1.7.0_3.armv6l-musl.xbps
```
