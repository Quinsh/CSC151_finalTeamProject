#lang racket
(require csc151)
(require 2htdp/image)

;;; (cos-func height) -> image?
;;;   height : real?
;;; Creates part of a function similar to f(x) = cos(x).
;;; For this image, pi was rounded to 3.14
(define cos-func
  (lambda (height)
    (let ([half-func (add-curve (rectangle 314 200 "solid" "transparent")
                                0 200 0 0.3333
                                314 0 0 0.3333
                                "red")])
      (scale (/ height 200)
             (beside
              half-func
              (flip-horizontal half-func)
              half-func
              (flip-horizontal half-func))))))