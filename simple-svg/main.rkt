#lang racket

(require "src/defines/view-box.rkt")
(require "src/defines/rect.rkt")
(require "src/defines/pos.rkt")
(require "src/defines/svg.rkt")
(require "src/defines/sstyle.rkt")
(require "src/defines/group.rkt")

(provide (contract-out
          [struct VIEW-BOX
                  (
                   (min_x natural?)
                   (min_y natural?)
                   (width natural?)
                   (height natural?)
                   )
                  ]
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
                          #:radius_x (or/c #f natural?)
                          #:radius_y (or/c #f natural?)
                         )
                         RECT?
                         )]
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
                                  #:style SSTYLE?
                                  #:at POS?
                                 )
                                 void?)]
          [svg-show-group (->* (string?)
                               (
                                #:at POS?
                               )
                               void?)]
          ))

(define (svg-out width height write_proc
                 #:viewBox? [viewBox? #f]
                 )

  (parameterize
      ([*SVG* (new-svg width height)])
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
  (let* ([new_widget_index (add1 (SVG-widget_id_count (*SVG*)))]
         [shape_id (format "s~a" new_widget_index)])

    (set-SVG-widget_id_count! (*SVG*) new_widget_index)

    (hash-set! (SVG-shape_define_map (*SVG*)) shape_id shape)

    shape_id))

(define (svg-def-group user_proc)
  (let* ([new_widget_index (add1 (SVG-widget_id_count (*SVG*)))]
         [group_id (format "g~a" new_widget_index)])

    (set-SVG-widget_id_count! (*SVG*) new_widget_index)
    
    (parameterize
        ([*GROUP* (new-group)])
      (user_proc)
      
      (hash-set! (SVG-group_define_map (*SVG*)) group_id (*GROUP*))
      
      group_id)))

(define (svg-place-widget widget_id
                          #:style [style #f]
                          #:at [at #f])
  (set-GROUP-widget_id_list! (*GROUP*) `(,@(GROUP-widget_id_list (*GROUP*)) ,widget_id))
  (when style
    (hash-set! (GROUP-widget_locate_map (*GROUP*)) widget_id style))
  (when at
    (hash-set! (GROUP-widget_style_map (*GROUP*)) widget_id at)))

(define (svg-show-group group_id #:at [at (POS 0 0)])
  (set-SVG-group_show_list! (*SVG*) `(,@(SVG-group_show_list (*SVG*)) (cons group_id at))))
      
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
    (let loop-def ([shape_ids (sort (hash-keys (SVG-shape_define_map (*SVG*))) string<?)])
      (when (not (null? shape_ids))
        (let ([shape (hash-ref (SVG-shape_define_map (*SVG*)) (car shape_ids))])
          (printf "~a"
                  (cond
                   [(RECT? shape)
                    (format-rect (car shape_ids) shape)]
                   )))
        (loop-def (cdr shape_ids))))
    (printf "  </defs>\n\n"))

  (let loop-group ([group_ids (sort (hash-keys (SVG-group_define_map (*SVG*))) string<?)])
    (when (not (null? group_ids))
      (let* ([group_id (car group_ids)]
             [group (hash-ref (SVG-group_define_map (*SVG*)) group_id)])
          (printf "  <symbol id=\"~a\">\n" group_id)
          (let loop-widget ([widget_id_list (GROUP-widget_id_list group)]
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
             [group_id (car group_show)]
             [group_pos (cdr group_show)])
        (printf "  <use xlink:href=\"#~a\" " group_id)
        
        (when group_pos
              (printf "x=\"~a\" y=\"~a\" " (car group_pos) (cdr group_pos)))
        
        (printf "/>\n"))
      (loop-show (cdr group_shows)))))
