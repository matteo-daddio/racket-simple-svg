#lang scribble/manual

@(require "../../main.rkt")

@(require (for-label racket))
@(require (for-label "../../shapes/polygon.rkt"))

@title{Polygon}

draw a polygon.

@defproc[(svg-polygon-def
          [points (listof pair?)]
        )
        string?]{
  draw a polygon by points list.
}

@section{polygon}

@codeblock{
(let ([polygon
  (svg-polygon-def
    '((0 . 25) (25 . 0) (75 . 0) (100 . 25) (100 . 75) (75 . 100) (25 . 100) (0 . 75)))])
    (svg-use polygon #:stroke? '(5 . "#765373") #:fill? "#ED6E46")
    (svg-show-default))
}

@image{showcase/shapes/polygon/polygon.svg}

