#lang scribble/manual

@(require "../../main.rkt")

@(require (for-label racket))
@(require (for-label "../../path/lineto.rkt"))

@title{svg-path-lineto/lineto*/hlineto/vlineto}

define a line path.

@defproc[(svg-path-lineto [point (cons/c integer? integer?)]) void?]{
  svg-path-lineto* is the absolute version.
}

@defproc[(svg-path-hlineto [point integer?]) void?]{
}

@defproc[(svg-path-vlineto [point integer?]) void?]{
}

@codeblock{
(let ([path
  (svg-path-def
    (lambda ()
      (svg-path-moveto* '(5 . 5))
      (svg-path-hlineto 100)
      (svg-path-vlineto 100)
      (svg-path-lineto '(-50 . 50))
      (svg-path-lineto '(-50 . -50))
      (svg-path-close)))]
     [sstyle_path (new-sstyle)])

  (set-sstyle-stroke-width! sstyle_path 5)
  (set-sstyle-stroke! sstyle_path "#7AA20D")
  (set-sstyle-stroke-linejoin! sstyle_path 'round)
  (svg-use-shape path sstyle_path)

  (svg-show-default))
}
@image{showcase/path/lineto.svg}
