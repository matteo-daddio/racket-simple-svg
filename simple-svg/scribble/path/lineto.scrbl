#lang scribble/manual

@title{svg-path-lineto/lineto*/hlineto/vlineto}

@codeblock{
  (svg-path-lineto (-> (cons/c integer? integer?) void?))
}
  relative position.                        

@codeblock{
  (svg-path-lineto (-> (cons/c integer? integer?) void?))
}
  absolute position.

@codeblock{
  (svg-path-hlineto (-> integer? void?))
}

@codeblock{
  (svg-path-vlineto (-> integer? void?))
}


@codeblock{
(let ([path
  (svg-def-path
    (lambda ()
      (svg-path-moveto* '(5 . 5))
      (svg-path-hlineto 100)
      (svg-path-vlineto 100)
      (svg-path-lineto '(-50 . 50))
      (svg-path-lineto '(-50 . -50))
      (svg-path-close)))]
     [path_sstyle (sstyle-new)])

  (sstyle-set! path_style 'stroke-width 5)
  (sstyle-set! path_style 'stroke "#7AA20D")
  (sstyle-set! path_style 'stroke-linejoin 'round)
  (svg-use-shape path path_sstyle)

  (svg-show-default))
}
@image{showcase/path/lineto.svg}
