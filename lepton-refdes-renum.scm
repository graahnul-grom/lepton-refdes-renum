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
( primitive-eval '(use-modules (geda log)) )



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
  ( page   #f )
  ( pages '() )
  ( aobjs '() )
  )

  ( define ( filter-aobjs-on-page page )
    ( filter-aobjs (page-contents page) "refdes" )
  )


  ( set! pages ( map file->page files ) )

  ; all attrs on all pages:
  ;
  ( for-each
  ( lambda( p )
    ( set! aobjs ( append aobjs (filter-aobjs-on-page p) ) )
  )
    pages
  )

  ( dbg-out-attrs aobjs )


  ; attrs on each page:
  ;
  ( format #t "files: [~a]~%" files )
  ( for-each
  ( lambda( file )
    ( format #t "f: [~a]~%" file )
    ( set! page ( file->page file ) )
    ; ( dbg-out-mapping ( mk-mapping (filter-aobjs (page-contents page)) ) )
    ( set! aobjs ( filter-aobjs-on-page page ) )
    ( dbg-out-attrs aobjs )
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
    ;
    ; gotcha: w/o init-log() call, warnings about loaded RC files
    ;         will be printed to STDERR:
    ;
    ( init-log "refdes-renum" )

    ( main )
  )
)

