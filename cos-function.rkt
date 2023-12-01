#lang racket
(require csc151)
(require 2htdp/image)
(provide cos-func)

;;; (cos-func width height) -> image?
;;;   width : real?
;;;   height : real?
;;; Creates part of a function similar to f(x) = cos(x).
;;; For this image, pi was rounded to 3.14
(define cos-func
  (lambda (width height)
    (let ([half-func (add-curve (rectangle (/ width 1.5) (/ height 2.6) "solid" "transparent")
                                0 (/ height 2.6) 0 0.3333
                                (/ width 1.5) 0 0 0.3333
                                "red")])
      (beside
       half-func
       (flip-horizontal half-func)))))