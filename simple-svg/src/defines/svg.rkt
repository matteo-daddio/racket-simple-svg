#lang racket

(provide (contract-out
          [struct SVG
                  (
                   (group_show_list (listof string?))
                   (shapes_map (hash/c string? (or/c RECT CIRCLE ELLIPSE LINE POLYGON POLYLINE)))
                   )
                  ]
          ))

