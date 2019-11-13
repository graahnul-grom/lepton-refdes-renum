( define-module ( renum dbg )
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

; vim: ft=scheme tabstop=2 softtabstop=2 shiftwidth=2 expandtab

