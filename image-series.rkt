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
;;; Date: 2023-12-3
;;;
;;; Acknowledgements
;;; - https://docs.racket-lang.org/guide/modules.html (to learn about modules)
;;; - https://docs.racket-lang.org/teachpack/2htdpimage.html#%28def._%28%28lib._2htdp%2Fimage..rkt%29._text%29%29 (to learn about text)
;;; - https://docs.racket-lang.org/reference/generic-numbers.html#%28def._%28%28quote._~23~25kernel%29._cos%29%29
;;; - https://colorhunt.co/palette/ec8f5ef3b664f1eb909fbb73
;;; - Image:(https://youtu.be/NgLd16Dksrs?feature=shared)Video: Riemann Integral Visualization Author: Visualization 101
;;; * The project template comes from SamR.

; +----------+-------------------------------------------------------
; | Time log |
; +----------+

#|
GUN WOO  (Total = 8.3h)
GUN WOO 2023-11-20 19:00-19:50  50 min   [introduced and set up github settings for the team]
GUN WOO 2023-11-20 19:50-20:30  40 min   [brainstormed about ideas to implement]
GUN WOO 2023-11-22 09:00-09:50  50 min   [project designing]
GUN WOO 2023-11-24 16:00-16:50  50 min   [implement riemann-sum-image maker]
GUN WOO 2023-11-24 20:00-22:00  120 min  [implement riemann-sum maker and the gradient rectangles]
GUN WOO 2023-11-28 15:00-15:50  50 min   [join all the procedures together to create the final image]
GUN WOO 2023-11-28 16:10-16:50  40 min   [implement image-map to change color from red to green according to n]
GUN WOO 2023-11-28 16:50-18:00  70 min   [implement text showing the area]
GUN WOO 2023-12-03 02:00-02:30  30 mins  [add a different type of recursion (list recursion)]

LEONARDO (Total = 10h)
LEONARDO 2023-11-19 11:30-12:00   30 min  [Created an organization document and wrote a recap of our brainstorming.]
LEONARDO 2023-11-20 19:00-20:30   90 min  [Discussed project ideas and set GitHub environment]
LEONARDO 2023-11-22 09:00-09:50   50 min  [Idea validation, project sketch]
LEONARDO 2023-11-23 19:50-20:50   60 min  [Cosine function]
LEONARDO 2023-11-24 15:30-17:00   90 min  [Cosine function + axis on main file]
LEONARDO 2023-11-27 11:15-12:00   45 min  [Project organization checklist, minor adjustments and script]
LEONARDO 2023-11-27 17:00-17:50   50 min  [Presentation script]
LEONARDO 2023-11-28 20:20-21:00   40 min  [Organization and generate 4 image files]
LEONARDO 2023-11-29 08:30-09:50   80 min  [Code review and add Sam's template]
LEONARDO 2023-11-30 13:00-13:30   30 min  [Code review documentation and checklist]
LEONARDO 2023-11-30 11:00-11:50   40 min  [Code review documentation and checklist]


NICOLE (Total = 8.8h)
NICOLE 2023-11-19 09:00-09:30  30 min  [Setting github]
NICOLE 2023-11-20 19:00-20:30  90 min  [Discussed project ideas and set GitHub environment]
NICOLE 2023-11-20 19:50-20:30  40 min  [Discussed project ideas]
NICOLE 2023-11-22 21:00-21:50  50 min  [Idea validation, project sketch]
NICOLE 2023-11-22 14:00-16:00  120 min [Code the first part of the project.]
NICOLE 2023-11-28 18:00-20:00  120 min [Powerpoint presentation]
NICOLE 2023-11-29 08:30-09:50  80 min  [Code review and Powerpoint presentation]

SLOK  (Total = 7.0h)
SLOK 2023-11-20 19:00-19:50  50 min [introduced and set up github settings for the team]
SLOK 2023-11-20 19:50-20:30  40 min [Discussed project ideas] 
SLOK 2023-11-24 16:00-16:50  70 min [implement riemann-sum-image maker]
SLOK 2023-11-24 20:00-22:00  140 min [implementing the gradient rectangles in the riemann sum diagram]
SLOK 2023-11-28 15:00-15:50  70 min [join all the procedures together to create the final image]
SLOK 2023-11-30 14:00-14:50  50 min [Answering the questions for recursion instances, image making techniques and one code that we are particular about]


|#

; +--------------+---------------------------------------------------
; | Design goals |
; +--------------+

#|
NOTE: There is a sketch.png file that includes our initial sketch of the project

After brainstorming about what image we would choose, we chose Riemann Sum. We thought
that we could code how it is done in DrRacket by using math expressions and we could
also add some interesting features to it.

Our original inspiration was the thumbnail of the video
(https://youtu.be/NgLd16Dksrs?feature=shared) Video: Riemann Integral Visualization
Author: Visualization 101, which included a Riemann Sum representation of a curve.

We then decided the features and limitations of the project, which included:
- N is the number of rectangles using left-endpoints to approximate the area
- There will be an accuracy gradient that tends to a certain color as n increases
- There will be a fixed function similar to f(x) = cos(x) + 1
- There will be a fixed interval -pi to pi
- There will be a dark background


|#

; +------------------------+-----------------------------------------
; | Requirements checklist |
; +------------------------+

#|

What are two image-making techniques you've used?  Where do you
use them?

Shapes: To create the Riemann sum we used rectangles, which is one of the most used
shapes to create images throughout our learning. We especially use them in the procedure
(make-colored-rectangle dx x max-y). We also use other shape techniques to draw the axis
and place shapes in a specific order.

Image-map: We used image-map in the procedure (make-riemannsum width height n), we used
it to apply a color transformation to the figure, making it greener, as explained in the
(colortransform n) documentation.


What are two instances of recursion in your program? 

First instance (numeric recursion): The (axis/helper pos len unit-length thickness) procedure utilizes
recursion to construct a sequence of sticks for the axis lines. The recursion stops when
it reaches the desired number of sticks.

Second instance (list recursion): The (calc-area n) procedure involves recursive calls to construct
a list of the heights of each rectangle for the Riemann sum. Then the width of each rectangle is
considered to calculate the area.


Describe a piece of code that you are particularly of.

We are mostly proud of the riemannsum.rkt file as it represents the most mathematical part
of our work. In order to do the calculation, we had to explore the cos procedure, which is
used in (fxn x). Then we created the rectangles and put them in a list so that we could place
them using beside to build a Riemann sum.

Of course, our project has many other interesting features like the axis, the curve and the
coloring of the image. However, as the Riemann Sum is the core of our project and we spent
some time on it during the initial brainstorming, it is one piece of code we are proud of.


|#

; +-------------------+----------------------------------------------
; | Primary procedure |
; +-------------------+

;;; (image-series n width height) -> image?
;;;   n : non-negative-integer?
;;;   width : non-negative-integer?
;;;   height : non-negative-integer?
;;; returns the final image with axis, curve and riemann sum. n increases the number of squares.
(define image-series
  (lambda (n width height)
    (overlay/align "center" "bottom"
                   (area-txt (round (/ height 17)) (+ n 1))
                   (overlay/xy (background width height)
                               (/ width 6) (/ height 2)
                               (make-riemannsum (/ width 1.5) (/ height 2.55) (+ n 1)))
                   (rectangle width height "solid" "black"))))


; +-------------------+----------------------------------------------
; | Helper procedures |
; +-------------------+

;;; (background width height) -> image?
;;;   width : non-negative-integer?
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
;;;   n : non-negative-integer?
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
;;;   n : non-negative-integer?
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