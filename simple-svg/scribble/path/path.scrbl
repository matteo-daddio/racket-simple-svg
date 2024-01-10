#lang scribble/manual

@title{Path}

@codeblock{
  (svg-def-path (-> procedure? string?))
}

  all path actions should be include in this procedure: moveto, curve etc.


@include-section{raw-path.scrbl}
@include-section{moveto.scrbl}
@include-section{close.scrbl}
@include-section{lineto.scrbl}
@include-section{qcurve.scrbl}
@include-section{ccurve.scrbl}
@include-section{arc.scrbl}
