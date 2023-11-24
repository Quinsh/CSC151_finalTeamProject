#lang racket
(require 2htdp/image)
(require csc151)

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

(define stick
  (lambda (length thickness)
    (rectangle length thickness "solid" "black")))

(define axis
  (lambda (number unit-length thickness)
    (axis/helper! 1 (* (- number 1) 2) unit-length thickness)))

(define axis/helper!
  (lambda (pos len unit-length thickness)
    (if (equal? pos len)
        (get-stick pos unit-length thickness)
        (beside (get-stick pos unit-length thickness)
                (axis/helper! (+ pos 1) len unit-length thickness)))))

(define get-stick
  (lambda (number unit-length thickness)
    (if (zero? (remainder number 2))
        (stick unit-length thickness)
        (stick thickness (* 10 thickness)))))

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

(cartesian-axis-maker 800 1000)
;(cartesian-axis-maker 800 800)
;(cartesian-axis-maker 800 50)
(cartesian-axis-maker 25 800)
(cartesian-axis-maker 800 25)
       
