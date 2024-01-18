#lang racket

(require "defines/view-box.rkt")
(require "defines/rect.rkt")

(require "lib/sstyle.rkt")

(provide (contract-out
          [svg-out (->* (natural? natural? procedure?)
                        (
                         #:viewBox? (or/c #f VIEW-BOX?)
                        )
                        string?)]
          [struct RECT
                  (
                   (width natural?)
                   (height natural?)
                   (radius_x (or/c #f natural?))
                   (radius_y (or/c #f natural?))
                   )
                  ]
          [new-rect (->* (natural? natural?)
                         (
                         #:radius_x? (or/c #f natural?)
                         #:radius_y? (or/c #f natural?)
                         ))]
          [svg-def-shape (-> (or/c RECT?) string?)]
          [svg-def-group (-> procedure? string?)]
          [struct SSTYLE
                  (
                   (fill (or/c #f string?))
                   (fill-rule (or/c #f 'nonzero 'evenodd 'inerit))
                   (fill-opacity (or/c #f (between/c 0 1)))
                   (stroke (or/c #f string?))
                   (stroke-width (or/c #f natural?))
                   (stroke-linecap (or/c #f 'butt 'round 'square 'inherit))
                   (stroke-linejoin (or/c #f 'miter 'round 'bevel))
                   (stroke-miterlimit (or/c #f (>=/c 1)))
                   (stroke-dasharray (or/c #f string?))
                   (stroke-dashoffset (or/c #f natural?))
                   (translate (or/c #f (cons/c natural? natural?)))
                   (rotate (or/c #f integer?))
                   (scale (or/c #f natural? (cons/c natural? natural?)))
                   (skewX (or/c #f natural?))
                   (skewY (or/c #f natural?))
                   (fill-gradient (or/c #f string?))
                   )]
          [sstyle-new (-> sstyle/c)]
          [struct POS
                  (
                   (x natural?)
                   (y natural?)
                   )
                  ]
          [svg-place-widget (->* (string?)
                                 (
                                  #:sstyle? SSTYLE?
                                  #:at? POS?
                                 )
                                 void?)]
          [svg-show-group (->* (string?)
                               (
                                #:at? POS?
                               )
                               void?)]
          ))

(define (svg-out width height write_proc
                 #:viewBox? [viewBox? #f]
                 )

  (parameterize
      ([*SVG* (new-svg)])
    (with-output-to-string
      (lambda ()
        (dynamic-wind
            (lambda () 
              (printf 
               "<svg\n    ~a\n    ~a\n    ~a\n"
               "version=\"1.1\""
               "xmlns=\"http://www.w3.org/2000/svg\""
               "xmlns:xlink=\"http://www.w3.org/1999/xlink\""))
            (lambda ()
              (write_proc))
            (lambda ()
              (flush-data)
              (printf "</svg>\n")))))))

(define (svg-def-shape shape)
  (let* ([new_widget_index (add1 (SVG-widget_index (*SVG*)))]
         [shape_index (format "s~a" new_widget_index)])

    (set-SVG-widget_index! (*SVG*) new_widget_index)

    (hash-set! shape_define_map shape_index shape)

    shape_index))

(define (svg-def-group user_proc)
  (let* ([new_widget_index (add1 (SVG-widget_index (*SVG*)))]
         [shape_index (format "g~a" new_widget_index)])

    (set-SVG-widget_index! (*SVG*) new_widget_index)
    
    (parameterize
        ([*GROUP* (new-group)])
      (user_proc)
      
      (hash-set! group_define_map group_index (*GROUP*))
      
      new_widget_index)))

(define (svg-place-widget widget_index
                          #:sstyle? [sstyle? #f]
                          #:at? [at? #f])
  (set-GROUP-widget_list! (*GROUP*) `(,@(GROUP-widget_list group) ,widget_index))
  (when sstyle?
    (hash-set! (GROUP-widget_locate_map (*GROUP*)) widget_index sstyle?))
  (when at?
    (hash-set! (GROUP-widget_style_map (*GROUP*)) widget_index at?)))

(define (svg-show-group group_index #:at? [at? '(0 .0)])
  (set-SVG-group_show_list (*SVG*) `(,@(SVG-group_show_list (*SVG*)) (cons group_index at?))))
      
(define (svg-use-shape-old shape_index _sstyle
                       #:at? [at? #f]
                       #:hidden? [hidden? #f]
                       )
  (let* ([shape (hash-ref (*shapes_map*) shape_index)]
         [new_shape_index shape_index]
         [new_shape shape]
         [new_at? at?])

    (cond
     [(eq? (hash-ref shape 'type) 'circle)
      (set! new_shape_index ((*shape-index*)))
      (set! new_shape (hash-copy shape))
      (when at?
            (hash-set! new_shape 'cx (car new_at?))
            (hash-set! new_shape 'cy (cdr new_at?)))
      (set! new_at? #f)]
     [(eq? (hash-ref shape 'type) 'ellipse)
      (set! new_shape_index ((*shape-index*)))
      (set! new_shape (hash-copy shape))
      (let ([radius (hash-ref shape 'radius)])
        (when at?
              (hash-set! new_shape 'cx (car new_at?))
              (hash-set! new_shape 'cy (cdr new_at?)))
        (set! new_at? #f)
        (hash-set! new_shape 'rx (car radius))
        (hash-set! new_shape 'ry (cdr radius)))]
     )

    ((*set-shapes-map*) new_shape_index new_shape)
    ((*set-sstyles-map*) new_shape_index _sstyle)
    (when (not hidden?)
      ((*add-group*) new_shape_index new_at?))
    ))

(define (flush-data)
  (printf "    width=\"~a\" height=\"~a\"\n" (*width*) (*height*))

  (when (SVG-view_box (*svg*))
    (let ([view_box (SVG-view_box (*svg*))])
      (printf "    viewBox=\"~a ~a ~a ~a\"\n"
              (first view_box) (second view_box) (third view_box) (fourth view_box))))
      
  (printf "    >\n")

  (when (not (= (hash-count (SVG-shape_define_map (*svg*))) 0))
    (printf "  <defs>\n")
    (let loop-def ([defs (sort (hash-keys (SVG-shape_define_map (*svg*))) string<?)])
      (when (not (null? defs))
        (let ([shape (hash-ref (SVG-shape_define_map (*svg*)) (car defs))])
          (printf "~a" ((hash-ref shape 'format-def) (car defs) shape)))
        (loop-def (cdr defs))))
    (printf "  </defs>\n\n"))

  (let loop-group ([groups (sort (hash-keys (SVG-group_define_map (*svg*))) string<?)])
    (when (not (null? groups))
          (printf "  <symbol id=\"~a\">\n" (car groups))
          (let loop-shape ([shapes (hash-ref (SVG-group_define_map (*svg*)) (car groups))])
            (when (not (null? shapes))
                  (let* ([shape_index (caar shapes)]
                         [shape_at? (cdar shapes)]
                         [_sstyle (hash-ref (*sstyles_map*) shape_index (sstyle-new))])
                    (printf "    <use xlink:href=\"#~a\" " shape_index)
              
                    (when shape_at?
                          (printf "x=\"~a\" y=\"~a\" " (car shape_at?) (cdr shape_at?)))

                    (printf "~a/>\n" (sstyle-format _sstyle))
                    )
                  (loop-shape (cdr shapes))))
          (printf "  </symbol>\n\n")
          (loop-group (cdr groups))))
    
  (let loop-show ([group_shows (SVG-group_show_list (*svg*))])
    (when (not (null? group_shows))
      (let* ([group_show (car group_shows)]
             [group_index (car group_show)]
             [group_pos (cdr group_show)])
        (printf "  <use xlink:href=\"#~a\" " group_index)
        
        (when group_at?
              (printf "x=\"~a\" y=\"~a\" " (car group_pos) (cdr group_pos)))
        
        (printf "/>\n"))
      (loop-show (cdr group_shows)))))
