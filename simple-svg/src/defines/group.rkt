#lang racket

(provide (contract-out
          [struct GROUP
                  (
                   (widget_list (listof string?))
                   (widget_locate_map (hash/c string? (cons natural? natural?)))
                   )
                  ]
          ))

(struct GROUP (
              [widget_list #:mutable]
              [widget_locate_map #:mutable]
              )
        #:transparent
        )

(define (new-group group_name user-proc)
  (let ([group (GROUP '() (make-hash))])
    (user-proc group)))


