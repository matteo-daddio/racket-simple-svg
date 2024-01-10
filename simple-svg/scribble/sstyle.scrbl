#lang scribble/manual

@title{Svg Style}

each shape and group can have multiple styles: stroke, fill etc.

sstyle is a struct, use sstyle-new, sstyle-clone, sstyle-get and sstyle-set! to manage it.

sstyle used in svg-use-shape and svg-show-group.

@codeblock{
(define sstyle/c
  (struct/dc
   sstyle
     [fill (or/c #f string?)]
     [fill-rule (or/c #f 'nonzero 'evenodd 'inerit)]
     [fill-opacity (or/c #f (between/c 0 1))]
     [stroke (or/c #f string?)]
     [stroke-width (or/c #f natural?)]
     [stroke-linecap (or/c #f 'butt 'round 'square 'inherit)]
     [stroke-linejoin (or/c #f 'miter 'round 'bevel)]
     [stroke-miterlimit (or/c #f (>=/c 1))]
     [stroke-dasharray (or/c #f string?)]
     [stroke-dashoffset (or/c #f natural?)]
     [translate (or/c #f (cons/c natural? natural?))]
     [rotate (or/c #f integer?)]
     [scale (or/c #f natural? (cons/c natural? natural?))]
     [skewX (or/c #f natural?)]
     [skewY (or/c #f natural?)]
     [fill-gradient (or/c #f string?)]
    ))
}

@codeblock{
  (sstyle-new (-> sstyle/c))
  (sstyle-format (-> sstyle/c string?))
  (sstyle-clone (-> sstyle/c sstyle/c))
  (sstyle-set! (-> sstyle/c symbol? any/c void?))
  (sstyle-get (-> sstyle/c symbol? any/c))
}
