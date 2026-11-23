;;; 4x4 matrices for the examples: column-major flvectors (the layout GLSL
;;; expects), element (row r, column c) at index 4c+r.  Projections use
;;; Vulkan's 0..1 depth range; the examples flip the viewport (negative
;;; height) so Y points up as in OpenGL.

(library (examples math)
  (export pi radians mat mat* translate rotate-x rotate-y rotate-z
          frustum perspective write-matrix! write-normal-matrix!)
  (import (chezscheme))

  (define pi (* 4 (atan 1)))
  (define (radians deg) (/ (* deg pi) 180.0))

  ;; Written row by row for readability.
  (define (mat . rows)
    (let ((m (make-flvector 16 0.0)))
      (do ((r 0 (+ r 1))) ((= r 4) m)
        (do ((c 0 (+ c 1))) ((= c 4))
          (flvector-set! m (+ (* 4 c) r) (inexact (list-ref rows (+ (* 4 r) c))))))))

  (define (mat* a b)
    (let ((m (make-flvector 16 0.0)))
      (do ((c 0 (+ c 1))) ((= c 4) m)
        (do ((r 0 (+ r 1))) ((= r 4))
          (let loop ((k 0) (sum 0.0))
            (if (= k 4)
                (flvector-set! m (+ (* 4 c) r) sum)
                (loop (+ k 1) (fl+ sum (fl* (flvector-ref a (+ (* 4 k) r))
                                            (flvector-ref b (+ (* 4 c) k)))))))))))

  (define (translate x y z) (mat 1 0 0 x  0 1 0 y  0 0 1 z  0 0 0 1))

  (define (rotate-x deg)
    (let ((c (cos (radians deg))) (s (sin (radians deg))))
      (mat 1 0 0 0  0 c (- s) 0  0 s c 0  0 0 0 1)))
  (define (rotate-y deg)
    (let ((c (cos (radians deg))) (s (sin (radians deg))))
      (mat c 0 s 0  0 1 0 0  (- s) 0 c 0  0 0 0 1)))
  (define (rotate-z deg)
    (let ((c (cos (radians deg))) (s (sin (radians deg))))
      (mat c (- s) 0 0  s c 0 0  0 0 1 0  0 0 0 1)))

  ;; glFrustum with a 0..1 depth range.
  (define (frustum l r b t n f)
    (mat (/ (* 2 n) (- r l)) 0 (/ (+ r l) (- r l)) 0
         0 (/ (* 2 n) (- t b)) (/ (+ t b) (- t b)) 0
         0 0 (/ f (- n f)) (/ (* n f) (- n f))
         0 0 -1 0))

  ;; gluPerspective (vertical field of view in degrees) with a 0..1 depth range.
  (define (perspective fov-y aspect n f)
    (let ((t (* n (tan (/ (radians fov-y) 2)))))
      (frustum (- (* t aspect)) (* t aspect) (- t) t n f)))

  ;; Store m as 16 floats at address+offset.
  (define (write-matrix! address offset m)
    (do ((i 0 (+ i 1))) ((= i 16))
      (foreign-set! 'float address (+ offset (* 4 i)) (flvector-ref m i))))

  ;; Store the upper-left 3x3 of m as a GLSL mat3 (three columns, each padded
  ;; to a vec4: 48 bytes).  For rotations and translations this is the normal
  ;; matrix.
  (define (write-normal-matrix! address offset m)
    (do ((c 0 (+ c 1))) ((= c 3))
      (do ((r 0 (+ r 1))) ((= r 3))
        (foreign-set! 'float address (+ offset (* 16 c) (* 4 r)) (flvector-ref m (+ (* 4 c) r))))))
  )
