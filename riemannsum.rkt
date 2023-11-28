#lang racket
(require 2htdp/image)
(require csc151)
(require racket/math)

(provide make-riemannsum)

;;; Acknowledgements
;;; https://docs.racket-lang.org/reference/generic-numbers.html#%28def._%28%28quote._~23~25kernel%29._cos%29%29
;;; https://colorhunt.co/palette/ec8f5ef3b664f1eb909fbb73

;;; made by Gunwoo / Slok

;;; (fxn x) -> number?
;;;   x -> number?
;;; given x, should return cos(x) + 1
(define fxn
  (lambda (x)
    (+ 1 (cos x))))
  
;;; (make-riemannsum width height n) -> image?
;;;   width  : non-negative-integer?
;;;   height : non-negative-integer?
;;;   n      : non-negative-integer?
;;; returns the image of riemann sum based on the parameters above. n means the number of square, which can be from 1 to 999.
(define make-riemannsum
  (lambda (width height n)
    (overlay/align "middle" "bottom"
                   (reduce besidebottom (create-rectangle-list width height n))
                   (empty-scene width height (make-color 0 0 0 0)))))

(define besidebottom
  (lambda (a b)
    (beside/align "bottom" a b)))

;;; (create-rectangle-list) -> listof rectangles.
;;;   width  : non-negative-integer?
;;;   height : non-negative-integer?
;;;   n      : non-negative-integer?
;;; returns the list of rectangles with the parameters provided above. n means the number of rectangles, which can be. from 1
;;; to 999. Thw width and the height of the rectangle are manipulated according to the width and the height provided by the user
;;; creating the reimann sum diagram.
(define create-rectangle-list
  (lambda (width height n)
    (create-rectangle-list-helper n (- 0 pi) (/ width n) height 0 n)))

;;; (create-rectangle-list-helper) -> listof rectangles.
;;;   width  : non-negative-integer?
;;;   height : non-negative-integer?
;;;   n      : non-negative-integer?
;;; This procedure appends the rectangles with the different width and height according to the parameters provided by the user.
(define create-rectangle-list-helper
  (lambda (n x dx max-y pos end)
    (if (= pos end)
        '()
        (cons ; make rectangle
         (make-colored-rectangle dx x pos n max-y)     
         
         ; next recursive call
         (create-rectangle-list-helper n
                                       (+ x (/ (* 2 pi) n)) 
                                       dx 
                                       max-y 
                                       (+ pos 1) 
                                       end)))))

;;;(make-colored-rectangle dx x max-y) -> image?
;;;   dx -> non-negative-integer?
;;;   x -> non-negative-integer?
;;;   max-y -> non-negative-integer?
(define make-colored-rectangle
  (lambda (dx x pos n max-y)
    (let ([color (color-pos pos n)])
      (let ([height (/ (fxn x) 2)])
        (rectangle dx (* height max-y) 'solid color)))))

  
;;; (color-pos pos maxpos) -> color?
;;;   pos    : non-negative-integer?
;;;   maxpos : non-negative-integer?
;;; returns a color between two colors based on the position.
(define color-pos
  (lambda (pos maxpos)
    (let* ([col1 (rgb 230 57 70)] ; or 252 246 189
           [col2 (rgb 29 53 87)]
           [middlecomp (lambda (comp1 comp2)
                         (round
                          (+ comp1 
                            (* (- comp2 comp1)
                               (/ pos maxpos)))))])
      (rgb (middlecomp (color-red col1) (color-red col2))
           (middlecomp (color-green col1) (color-green col2))
           (middlecomp (color-blue col1) (color-blue col2))))))
  