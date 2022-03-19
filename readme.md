lepton-refdes-renum
===================

Batch `refdes` renumbering utility.<br />
Implementing `lepton-refdes_renum` Perl script
functionality in `Guile`.


Usage
=====

1. On the command line:
```
# export LEPTON=/path/to/lepton-eda
# ./run.sh renum-test-0.sch
```

2. In REPL or `:` prompt:
```scheme
( use-modules (lepton renum) )

( refdes-renum (active-page) ) ; renumber all refdes'
( refdes-renum (active-page) #:unset-only #true ) ; renumber unset only
```

