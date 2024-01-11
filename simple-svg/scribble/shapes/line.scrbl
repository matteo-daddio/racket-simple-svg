#lang scribble/manual

@title{Line}

@codeblock|{
  (svg-def-line (-> (cons/c natural? natural?) (cons/c natural? natural?) string?))
}|

@section{line}

@codeblock|{
(let ([line (svg-def-line '(0 . 0) '(100 . 100))]
      [_sstyle (sstyle-new)])

  (sstyle-set! _sstyle 'stroke-width 10)
  (sstyle-set! _sstyle 'stroke "#765373")
  (svg-use-shape line _sstyle #:at? '(5 . 5))
  (svg-show-default))
}|
@image{showcase/shapes/line/line.svg}

