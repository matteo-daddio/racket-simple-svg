#lang racket

(require "rect.rkt")
(require "pos.rkt")

(provide (contract-out
          [struct SVG
                  (
                   (widget_index_count natural?)
                   (shape_define_map (hash/c string? (or/c RECT?)))
                   (group_define_map (hash/c string? GROUP?))
                   (group_show_list (listof (cons string? POS?)))
                   )
                  ]
          [new-svg (-> SVG?)]
          [*SVG* (parameter/c (or/c #f SVG?))]
          ))

(define *SVG* (make-parameter #f))

(struct SVG (
             [widget_index_count #:mutable]
             [shape_define_map #:mutable]
             [group_define_map #:mutable]
             [group_show_list #:mutable]
             )
        #:transparent
        )

(define (new-svg)
  (SVG 0 (make-hash) (make-hash) '()))

