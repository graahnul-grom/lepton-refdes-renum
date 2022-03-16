( define-module ( lepton renum-dbg )
  #:use-module ( ice-9 format )
  #:use-module ( lepton attrib )
  #:use-module ( lepton page )
  #:use-module ( lepton renum aux )
)



( define-public ( dbg-out-attrs attrs )

  ( define ( out-attr attr )
    ( format #t "~a" (attrib-value attr) )
    ( format #t " " )
  )

  ( for-each
    out-attr
    attrs
  )

  ( format #t "~%" )

)



( define-public ( dbg-out-files files )

  ( define ( out-objs objs )
    ( dbg-out-attrs (filter-aobjs objs) )
  )

  ( define ( out-page page )
    ( out-objs (page-contents page) )
  )

  ( define ( out-file file )
    ( format #t "file: ~a~%" file )
    ( out-page (file->page file) )
  )


  ( for-each out-file files)

) ; dbg-out-files()



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

