#lang racket

(require csc151)
(require 2htdp/image)
(require rackunit)
(require "cos-function.rkt")
(require "cartesian-axis-maker.rkt")
(require "riemannsum.rkt")

#| 𝐇 𝐄 𝐀 𝐃 𝐄 𝐑 _____________________________

| CSC-151 Fall 2023
| Mini Project 8
| Authors: GunWoo Kim, Leonardo Nunes, Nicole Gonzalvez, Slok Rajbhandari
| Date: 2023-11-22
|
| ALL Acknowledgements (across every file):
|
|   - https://docs.racket-lang.org/guide/modules.html (to learn about modules)
|   - https://docs.racket-lang.org/teachpack/2htdpimage.html#%28def._%28%28lib._2htdp%2Fimage..rkt%29._text%29%29 (to learn about text)
|   - https://docs.racket-lang.org/reference/generic-numbers.html#%28def._%28%28quote._~23~25kernel%29._cos%29%29
|   - https://colorhunt.co/palette/ec8f5ef3b664f1eb909fbb73
|  
|#; __________________________________________


;;; (background width height) -> image?
;;;   width  : non-negative-integer?
;;;   height : non-negative-integer?
;;; return an image of axis and f(x) together.
(define background
  (lambda (width height)
    (overlay/xy (cartesian-axis-maker width height)
                (/ width 6) (/ height 2) 
                (cos-func (/ width 2) height))))
  

;;; (finalimg width height n) -> image?
;;;   width  : non-negative-integer?
;;;   height : non-negative-integer?
;;;   n      : non-negative-integer?
;;; returns the final image with axis, curve and riemann sum. n increases the number of squares.
(define finalimg
  (lambda (width height n)
    (overlay/align "center" "bottom"
                   (area-txt (round (/ height 17)) n)
                   (overlay/xy (background width height)
                               (/ width 6) (/ height 2)
                               (make-riemannsum (/ width 1.5) (/ height 2.55) n))
                   (rectangle width height "solid" "black"))))


;;; (image-series n width height) -> image?
;;;   n : non-negtive-integer?
;;;   width : non-negtive-integer?
;;;   height : non-negtive-integer?
;;; returns the final image
(define image-series finalimg)


;; _____________________________________________
;; making a text to display the area.

;;; (area-txt height n) -> image?
;;;   height : non-negative-integer?
;;;   n      : non-negative-integer?
;;; returns a text of area approximated with n rectangles in riemann sum.
(define area-txt
  (lambda (height n)
    (text (number->string (calc-area n)) height (col-n n))))


;;; (make-listofYs n) -> listof inexact-number?
;;;   n : non-negative-integer?
;;; return a listof heights of left sides of n rectangles.
(define make-listofYs
  (lambda (n)
    (let* ([fxn (lambda (x) (+ (cos x) 1))]
           ; 'x-adjust' is the function that maps the (range n) to a list of x positions
           [x-adjust (lambda (x) (- (* x (/ (* 2 pi) n)) pi))]
           [listofXs (map x-adjust (range n))]
           ; 'listofYs' are made by mapping Xs with fxn
           [listofYs (map fxn listofXs)])

      ;return listofYs.
      listofYs)))


;;; (calc-area n) -> inexact?
;;;   n : non-negative-integer?
;;; approximates cos(x)+1 with left riemann sum of 'n' squares
;;; USES LIST RECURSION to sum up a list of heights of the left sides of n rectangles.
(define calc-area
  (lambda (n)
    (let ([Ys (make-listofYs n)]
          ; dx = 2pi/n
          [dx (/ (* 2 pi) n)])
      
      (letrec (; helper sums up the heights in 'Ys'
               [helper (lambda (Y-list)
                         (if (null? Y-list)
                             0
                             (+ (car Y-list) (helper (cdr Y-list)))))])
        ; return dx * sum of heights
        (* dx (helper Ys))))))


;;; (col-n n) -> color?
;;;   n    : non-negative-integer?
;;; returns a color between two colors based on n.
(define col-n
  (lambda (n)
    (let* ([col1 (rgb 230 57 70)] ; or 252 246 189
           [col2 (rgb 121 229 105)]
           [middlecomp (lambda (comp1 comp2)
                         (round
                          (+ comp1 
                             (* (- comp2 comp1)
                                (/ n 999)))))])
      (rgb (middlecomp (color-red col1) (color-red col2))
           (middlecomp (color-green col1) (color-green col2))
           (middlecomp (color-blue col1) (color-blue col2))))))