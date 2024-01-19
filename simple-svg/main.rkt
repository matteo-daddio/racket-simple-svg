#lang racket

(require "src/assemble.rkt")

(provide (contract-out
          [svg-out (->* (natural? natural? procedure?)
                        (
                         #:viewBox? (or/c #f VIEW-BOX?)
                        )
                        string?)]
          [struct RECT
                  (
                   (width natural?)
                   (height natural?)
                   (radius_x (or/c #f natural?))
                   (radius_y (or/c #f natural?))
                   )
                  ]
          [new-rect (->* (natural? natural?)
                         (
                          #:radius_x (or/c #f natural?)
                          #:radius_y (or/c #f natural?)
                         )
                         RECT?
                         )]
          [svg-def-shape (-> (or/c RECT?) string?)]
          [svg-def-group (-> procedure? string?)]
          [struct SSTYLE
                  (
                   (fill (or/c #f string?))
                   (fill-rule (or/c #f 'nonzero 'evenodd 'inerit))
                   (fill-opacity (or/c #f (between/c 0 1)))
                   (stroke (or/c #f string?))
                   (stroke-width (or/c #f natural?))
                   (stroke-linecap (or/c #f 'butt 'round 'square 'inherit))
                   (stroke-linejoin (or/c #f 'miter 'round 'bevel))
                   (stroke-miterlimit (or/c #f (>=/c 1)))
                   (stroke-dasharray (or/c #f string?))
                   (stroke-dashoffset (or/c #f natural?))
                   (translate (or/c #f (cons/c natural? natural?)))
                   (rotate (or/c #f integer?))
                   (scale (or/c #f natural? (cons/c natural? natural?)))
                   (skewX (or/c #f natural?))
                   (skewY (or/c #f natural?))
                   (fill-gradient (or/c #f string?))
                   )]
          [sstyle-new (-> sstyle/c)]
          [struct POS
                  (
                   (x natural?)
                   (y natural?)
                   )
                  ]
          [svg-place-widget (->* (string?)
                                 (
                                  #:sstyle? SSTYLE?
                                  #:at? POS?
                                 )
                                 void?)]
          [svg-show-group (->* (string?)
                               (
                                #:at? POS?
                               )
                               void?)]
          ))
