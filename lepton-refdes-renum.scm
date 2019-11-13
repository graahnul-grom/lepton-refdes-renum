#!/usr/bin/env sh
export GUILE_AUTO_COMPILE=0
exec guile "$0" "$@"
!#

;;
;; Lepton EDA
;; lepton-refdes-renum - batch refdes renumbering utility
;; Copyright (C) 2019 dmn <graahnul.grom@gmail.com>
;; License: GPLv2+. See the COPYING file
;;

( load-extension
  ( or (getenv "LIBLEPTON") "/home/dmn/lepton/bin.master/lib/liblepton" )
  "libgeda_init"
)

( use-modules ( ice-9 getopt-long ) )
( use-modules ( ice-9 format ) )

( primitive-eval '(use-modules (geda core toplevel)) )
( primitive-eval '(use-modules (geda object)) )
( primitive-eval '(use-modules (lepton page)) )
( primitive-eval '(use-modules (lepton version)) )
; ( primitive-eval '(use-modules (lepton renum aux)) )
; ( primitive-eval '(use-modules (lepton renum dbg)) )



; command line options:
;
( define cmd-line-args-spec
( list
  ( list ; --help (-h)
    'help
    ( list 'single-char #\h )
    ( list 'value        #f )
  )
)
) ; cmd-line-args-spec



( define ( tst files )
( let
  (
  ( p #f )
  )

  ( format #t "files: [~a]~%" files )
  ( for-each
  ( lambda( f )
    ( format #t "f: [~a]~%" f )
  )
    files
  )

) ; let
) ; tst()



( define ( main )
( let
  (
  ( cmd-line-args '() )
  ( files         '() )
  )

  ( set! cmd-line-args
    ( getopt-long (program-arguments) cmd-line-args-spec )
  )

  ( set! files ( option-ref cmd-line-args '() '() ) )
  ( if ( null? files )
    ( primitive-exit 11 )
  )

  ( (@@ (guile-user) parse-rc) "lepton-refdes-renum" "gafrc" )
  ( use-modules ( lepton renum aux ) )
  ( use-modules ( lepton renum dbg ) )

  ( tst files )

) ; let
) ; main()




( %with-toplevel
  ( %make-toplevel )
  ( lambda()
    ( main )
  )
)

