#lang racket

(provide (contract-out
          [struct VIEW-BOX
                  (
                   (min_x natural?)
                   (min_y natural?)
                   (width natural?)
                   (height natural?)
                   )
                  ]
          ))

(struct VIEW-BOX (
              [min_x #:mutable]
              [min_y #:mutable]
              [width #:mutable]
              [height #:mutable]
              )
        #:transparent
        )


