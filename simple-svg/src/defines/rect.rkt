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
          ))

(struct RECT (
              [width #:mutable]
              [height #:mutable]
              [radius_x #:mutable]
              [radius_y #:mutable]
              )
        #:transparent
        )

(define (new-rect shape_name width height
                  #:radius_x [radius_x #f]
                  #:radius_y [radius_y #f])
  (RECT width height radius_x radius_y))


