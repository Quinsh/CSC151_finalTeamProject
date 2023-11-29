#lang racket

(require csc151)
(require 2htdp/image)
(require rackunit)
(require "cos-function.rkt")
(require "cartesian-axis-maker.rkt")
(require "riemannsum.rkt")


;;; image-series.rkt
;;;   The final project for CSC-151-01 2023Fa
;;;
;;; Authors: GunWoo Kim, Leonardo Nunes, Nicole Gonzalez, Slok Rajbhandari
;;;
;;; Date: YYYY-MM-DD
;;;
;;; Acknowledgements
;;; - https://docs.racket-lang.org/guide/modules.html (to learn about modules)
;;; - https://docs.racket-lang.org/teachpack/2htdpimage.html#%28def._%28%28lib._2htdp%2Fimage..rkt%29._text%29%29 (to learn about text)
;;; - https://docs.racket-lang.org/reference/generic-numbers.html#%28def._%28%28quote._~23~25kernel%29._cos%29%29
;;; - https://colorhunt.co/palette/ec8f5ef3b664f1eb909fbb73 
;;; * The project template comes from SamR.

; +----------+-------------------------------------------------------
; | Time log |
; +----------+

#|
NAME    YYYY-MM-DD HH:MM-HH:MM  NN min  ACTIVITY
NAME    YYYY-MM-DD HH:MM-HH:MM  NN min  ACTIVITY
|#

; +--------------+---------------------------------------------------
; | Design goals |
; +--------------+

#|


|#

; +------------------------+-----------------------------------------
; | Requirements checklist |
; +------------------------+

#|

What are two image-making techniques you've used?  Where do you
use them?

???

What are two instances of recursion in your program? 

???

Describe a piece of code that you are particularly of.

???

|#

; +-------------------+----------------------------------------------
; | Primary procedure |
; +-------------------+

;;; (image-series width height n) -> image?
;;;   width  : non-negative-integer?
;;;   height : non-negative-integer?
;;;   n      : non-negative-integer?
;;; returns the final image with axis, curve and riemann sum.
;;; n increases the number of squares.
(define image-series
  (lambda (width height n)
    (overlay/align "center" "bottom"
                   (area-txt (round (/ height 17)) n)
                   (overlay/xy (background width height)
                               (/ width 6) (/ height 2)
                               (make-riemannsum (/ width 1.5) (/ height 2.55) n))
                   (rectangle width height "solid" "black"))))

; +-------------------+----------------------------------------------
; | Helper procedures |
; +-------------------+


;;; (background width height) -> image?
;;;   width  : non-negative-integer?
;;;   height : non-negative-integer?
;;; return an image of axis and f(x) together.
(define background
  (lambda (width height)
    (overlay/xy (cartesian-axis-maker width height)
                (/ width 6) (/ height 2) 
                (cos-func (/ width 2) height))))


;; _____________________________________________
;; making a text to display the area.

;;; (area-txt height n) -> image?
;;;   height : non-negative-integer?
;;;   n      : non-negative-integer?
;;; returns a text of area approximated with n rectangles in riemann sum.
(define area-txt
  (lambda (height n)
    (text (number->string (calc-area n)) height (col-n n))))

;;; (calc-area n) -> inexact?
;;;   n : non-negative-integer?
;;; approximates cos(x)+1 with left riemann sum of 'n' squares
(define calc-area
  (lambda (n)
    (let (; fxn(x) = cos(x) + 1
          [fxn (lambda (x) (+ (cos x) 1))]
          ; dx = 2pi/n
          [dx (/ (* 2 pi) n)])
      
      (letrec (; helper calculates the sum of heights
               [helper (lambda (x k)
                         (if (zero? k)
                             0
                             (+ (fxn x)
                                (helper (+ x dx) (- k 1)))))])
        ; return dx * sum of heights
        (* dx (helper (- pi) n))))))


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