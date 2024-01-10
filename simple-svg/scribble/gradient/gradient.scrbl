#lang scribble/manual

@title{Gradient}

@codeblock{
(svg-def-gradient-stop (->* 
   (
   #:offset (integer-in 0 100)
   #:color string?
   )
   (
   #:opacity? (between/c 0 1)
   )
   (list/c (integer-in 0 100) string? (between/c 0 1))))
}
  offset from 0 to 100, means the distance of the color gradient.
 
  lineargradient and radialgradient both have a stop list.

@codeblock{
(svg-def-linear-gradient (->*
  ((listof (list/c (integer-in 0 100) string? (between/c 0 1))))
  (
    #:x1? (or/c #f natural?)
    #:y1? (or/c #f natural?)
    #:x2? (or/c #f natural?)
    #:y2? (or/c #f natural?)
    #:gradientUnits? (or/c #f 'userSpaceOnUse 'objectBoundingBox)
    #:spreadMethod? (or/c #f 'pad 'repeat 'reflect)
  )
  string?))
}

  use x1, y1, x2, y2 justify gradient's direction and position.

  default is from left to right, x1=0, y1=0, x2=100, y2=0.

@codeblock{
(let ([rec (svg-def-rect 100 100)]
      [gradient
        (svg-def-linear-gradient
          (list
            (svg-def-gradient-stop #:offset 0 #:color "#BBC42A")
            (svg-def-gradient-stop #:offset 100 #:color "#ED6E46")
           ))]
     [_sstyle (sstyle-new)])

   (sstyle-set! _sstyle 'fill-gradient gradient)
   (svg-use-shape rec _sstyle)
   (svg-show-default))
}
@image{showcase/gradient/gradient1.svg}

@codeblock{
(svg-def-radial-gradient (->*
       ((listof (list/c (integer-in 0 100) string? (between/c 0 1))))
       (
        #:cx? (or/c #f (integer-in 0 100))
        #:cy? (or/c #f (integer-in 0 100))
        #:fx? (or/c #f (integer-in 0 100))
        #:fy? (or/c #f (integer-in 0 100))
        #:r? (or/c #f natural?)
        #:gradientUnits? (or/c #f 'userSpaceOnUse 'objectBoundingBox)
        #:spreadMethod? (or/c #f 'pad 'repeat 'reflect)
       )
       string?))
}
  cx, cy, fx, fy has value 0 - 100, means 0% - 100%, use them to justify gradient's position and direction.


@codeblock{
(let ([rec (svg-def-rect 100 100)]
      [gradient
       (svg-def-radial-gradient
        (list
         (svg-def-gradient-stop #:offset 0 #:color "#BBC42A")
         (svg-def-gradient-stop #:offset 100 #:color "#ED6E46")
         ))]
      [_sstyle (sstyle-new)])

  (sstyle-set! _sstyle 'fill-gradient gradient)
  (svg-use-shape rec _sstyle)
  (svg-show-default))
}
@image{showcase/gradient/gradient2.svg}
