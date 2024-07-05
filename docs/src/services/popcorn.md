# PopCorn

PopCorn is Void's package popularity system, similar to Debian's
popularity contest system `popcon`, from which the name was inspired.

Information in depth about PopCorn can be found at the project's
[GitHub repository](https://github.com/the-maldridge/popcorn).

## Querying Stats

Stats from PopCorn are available for anyone who wishes to query the
system.  The server is live at `popcorn.voidlinux.org` with reports
services on port 8003 and the stats repository available on port 8001.

### Getting the day's stats

You can download the current raw stats at any time.  These are the
stats that are written to the per-day files at the PopCorn site.

```shell
$ popcornctl --server popcorn.voidlinux.org --port 8001 report
```

If no file is specified then `output.json` will be written to the
current directory.  If a file is specified by passing `--file <path>`
to report, then the output will be written to the named file.

### Finding out versions of a package

The versions for a package can be queried from the statsrepo with
popcornctl.  By default the stats are queried over the most recent 30
day interval.  To get known versions us the following query:

```shell
$ popcornctl --server popcorn.voidlinux.org --port 8003 pkgstats --pkg <pkg>
```

Additional formatting options are available by specifying `--format`.
Useful alternate formats are `date` and `csv` which provide
information about versions seen over time.
