#lang racket

(provide (contract-out
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
          [sstyle-new (-> SSTYLE?)]
          [sstyle-format (-> SSTYLE? string?)]
          ))

(struct SSTYLE (
                fill
                fill-rule
                fill-opacity
                stroke
                stroke-width
                stroke-linecap
                stroke-linejoin
                stroke-miterlimit
                stroke-dasharray
                stroke-dashoffset
                translate
                rotate
                scale
                skewX
                skewY
                fill-gradient
                )
        #:transparent
        #:mutable)

(define (sstyle-new)
  (SSTYLE
   #f #f #f #f #f #f #f #f #f #f
   #f #f #f #f #f #f))

(define (sstyle-format _sstyle)
  (with-output-to-string
    (lambda ()
      (cond
       [(SSTYLE-fill-gradient _sstyle)
        (printf "fill=\"url(#~a)\" " (SSTYLE-fill-gradient _sstyle))]
       [else
        (when (SSTYLE-fill _sstyle)
          (printf "fill=\"~a\" " (SSTYLE-fill _sstyle)))])

      (when (SSTYLE-fill-rule _sstyle)
            (printf "fill-rule=\"~a\" " (SSTYLE-fill-rule _sstyle)))

      (when (SSTYLE-fill-opacity _sstyle)
            (printf "fill-opacity=\"~a\" " (SSTYLE-fill-opacity _sstyle)))


      (when (SSTYLE-stroke-width _sstyle)
            (printf "stroke-width=\"~a\" " (SSTYLE-stroke-width _sstyle))

            (when (SSTYLE-stroke _sstyle)
                  (printf "stroke=\"~a\" " (SSTYLE-stroke _sstyle)))

            (when (SSTYLE-stroke-linejoin _sstyle)
                  (printf "stroke-linejoin=\"~a\" " (SSTYLE-stroke-linejoin _sstyle)))

            (when (SSTYLE-stroke-linecap _sstyle)
                  (printf "stroke-linecap=\"~a\" " (SSTYLE-stroke-linecap _sstyle)))

            (when (SSTYLE-stroke-miterlimit _sstyle)
                  (printf "stroke-miterlimit=\"~a\" " (SSTYLE-stroke-miterlimit _sstyle)))

            (when (SSTYLE-stroke-dasharray _sstyle)
                  (printf "stroke-dasharray=\"~a\" " (SSTYLE-stroke-dasharray _sstyle)))

            (when (SSTYLE-stroke-dashoffset _sstyle)
                  (printf "stroke-dashoffset=\"~a\" " (SSTYLE-stroke-dashoffset _sstyle)))
            )
      
      (when (or
             (SSTYLE-translate _sstyle)
             (SSTYLE-rotate _sstyle)
             (SSTYLE-scale _sstyle)
             (SSTYLE-skewX _sstyle)
             (SSTYLE-skewY _sstyle)
             )
            (printf "transform=\"")

            (when (SSTYLE-translate _sstyle)
                  (printf "translate(~a ~a) "
                          (car (SSTYLE-translate _sstyle))
                          (cdr (SSTYLE-translate _sstyle))))
            
            (when (SSTYLE-rotate _sstyle)
                  (printf "rotate(~a) " (SSTYLE-rotate _sstyle)))

            (when (SSTYLE-scale _sstyle)
                  (if (pair? (SSTYLE-scale _sstyle))
                      (printf "scale(~a ~a) "
                              (car (SSTYLE-scale _sstyle))
                              (cdr (SSTYLE-scale _sstyle)))
                      (printf "scale(~a) " (SSTYLE-scale _sstyle))))
            
            (when (SSTYLE-skewX _sstyle)
                  (printf "skewX(~a) " (SSTYLE-skewX _sstyle)))

            (when (SSTYLE-skewY _sstyle)
                  (printf "skewY(~a) " (SSTYLE-skewY _sstyle)))
            
            (printf "\""))
      )))
