#lang racket

(require "sstyle.rkt")
(require "pos.rkt")

(provide (contract-out
          [struct GROUP
                  (
                   (widget_list (listof string?))
                   (widget_locate_map (hash/c string? POS?))
                   (widget_style_map (hash/c string? sstyle/c))
                   )
                  ]
          ))

(struct GROUP (
              [widget_list #:mutable]
              [widget_locate_map #:mutable]
              [widget_style_map #:mutable]
              )
        #:transparent
        )
