#lang racket

(provide (contract-out
          [struct GROUP
                  (
                   (group_index string?)
                   (shape_list (listof string?))
                   (shape_locate_map (hash/c string? (cons natural? natural?)))
                   )
                  ]
          ))

(struct GROUP (
              [shape_list #:mutable]
              [shape_locate_map #:mutable]
              )
        #:transparent
        )

(define (new-group group_index width height
                 #:radius_x? [radius_x? #f]
                 #:radius_y? [radius_y? #f])
  (GROUP width height radius_x? radius_y?))


