#lang scribble/manual

@(require "../../main.rkt")

@(require (for-label racket))
@(require (for-label "../../path/ccurve.rkt"))

@title{ccurve/ccurve*}

@image{showcase/path/ccurve.jpg}

use three control points to draw a Cubic Bezier Curve.

@defproc[(ccurve
          [point1 (cons/c natural? natural?) void?]
          [point2 (cons/c natural? natural?) void?]
          [point3 (cons/c natural? natural?) void?]
        )
        void?]{
  ccurve use relative position.
  ccurve* use absolute position.
}

@codeblock{
  (path
    #:stroke-fill? "#333333"
    #:stroke-width? 3
    (lambda ()
      (moveto* '(0 . 50))
      (ccurve* '(20 . 5) '(70 . 5) '(90 . 50))
      (ccurve* '(110 . 95) '(160 . 95) '(180 . 50))))
}

little red pots show the control points.

@image{showcase/path/ccurve*.svg}
