#lang racket

(require "rect.rkt")
(require "pos.rkt")
(require "view-box.rkt")
(require "group.rkt")

(provide (contract-out
          [struct SVG
                  (
                   (widget_index_count natural?)
                   (width natural?)
                   (height natural?)
                   (view_box (or/c #f VIEW-BOX?))
                   (shape_define_map (hash/c string? (or/c RECT?)))
                   (group_define_map (hash/c string? GROUP?))
                   (group_show_list (listof (cons string? POS?)))
                   )
                  ]
          [new-svg (-> natural? natural? SVG?)]
          [*SVG* (parameter/c (or/c #f SVG?))]
          ))

(define *SVG* (make-parameter #f))

(struct SVG (
             [widget_index_count #:mutable]
             [width #:mutable]
             [height #:mutable]
             [view_box #:mutable]
             [shape_define_map #:mutable]
             [group_define_map #:mutable]
             [group_show_list #:mutable]
             )
        #:transparent
        )

(define (new-svg width height)
  (SVG 0 width height #f (make-hash) (make-hash) '()))

