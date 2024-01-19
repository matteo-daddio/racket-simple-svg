#lang racket

(require "defines/view-box.rkt")
(require "defines/rect.rkt")
(require "defines/pos.rkt")
(require "defines/svg.rkt")
(require "defines/sstyle.rkt")
(require "defines/group.rkt")

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
                          (#:radius_x? (or/c #f natural?))
                          (#:radius_y? (or/c #f natural?))
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
          [sstyle-new (-> SSTYLE?)]
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
  (let* ([new_widget_index (add1 (SVG-widget_index_count (*SVG*)))]
         [shape_id (format "s~a" new_widget_index)])

    (set-SVG-widget_index_count! (*SVG*) new_widget_index)

    (hash-set! (SVG-shape_define_map (*SVG*)) shape_id shape)

    shape_id))

(define (svg-def-group user_proc)
  (let* ([new_widget_index (add1 (SVG-widget_index_count (*SVG*)))]
         [group_id (format "g~a" new_widget_index)])

    (set-SVG-widget_index_count! (*SVG*) new_widget_index)
    
    (parameterize
        ([*GROUP* (new-group)])
      (user_proc)
      
      (hash-set! (SVG-group_define_map (*SVG*)) group_id (*GROUP*))
      
      group_id)))

(define (svg-place-widget widget_id
                          #:sstyle? [sstyle? #f]
                          #:at? [at? #f])
  (set-GROUP-widget_list! (*GROUP*) `(,@(GROUP-widget_list (*GROUP*)) ,widget_id))
  (when sstyle?
    (hash-set! (GROUP-widget_locate_map (*GROUP*)) widget_id sstyle?))
  (when at?
    (hash-set! (GROUP-widget_style_map (*GROUP*)) widget_id at?)))

(define (svg-show-group group_index #:at? [at? '(0 .0)])
  (set-SVG-group_show_list! (*SVG*) `(,@(SVG-group_show_list (*SVG*)) (cons group_index at?))))
      
(define (flush-data)
  (printf "    width=\"~a\" height=\"~a\"\n" (SVG-width (*SVG*)) (SVG-height (*SVG*)))

  (when (SVG-view_box (*SVG*))
    (let ([view_box (SVG-view_box (*SVG*))])
      (printf "    viewBox=\"~a ~a ~a ~a\"\n"
              (VIEW-BOX-min_x view_box)
              (VIEW-BOX-min_y view_box)
              (VIEW-BOX-width view_box)
              (VIEW-BOX-height view_box))))
      
  (printf "    >\n")

  (when (not (= (hash-count (SVG-shape_define_map (*SVG*))) 0))
    (printf "  <defs>\n")
    (let loop-def ([defs (sort (hash-keys (SVG-shape_define_map (*SVG*))) string<?)])
      (when (not (null? defs))
        (let ([shape (hash-ref (SVG-shape_define_map (*SVG*)) (car defs))])
          (printf "~a" ((hash-ref shape 'format-def) (car defs) shape)))
        (loop-def (cdr defs))))
    (printf "  </defs>\n\n"))

  (let loop-group ([group_ids (sort (hash-keys (SVG-group_define_map (*SVG*))) string<?)])
    (when (not (null? group_ids))
      (let* ([group_id (car group_ids)]
             [group (hash-ref (SVG-group_define_map (*SVG*)) group_id)])
          (printf "  <symbol id=\"~a\">\n" group_id)
          (let loop-widget ([widget_id_list (GROUP-widget_list group)]
                            [widget_locate_map (GROUP-widget_locate_map group)]
                            [widget_style_map (GROUP-widget_style_map group)])
            (when (not (null? widget_id_list))
              (let* ([widget_id (car widget_id_list)]
                     [widget_pos (hash-ref widget_locate_map widget_id #f)]
                     [widget_style (hash-ref widget_style_map widget_id #f)])
                    (printf "    <use xlink:href=\"#~a\" " widget_id)
              
                    (when widget_pos
                          (printf "x=\"~a\" y=\"~a\" " (POS-x widget_pos) (POS-y widget_pos)))
                    
                    (when widget_style
                      (printf "~a/>\n" (sstyle-format widget_style)))
                    )
              (loop-widget (cdr widget_id_list))))
          (printf "  </symbol>\n\n")
          (loop-group (cdr group_ids)))))
    
  (let loop-show ([group_shows (SVG-group_show_list (*SVG*))])
    (when (not (null? group_shows))
      (let* ([group_show (car group_shows)]
             [group_index (car group_show)]
             [group_pos (cdr group_show)])
        (printf "  <use xlink:href=\"#~a\" " group_index)
        
        (when group_at?
              (printf "x=\"~a\" y=\"~a\" " (car group_pos) (cdr group_pos)))
        
        (printf "/>\n"))
      (loop-show (cdr group_shows)))))
