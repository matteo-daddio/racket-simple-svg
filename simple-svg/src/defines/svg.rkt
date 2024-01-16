#lang racket

(require "rect.rkt")
(require "pos.rkt")

(provide (contract-out
          [struct SVG
                  (
                   (shape_define_map (hash/c string? (or/c RECT?)))
                   (group_define_map (hash/c string? GROUP?))
                   (show_pos_map (hash/c string? POS?))
                   (show_list (listof string?))
                   )
                  ]
          ))

(struct SVG (
             [shape_define_map #:mutable]
             [group_define_map #:mutable]
             [show_pos_map #:mutable]
             [show_list #:mutable]
             )
        #:transparent
        )

