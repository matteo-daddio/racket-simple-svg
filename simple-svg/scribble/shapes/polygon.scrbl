#lang scribble/manual

@title{Polygon}

@codeblock{
  (svg-def-polygon (-> (listof (cons/c natural? natural?)) string?))
}

define a polygon by points list.

@section{polygon}

@codeblock{
(let ([polygon
         (svg-def-polygon
           '((0 . 25) (25 . 0) (75 . 0) (100 . 25) (100 . 75) (75 . 100) (25 . 100) (0 . 75)))]
      [_sstyle (sstyle-new)])

  (sstyle-set! _sstyle 'stroke-width 5)
  (sstyle-set! _sstyle 'stroke "#765373")
  (sstyle-set! _sstyle 'fill "#ED6E46")

  (svg-use-shape polygon _sstyle #:at? '(5 . 5))
  (svg-show-default))
}
@image{showcase/shapes/polygon/polygon.svg}

