(define-module (bytestructures guile vector))
(import
 (srfi :9)
 (bytestructures r6 bytevectors)
 (bytestructures guile utils)
 (bytestructures guile base))
(include-from-path "bytestructures/body/vector.scm")
(include-from-path "bytestructures/r7/vector.exports.sld")
