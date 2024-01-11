#lang scribble/manual

@title{svg-path-qcurve/qcurve*}

@image{showcase/path/qcurve.jpg}

@codeblock|{
  (svg-path-qcurve
  (-> (cons/c integer? integer?) (cons/c integer? integer?))
  void?)
}|
  use two control points to draw a Quadratic Bezier Curve.

  qcurve use relative position, relative to the start position.

@codeblock|{
  (svg-path-qcurve*
  (-> (cons/c integer? integer?) (cons/c integer? integer?))
  void?)
}|

@codeblock|{
(let ([path
        (svg-def-path
          (lambda ()
          (svg-path-moveto* '(10 . 60))
          (svg-path-qcurve* '(60 . 10) '(110 . 60))
          (svg-path-qcurve* '(160 . 110) '(210 . 60))))
        ]
        [path_style (sstyle-new)]
        [red_dot (svg-def-circle 5)]
        [dot_style (sstyle-new)])

  (sstyle-set! path_style 'stroke "#333333")
  (sstyle-set! path_style 'stroke-width 3)
  (svg-use-shape path path_style)

  (sstyle-set! dot_style 'fill "red")
  (svg-use-shape red_dot dot_style #:at? '(10 . 60))
  (svg-use-shape red_dot dot_style #:at? '(60 . 10))
  (svg-use-shape red_dot dot_style #:at? '(110 . 60))
  (svg-use-shape red_dot dot_style #:at? '(160 . 110))
  (svg-use-shape red_dot dot_style #:at? '(210 . 60))

  (svg-show-default))
}|

@codeblock|{
(svg-path-moveto* '(10 . 60))
(svg-path-qcurve '(50 . -50) '(100 . 0))
(svg-path-qcurve '(50 . 50) '(100 . 0))
}|

little red pots show the control points.

@image{showcase/path/qcurve1.svg}
