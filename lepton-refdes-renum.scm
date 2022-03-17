#!/usr/bin/env sh
export LD_LIBRARY_PATH=/home/dmn/lepton/bin.master/lib
export GUILE_AUTO_COMPILE=0
exec guile "$0" "$@"
!#

;;
;; Lepton EDA
;; lepton-refdes-renum - batch refdes renumbering utility
;; Copyright (C) 2019-2022 dmn <graahnul.grom@gmail.com>
;; License: GPLv2+. See the COPYING file
;;

( eval-when ( expand load eval )
  ( unless ( getenv "LIBLEPTON" )
    ( add-to-load-path "/home/dmn/lepton/bin.master/share/lepton-eda/scheme")
    ( set!
      %load-compiled-path
      ( cons "/home/dmn/lepton/bin.master/share/lepton-eda/ccache" %load-compiled-path )
    )
  )
)

( use-modules ( ice-9 getopt-long ) )
( use-modules ( ice-9 format ) )
( use-modules ( lepton ffi ) )
( use-modules ( lepton toplevel ) )
( use-modules ( lepton object ) )
( use-modules ( lepton page ) )
( use-modules ( lepton version ) )
( use-modules ( lepton log ) )
( use-modules ( lepton rc ) )

( liblepton_init )
( unless ( getenv "LEPTON_INHIBIT_RC_FILES" )
  ( register-data-dirs )
)
( edascm_init )



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

  ( parse-rc "lepton-refdes-renum" "gafrc" )
  ( use-modules ( lepton renum ) )
  ( use-modules ( lepton renum-dbg ) )

  ; ( dbg-out-files files )

  ( for-each
  ( lambda ( file )
    ( refdes-renum (file->page file) )
  )
    files
  )

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

; vim: ft=scheme tabstop=2 softtabstop=2 shiftwidth=2 expandtab

