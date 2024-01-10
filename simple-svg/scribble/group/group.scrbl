#lang scribble/manual

@title{Group}

@section{Combine shapes to group}

@codeblock{
(svg-out
 220 280
 (lambda ()
   (let (
         [line1 (svg-def-line '(0 . 0) '(30 . 30))]
         [line2 (svg-def-line '(0 . 15) '(30 . 15))]
         [line3 (svg-def-line '(15 . 0) '(15 . 30))]
         [line4 (svg-def-line '(30 . 0) '(0 . 30))]
         [_sstyle (sstyle-new)]
         [group_sstyle (sstyle-new)])
     (sstyle-set! _sstyle 'stroke-width 5)
     (sstyle-set! _sstyle 'stroke "#765373")
     (svg-def-group
      "pattern"
      (lambda ()
        (svg-use-shape line1 _sstyle #:at? '(5 . 5))
        (svg-use-shape line2 _sstyle #:at? '(5 . 5))
        (svg-use-shape line3 _sstyle #:at? '(5 . 5))
        (svg-use-shape line4 _sstyle #:at? '(5 . 5))))
     (svg-show-group "pattern" #:at? '(50 . 50))
     (svg-show-group "pattern" #:at? '(100 . 100))
     (svg-show-group "pattern" #:at? '(80 . 200))
     (svg-show-group "pattern" #:at? '(150 . 100))
     )))
}
@image{showcase/group/group1.svg}

@section{Combine groups to group}

@codeblock{
(svg-out
 100 100
 (lambda ()
   (let (
         [rect (svg-def-rect 50 50)]
         [line1 (svg-def-line '(10 . 0) '(0 . 50))]
         [line2 (svg-def-line '(0 . 0) '(10 . 50))]
         [rect_sstyle (sstyle-new)]
         [group_sstyle (sstyle-new)]
         )

     (sstyle-set! group_sstyle 'stroke-width 1)
     (sstyle-set! group_sstyle 'stroke "black")
     (svg-def-group
      "cross_line"
      (lambda ()
        (svg-use-shape line1 group_sstyle #:at? '(0 . 0))
        (svg-use-shape line2 group_sstyle #:at? '(0 . 0))
        ))

     (sstyle-set! rect_sstyle 'stroke-width 2)
     (sstyle-set! rect_sstyle 'stroke "red")
     (sstyle-set! rect_sstyle 'fill "orange")
     (svg-def-group
      "pattern"
      (lambda ()
        (svg-use-shape rect rect_sstyle #:at? '(0 . 0))
        (svg-use-group "cross_line" #:at? '(0 . 0))
        (svg-use-group "cross_line" #:at? '(10 . 0))
        (svg-use-group "cross_line" #:at? '(20 . 0))
        (svg-use-group "cross_line" #:at? '(30 . 0))
        (svg-use-group "cross_line" #:at? '(40 . 0))
        ))

     (svg-show-group "pattern" #:at? '(0 . 0))
     (svg-show-group "pattern" #:at? '(50 . 0))
     (svg-show-group "pattern" #:at? '(0 . 50))
     (svg-show-group "pattern" #:at? '(50 . 50))
     )))
}
@image{showcase/group/group2.svg}
