;;; string.scm --- Strings in encodings supported by (rnrs bytevectors).

;; Copyright © 2017 Taylan Ulrich Bayırlı/Kammer <taylanbayirli@gmail.com>

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This module defines descriptors for strings encoded in various encodings, as
;; supported by (rnrs bytevectors).


;;; Code:

(define (bytevector->string bytevector offset size encoding)
  (if (eq? encoding 'utf8)
      (utf8->string bytevector offset (+ offset size))
      (let ((bytevector (bytevector-copy bytevector offset (+ offset size))))
        (case encoding
          ((utf16le) (utf16->string bytevector 'little #t))
          ((utf16be) (utf16->string bytevector 'big #t))
          ((utf32le) (utf32->string bytevector 'little #t))
          ((utf32be) (utf32->string bytevector 'big #t))
          (else (error "Unknown string encoding." encoding))))))

(define (string->bytevector string encoding)
  (case encoding
    ((utf8) (string->utf8 string))
    ((utf16le) (string->utf16 string 'little))
    ((utf16be) (string->utf16 string 'big))
    ((utf32le) (string->utf32 string 'little))
    ((utf32be) (string->utf32 string 'big))))

;;; Note: because macro output may not contain raw symbols, we cannot output
;;; (quote foo) for raw symbol foo either, so there's no way to inject symbol
;;; literals into macro output.  Hence we inject references to the following
;;; variables instead.

(define utf8 'utf8)
(define utf16le 'utf16le)
(define utf16be 'utf16be)
(define utf32le 'utf32le)
(define utf32be 'utf32be)

(define (bs:string size encoding)
  (define alignment 1)
  (define (getter syntax? bytevector offset)
    (if syntax?
        (quasisyntax
         (bytevector->string (unsyntax bytevector)
                             (unsyntax offset)
                             (unsyntax size)
                             (unsyntax
                              (datum->syntax (syntax utf8) encoding))))
        (bytevector->string bytevector offset size encoding)))
  (define (setter syntax? bytevector offset string)
    (if syntax?
        (quasisyntax
         (bytevector-copy! (unsyntax bytevector)
                           (unsyntax offset)                 
                           (string->bytevector
                            (unsyntax string)
                            (unsyntax
                             (datum->syntax (syntax utf8) encoding)))))
        (bytevector-copy!
         bytevector offset (string->bytevector string encoding))))
  (make-bytestructure-descriptor size alignment #f getter setter))

;;; string.scm ends here
