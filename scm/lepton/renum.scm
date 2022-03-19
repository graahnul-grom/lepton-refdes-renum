( define-module ( lepton renum )
  #:use-module ( ice-9  regex )
  #:use-module ( lepton attrib )
  #:use-module ( lepton page )

  #:export ( refdes-renum )
)



; private:
;
; [rd]:  can be either string or attr obj
; {ret}: #t if refdes is set, e.g. R1
;
( define ( refdes-set? rd )
( let
  (
  ( refdes ( if (attribute? rd) (attrib-value rd) rd ) )
  ( re     ( make-regexp "[a-zA-Z_-]+[0-9]+" ) )
  )

  ; return:
  ( if ( regexp-exec re refdes )
    #t
    #f
  )

) ; let
) ; refdes-set?()



; private:
;
; [rd]:  can be either string or attr obj
; {ret}: #t if refdes is not set, e.g. R?
;
( define ( refdes-unset? rd )
( let
  (
  ( refdes ( if (attribute? rd) (attrib-value rd) rd ) )
  ( re     ( make-regexp "[a-zA-Z_-]+\\?" ) )
  )

  ; return:
  ( if ( regexp-exec re refdes )
    #t
    #f
  )

) ; let
) ; refdes-unset?()



; private:
;
; [rd]:  can be either string or attr obj
; {ret}: ( cons prefix suffix )
;
( define ( refdes-split rd )
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

( define ( refdes-prefix rd )
  ( car ( refdes-split rd ) )
)

( define ( refdes-suffix rd )
  ( cdr ( refdes-split rd ) )
)



; private:
;
; {ret}: list of attr objs named "refdes"
;
( define ( filter-refdes-objs objs unset-only )
( let
  (
  ( res '() )
  )

  ( define ( attr-name-match? obj )
    ; return:
    ( and
      ( attribute? obj )
      ( string=? (attrib-name obj) "refdes" )
      ( if unset-only
        ( refdes-unset? obj )
      )
    )
  )

  ( define ( add-aobj aobj )
    ( set! res ( cons aobj res ) )
  )

  ( for-each
    add-aobj
    ( filter attr-name-match? objs )
  )

  ; return:
  ( reverse res )

) ; let
) ; filter-refdes-objs()



; private:
;
; [aobjs]: attr objs
; {ret}    hash table: [refdes prefix] => [list of attr objs]
;
( define ( mk-mapping aobjs )
( let
  (
  ( ht  ( make-hash-table ) )
  ( key  #f ) ; refdes prefix
  ( val '() ) ; list of attr objs
  )

  ( for-each
  ( lambda( a )
    ( set! key ( refdes-prefix a ) )
    ( when key
        ( set! val ( hash-ref ht key '() ) ) ; '() <=> dflt val if no such key
        ; NOTE: was: ( set! val (cons a val) )
        ( set! val ( append val (list a) ) )
        ( hash-set! ht key val )
    )
  )
    aobjs
  )

  ; return:
  ht

) ; let
) ; mk-mapping()



; private:
;
( define ( refdes-renum-impl aobjs )
( let
  (
  ( n 1 )
  ( prefix "" )
  ( value "" )
  )

  ( for-each
  ( lambda( a )
    ( set! prefix (refdes-prefix a) )
    ( set! value (format #f "~a~a" prefix n) )
      ( format #t "  value: ~a => ~20t~a~%" (attrib-value a) value )

    ( set-attrib-value! a value )

    ( set! n (1+ n) )
  )
    aobjs
  )
) ; let
) ; refdes-renum-impl()



; public:
;
( define* ( refdes-renum page #:key (unset-only #f) )
( let*
  (
  ( aobjs ( filter-refdes-objs (page-contents page) unset-only ) )
  ( ht    ( mk-mapping aobjs ) )
  )

  ( define ( page-save )
    ( if ( page-dirty? page )
      ( with-output-to-file
        ( page-filename page )
        ( lambda()
          ( format #t (page->string page) )
        )
      )
    )
  ) ; page-save()


  ( format #t "refdes-renum( ~s )~%" ( basename (page-filename page) ) )

  ( hash-for-each
  ( lambda( key val ) ; key: refdes prefix, val: list of aobjs
    ( format #t "~a => ~{~a ~}~%" key (map attrib-value val) )

    ( refdes-renum-impl val )
    ; ( page-save )
  )
    ht
  )

) ; let
) ; refdes-renum()



; vim: ft=scheme tabstop=2 softtabstop=2 shiftwidth=2 expandtab

