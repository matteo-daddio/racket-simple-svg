#lang racket

(provide (contract-out
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
          [format-rect (-> string? RECT? string?)]
          ))

(struct RECT (
              [width #:mutable]
              [height #:mutable]
              [radius_x #:mutable]
              [radius_y #:mutable]
              )
        #:transparent
        )

(define (new-rect width height #:radius_x [radius_x #f] #:radius_y [radius_y #f])
  (RECT width height radius_x radius_y))

(define (format-rect shape_id rect)
  (format "    <rect id=\"~a\" ~a/>\n"
          shape_id
          (with-output-to-string
            (lambda ()
              (printf "width=\"~a\" height=\"~a\" "
                      (RECT-width rect)
                      (RECT-height rect))
                             
              (when (and (RECT-radius_x rect) (RECT-radius_y rect))
                (printf "rx=\"~a\" ry=\"~a\" "
                        (RECT-radius_x rect)
                        (RECT-radius_y rect)))
              ))))



