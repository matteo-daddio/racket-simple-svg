#lang racket

(provide (contract-out
          [struct POS
                  (
                   (x natural?)
                   (y natural?)
                   )
                  ]
          ))

(struct POS (
              [x #:mutable]
              [y #:mutable]
              )
        #:transparent
        )
