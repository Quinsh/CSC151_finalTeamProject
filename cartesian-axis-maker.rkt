#lang racket
(require 2htdp/image)
(require csc151)

;;; (cartesian-axis-maker width height) -> image?
;;;   width: positive-integer? (equal or greater than 10)
;;;   height: positive-integer? (equal or greater than 10)
;;; Generates a width-height image containing the upper part of a
;;; Cartesian Plane.

(define cartesian-axis-maker
  (lambda (width height)
    (let* ([thickness (get-thickness width height)]
           [x-unit (/ (- width (* 11 thickness)) 9)]
           [y-unit (/ (- height (* 7 thickness)) 5)])
      (overlay (overlay/offset (rotate -90 (axis 5 y-unit thickness))
                                0 (* 2 y-unit)
                               (beside (axis 5 x-unit thickness)
                                       (rotate 180 (axis 5 x-unit thickness))))
               (rectangle width height "outline" "black")))))

;;; (get-thickness width height) -> positive-real?
;;;   width: positive-integer? (equal or greater than 10)
;;;   height: positive-integer? (equal or greater than 10)
;;; Sets the thickness of the axis depending on the width and height.

(define get-thickness
  (lambda (width height)
    (let ([side (min width height)])
      (cond
        [(and (<= 800 side) (< side 1200))
         2]
        [(and (<= 300 side) (< side 800))
         1]
        [(and (<= 10 side) (< side 300))
         0.5]))))

;;; (axis number unit-length thickness) -> image?
;;;   number: positive-integer? (numbers in the axis)
;;;   unit-length: positive-real? (distance between two vertical little sticks)
;;;   thickness: positive-real?
;;; Creates axis with "number" number of points.

(define axis
  (lambda (number unit-length thickness)
    (axis/helper 1 (* (- number 1) 2) unit-length thickness)))

;;; (axis/helper pos len unit-length thickness) -> image?
;;;   pos: positive-integer?
;;;   len: positive-integer?
;;;   unit-length: positive-real? (distance between two vertical little sticks)
;;;   thickness: positive-real?
;;; Creates axis with little sticks representing the units.

(define axis/helper
  (lambda (pos len unit-length thickness)
    (if (equal? pos len)
        (get-stick pos unit-length thickness)
        (beside (get-stick pos unit-length thickness)
                (axis/helper (+ pos 1) len unit-length thickness)))))

;;; (get-stick number unit-length thickness) -> image?
;;;   number: positive-integer? (numbers in the axis)
;;;   unit-length: positive-real? (distance between two vertical little sticks)
;;;   thickness: positive-real?
;;; Returns the type of stick, if the number is even it gives
;;; a horizontal stick, when it is odd it gives a vertical stick.

(define get-stick
  (lambda (number unit-length thickness)
    (if (zero? (remainder number 2))
        (stick unit-length thickness)
        (stick thickness (* 10 thickness)))))

;;; (stick length thickness) -> image?
;;;   length: positive-real?
;;;   thickness: positive-real?
;;; Generates a stick with the given length and thickness.

(define stick
  (lambda (length thickness)
    (rectangle length thickness "solid" "black")))


(cartesian-axis-maker 800 1000)
;(cartesian-axis-maker 800 800)
;(cartesian-axis-maker 800 50)
(cartesian-axis-maker 25 800)
(cartesian-axis-maker 800 25)
