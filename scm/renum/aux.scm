( define-module ( renum aux )
  #:use-module  ( ice-9 regex )
  #:use-module  ( geda attrib )
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



( define-public ( eklmn )
  ( format #t " .. (renum aux)::eklmn()~%" )

  ( format #t ": [~a]~%" ( refdes-prefix "Rrr?" ) )
  ( format #t ": [~a]~%" ( refdes-suffix "Rrr?" ) )
)

; vim: ft=scheme tabstop=2 softtabstop=2 shiftwidth=2 expandtab

