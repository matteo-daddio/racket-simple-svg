#lang scribble/manual

@(require "../../main.rkt")

@(require (for-label racket))
@(require (for-label "../../path/path.rkt"))

@title{Path}

define a path programmtially.

@defproc[(svg-path-def
          [procedure procedure?]
        )
        void?]{
  all path actions should be include in this procedure: moveto, curve etc.
}

@include-section{raw-path.scrbl}

@include-section{moveto.scrbl}

@include-section{close.scrbl}

@include-section{lineto.scrbl}

@include-section{qcurve.scrbl}

@include-section{ccurve.scrbl}

@include-section{arc.scrbl}
