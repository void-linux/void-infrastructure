# void-updates

The void-updates site provides a text file every day that shows all
package maintainers and all packages with updates known.

Because of the mechanism by which void-updates works, care must be
taken to not let it run unthrottled.  We have configured it to scrape
for updates once per day, and this seems to be infrequent enough to
keep most webmasters happy.

While a manual run of void-updates can be triggered, be aware that
this can cause instability in the output data and is discouraged.
