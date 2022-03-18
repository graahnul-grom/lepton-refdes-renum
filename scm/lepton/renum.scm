( define-module ( lepton renum )
  #:use-module ( ice-9  optargs ) ; define*-public
  #:use-module ( ice-9  regex )
  #:use-module ( lepton attrib )
  #:use-module ( lepton page )
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



; {ret}: list of attr objs named "refdes"
;
( define-public ( filter-refdes-objs objs )
( let
  (
  ( res '() )
  )

  ( define ( attr-name-match? obj )
    ; return:
    ( and
      ( attribute? obj )
      ( string=? (attrib-name obj) "refdes" )
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



; [aobjs]: attr objs
; [ht]:    hash table: [refdes prefix] => [list of attr objs]
;
( define*-public ( mk-mapping aobjs #:optional ( ht (make-hash-table) ) )
( let
  (
  ( key  #f ) ; refdes prefix
  ( val '() ) ; list of attr objs
  )

  ( for-each
  ( lambda( a )
    ( set! key ( refdes-prefix a ) )
    ( when key
        ( set! val ( hash-ref ht key '() ) ) ; '() <=> dflt val if no such key
        ; was: ( set! val (cons a val) )
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
      ( format #t "  value: [~a]~%" value )
    ( set! n (1+ n) )
  )
    aobjs
  )
) ; let
)

( define-public ( refdes-renum page )
( let*
  (
  ( objs  ( page-contents page ) )
  ( aobjs ( filter-refdes-objs objs ) )
  ( ht    ( mk-mapping aobjs ) )
  )

  ( format #t "refdes-renum( ~s )~%" ( basename (page-filename page) ) )

  ( hash-for-each
  ( lambda( key val ) ; key: refdes prefix, val: list of aobjs
    ( format #t "~a => ~{~a ~}~%" key (map attrib-value val) )
    ( refdes-renum-impl val )
  )
    ht
  )

) ; let
) ; refdes-renum()



; vim: ft=scheme tabstop=2 softtabstop=2 shiftwidth=2 expandtab

