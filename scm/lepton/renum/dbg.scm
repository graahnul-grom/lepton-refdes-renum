( define-module ( lepton renum dbg )
  #:use-module ( ice-9 format )
  #:use-module ( geda  attrib )
)



( define-public ( dbg-out-attrs attrs )
  ( for-each
  ( lambda( a )
    ( if ( attribute? a )
      ( format #t "[~a=~a]" (attrib-name a) (attrib-value a) )
      ( format #t "[!a: ~a]" a )
    )
    ( format #t " " )
  )
  attrs
  )
  ( format #t "~%" )
)



; [ht]: hash table: [refdes prefix] => [list of attr objs]
;
( define-public ( dbg-out-mapping ht )
  ( hash-for-each
  ( lambda( key val )
    ( format #t "~a => " key )
    ( dbg-out-attrs val )
  )
    ht
  )
)

; vim: ft=scheme tabstop=2 softtabstop=2 shiftwidth=2 expandtab

