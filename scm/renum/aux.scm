( define-module ( renum aux )
  #:use-module ( ice-9  optargs ) ; define*-public
  #:use-module ( ice-9  regex )
  #:use-module ( geda   attrib )
  #:use-module ( lepton page )
  #:use-module ( renum  dbg )
)



; [rd]:  can be either string or attr obj
; {ret}: ( cons prefix suffix )
;
( define-public ( refdes-split rd )
( let*
  (
  ( refdes ( if (attribute? rd) (attrib-value rd) rd ) )
  ( re     ( make-regexp "([a-zA-Z_-]+)(\\?|[0-9]+)" ) )
  ( res    ( regexp-exec re refdes ) )
  ( prefix ( if res (match:substring res 1) #f ) )
  ( suffix ( if res (match:substring res 2) #f ) )
  )

  ; return:
  ( cons prefix suffix )

) ; let
) ; refdes-split()

( define-public ( refdes-prefix rd )
  ( car ( refdes-split rd ) )
)

( define-public ( refdes-suffix rd )
  ( cdr ( refdes-split rd ) )
)



; {ret}: list of attr objs named [aname]
;
( define*-public ( filter-aobjs objs #:optional (aname "refdes") )
( let
  (
  ( res '() )
  )

  ( define ( attr-name-match? obj )
    ; return:
    ( and
      ( attribute? obj )
      ( string=? (attrib-name obj) aname )
    )
  )

  ( define ( add-aobj aobj )
    ( set! res ( cons aobj res ) )
  )

  ( for-each add-aobj (filter attr-name-match? objs) )

  ; return:
  ( reverse res )

) ; let
) ; filter-aobjs()




( define-public ( eklmn )
( let
  (
  ( p  #f )
  ( aa #f )
  )

  ( format #t " .. (renum aux)::eklmn()~%" )

  ( set! p ( file->page "tst0.sch" ) )
  ( set! aa ( filter-aobjs (page-contents p) ) )
  ( format #t "aa: [~a]~%" aa )
  ( dbg-out-attrs aa )
  ( dbg-out-attrs ( list 'qqq 123 ) )

) ; let
) ; eklmn()

; vim: ft=scheme tabstop=2 softtabstop=2 shiftwidth=2 expandtab

