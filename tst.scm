
( define-public ( tst )
  ( format #t "Rx: [~a]~%" ( refdes-set? "Rx" ) )
  ( format #t "Rx123: [~a]~%" ( refdes-set? "Rx123" ) )
  ( if ( refdes-set? "Rx123" )
    ( format #t "Rx123: [set]~%" )
  )
  ( format #t "Rx?: [~a]~%" ( refdes-set? "Rx?" ) )
  ( if ( refdes-unset? "Rx?" )
    ( format #t "Rx?: [not set]~%" )
  )
)
