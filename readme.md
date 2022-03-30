lepton-refdes-renum
===================

Batch `refdes` renumbering utility for [Lepton EDA](https://github.com/lepton-eda/lepton-eda).
<br />
Reimplementing stock [lepton-refdes_renum](https://github.com/lepton-eda/lepton-eda/blob/master/utils/refdes_renum/lepton-refdes_renum)
`Perl` script's functionality in `Guile`.
<br />
Make it available in `REPL` and lepton-schematic `:` prompt (i.e. programmatically).
<br />
Work in progress.
<br /><br />
man: [lepton-refdes_renum(1)](https://graahnul-grom.github.io/ref-man/lepton-refdes_renum.html)


Usage
=====

1. On the command line:
```
# export LEPTON=/path/to/lepton-eda
# ./run.sh SCHEMATIC ...
```

2. In `REPL` or lepton-schematic `:` prompt:
```scheme
( use-modules (lepton renum) )

( refdes-renum (active-page) ) ; renumber all refdes'
( refdes-renum (active-page) #:unset-only #t ) ; renumber unset only, e.g. `R?`
```

