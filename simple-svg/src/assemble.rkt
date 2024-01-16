v#lang racket

(require "lib/sstyle.rkt")

(provide (contract-out
          [svg-out (->* (natural? natural? procedure?)
                        (
                         #:viewBox? (or/c #f (list/c natural? natural? natural? natural?))
                        )
                        string?)]
          [svg-use-shape (->* (string? sstyle/c) 
                              (
                               #:at? (cons/c natural? natural?)
                               #:hidden? boolean?
                              )
                              void?)]
          [svg-def-group (-> string? procedure? void?)]
          [svg-use-group (->* (string?)
                              (
                               #:at? (cons/c natural? natural?)
                                     )
                              void?)]
          [svg-show-group (->* (string?)
                              (
                               #:at? (cons/c natural? natural?)
                              )
                              void?)]
          ))

(define (svg-out width height write_proc
                 #:viewBox? [viewBox? #f]
                 )

  (let ([widget_index 0]
        [svg (new-svg)])
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
               (write_proc svg))
             (lambda ()
               (flush-data)
               (printf "</svg>\n")))))))

(define (svg-def-group group_name shapes-proc)
  (parameterize ([*current_group* group_name])
                (shapes-proc)))

(define (svg-use-group group_name #:at? [at? #f])
  ((*add-group*) group_name at?))
      
(define (svg-use-shape shape_index _sstyle
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

(define (svg-show-group group_index #:at? [at? #f])
  (set! (*show-list*) `(,@(*show-list*) ,(cons group_index at?))))

(define (flush-data)
  (printf "    width=\"~a\" height=\"~a\"\n" (*width*) (*height*))

  (when (*viewBox*)
    (printf "    viewBox=\"~a ~a ~a ~a\"\n"
            (first (*viewBox*)) (second (*viewBox*)) (third (*viewBox*)) (fourth (*viewBox*))))
      
  (printf "    >\n")

  (when (not (= (hash-count (*shapes_map*)) 0))
    (printf "  <defs>\n")
    (let loop-def ([defs (sort (hash-keys (*shapes_map*)) string<?)])
      (when (not (null? defs))
        (let ([shape (hash-ref (*shapes_map*) (car defs))])
          (printf "~a" ((hash-ref shape 'format-def) (car defs) shape)))
        (loop-def (cdr defs))))
    (printf "  </defs>\n\n"))

  (let loop-group ([groups (sort (hash-keys (*groups_map*)) string<?)])
    (when (not (null? groups))
          (printf "  <symbol id=\"~a\">\n" (car groups))
          (let loop-shape ([shapes (hash-ref (*groups_map*) (car groups))])
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
    
  (let loop-group ([groups ((*show-list*))])
    (when (not (null? groups))
      (let* ([group_index (caar groups)]
             [group_at? (cdar groups)])
        (printf "  <use xlink:href=\"#~a\" " group_index)
        
        (when group_at?
              (printf "x=\"~a\" y=\"~a\" " (car group_at?) (cdr group_at?)))
        
        (printf "/>\n"))
      (loop-group (cdr groups)))))
        [groups_list '()]
