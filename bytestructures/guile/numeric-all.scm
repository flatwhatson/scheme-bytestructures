(define-module (bytestructures guile numeric-all))
(import
 (scheme eval)
 (bytestructures guile bytevectors)
 (bytestructures guile utils)
 (bytestructures guile base)
 (bytestructures guile explicit-endianness)
 (bytestructures guile numeric-data-model))
(include-from-path "bytestructures/body/numeric.scm")
(include-from-path "bytestructures/r7/numeric.exports.sld")
(include-from-path "bytestructures/r7/numeric-metadata.exports.sld")
