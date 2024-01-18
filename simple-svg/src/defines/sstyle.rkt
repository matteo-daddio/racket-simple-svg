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
          [sstyle-new (-> sstyle/c)]
          [sstyle-format (-> sstyle/c string?)]
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

(define sstyle/c
  (struct/dc
   sstyle
     [fill (or/c #f string?)]
     [fill-rule (or/c #f 'nonzero 'evenodd 'inerit)]
     [fill-opacity (or/c #f (between/c 0 1))]
     [stroke (or/c #f string?)]
     [stroke-width (or/c #f natural?)]
     [stroke-linecap (or/c #f 'butt 'round 'square 'inherit)]
     [stroke-linejoin (or/c #f 'miter 'round 'bevel)]
     [stroke-miterlimit (or/c #f (>=/c 1))]
     [stroke-dasharray (or/c #f string?)]
     [stroke-dashoffset (or/c #f natural?)]
     [translate (or/c #f (cons/c natural? natural?))]
     [rotate (or/c #f integer?)]
     [scale (or/c #f natural? (cons/c natural? natural?))]
     [skewX (or/c #f natural?)]
     [skewY (or/c #f natural?)]
     [fill-gradient (or/c #f string?)]
    ))

(define (sstyle-new)
  (sstyle
   #f #f #f #f #f #f #f #f #f #f
   #f #f #f #f #f #f))

(define (sstyle-format _sstyle)
  (with-output-to-string
    (lambda ()
      (cond
       [(sstyle-fill-gradient _sstyle)
        (printf "fill=\"url(#~a)\" " (sstyle-fill-gradient _sstyle))]
       [else
        (when (sstyle-fill _sstyle)
          (printf "fill=\"~a\" " (sstyle-fill _sstyle)))])

      (when (sstyle-fill-rule _sstyle)
            (printf "fill-rule=\"~a\" " (sstyle-fill-rule _sstyle)))

      (when (sstyle-fill-opacity _sstyle)
            (printf "fill-opacity=\"~a\" " (sstyle-fill-opacity _sstyle)))


      (when (sstyle-stroke-width _sstyle)
            (printf "stroke-width=\"~a\" " (sstyle-stroke-width _sstyle))

            (when (sstyle-stroke _sstyle)
                  (printf "stroke=\"~a\" " (sstyle-stroke _sstyle)))

            (when (sstyle-stroke-linejoin _sstyle)
                  (printf "stroke-linejoin=\"~a\" " (sstyle-stroke-linejoin _sstyle)))

            (when (sstyle-stroke-linecap _sstyle)
                  (printf "stroke-linecap=\"~a\" " (sstyle-stroke-linecap _sstyle)))

            (when (sstyle-stroke-miterlimit _sstyle)
                  (printf "stroke-miterlimit=\"~a\" " (sstyle-stroke-miterlimit _sstyle)))

            (when (sstyle-stroke-dasharray _sstyle)
                  (printf "stroke-dasharray=\"~a\" " (sstyle-stroke-dasharray _sstyle)))

            (when (sstyle-stroke-dashoffset _sstyle)
                  (printf "stroke-dashoffset=\"~a\" " (sstyle-stroke-dashoffset _sstyle)))
            )
      
      (when (or
             (sstyle-translate _sstyle)
             (sstyle-rotate _sstyle)
             (sstyle-scale _sstyle)
             (sstyle-skewX _sstyle)
             (sstyle-skewY _sstyle)
             )
            (printf "transform=\"")

            (when (sstyle-translate _sstyle)
                  (printf "translate(~a ~a) "
                          (car (sstyle-translate _sstyle))
                          (cdr (sstyle-translate _sstyle))))
            
            (when (sstyle-rotate _sstyle)
                  (printf "rotate(~a) " (sstyle-rotate _sstyle)))

            (when (sstyle-scale _sstyle)
                  (if (pair? (sstyle-scale _sstyle))
                      (printf "scale(~a ~a) "
                              (car (sstyle-scale _sstyle))
                              (cdr (sstyle-scale _sstyle)))
                      (printf "scale(~a) " (sstyle-scale _sstyle))))
            
            (when (sstyle-skewX _sstyle)
                  (printf "skewX(~a) " (sstyle-skewX _sstyle)))

            (when (sstyle-skewY _sstyle)
                  (printf "skewY(~a) " (sstyle-skewY _sstyle)))
            
            (printf "\""))
      )))
