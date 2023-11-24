#lang racket

(require csc151)
(require 2htdp/image)
(require rackunit)
(require "cos-function.rkt")
(require "cartesian-axis-maker.rkt")

#| 𝐇 𝐄 𝐀 𝐃 𝐄 𝐑 _____________________________

| CSC-151 Fall 2023
| Mini Project 8
| Authors: GunWoo Kim, Leonardo Nunes, Nicole Gonzalvez, Slok Rajbhandari
| Date: 2023-11-22
| Acknowledgements:
|   - https://docs.racket-lang.org/guide/modules.html (to learn about modules)
|   -
|   - 
|
|#

(define background
  (lambda (width height)
    (overlay/xy (cartesian-axis-maker width height)
                (/ width 6) (/ height 2) 
                (cos-func (/ width 2) height))))
  




