#lang racket

(require "rect.rkt")

(provide (contract-out
          [struct SVG
                  (
                   (shape_define_map (hash/c string? (or/c RECT?)))
                   (group_define_map (hash/c string? GROUP?))
                   (show_define_map (hash/c string? SHOW?))
                   (show_list (listof SHOW?))
                   )
                  ]
          ))

