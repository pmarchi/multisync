## [0.3.7] - 2021-10-28

- Add grand total to summary


## [0.3.6] - 2019-08-20

- Tweak output when specifing --print and/or --quiet


## [0.3.5] - 2019-08-13

- Fix option quiet
- Catch SIGINT and print a summary after an interrupt


## [0.3.4] - 2019-07-23

- Update help
- Update readme
- Update sample file


## [0.3.3] - 2019-07-23

- Update gem description


## [0.3.2] - 2019-07-23

- First public release


## [0.3.1] - 2018-06-01

Changes in DSL
- removed "desc"
- "from" accepts a description option
- "to"" accepts a description option
- New: "template" and "include"

Changes in CLI
- New: timeout option
- New: quiet option
- polished output


## [0.2.4] - 2017-09-23

- Fix: check command


## [0.2.3] - 2017-09-23

- Fix: check remote path


## [0.2.2] - 2017-09-23

- replaced shell_cmd gem with mixlib-shellout
- Fix: check path for paths containing spaces


## [0.2.1] - 2017-09-22

- New: option "check_from" and "check_to" to let check host or path before sync
- New: "from" and "to" accept an optional check: true|false parameter
- Change summery output to a more compact tabular form
- Use rainbow for colorization
- Move "only_if" checks to runtime


## [0.2.0] - 2016-03-22

- New: option only_if for preflight checks, prior to sync
- Command line option -p/--print changed to --show


## [0.1.2] - 2014-08-29

- Mark default sets with an * when listing


## [0.1.1] - 2014-08-28

- Add gem dependecy 'text-highlight'


## [0.1.0] - 2014-07-18

- New: define one or more groups/syncs as default, to run when no sets have been given as args


## [0.0.2] - 2014-07-17

- Fix: do no escape option strings


## [0.0.1] - 2014-07-11

- First release