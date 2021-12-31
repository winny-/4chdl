#lang racket

(provide (prefix-out 4ch- (combine-out boards
                                       threads
                                       catalog
                                       archive
                                       page
                                       thread)))

(require "http.rkt"
         "logger.rkt")

(define BASE-URL "https://a.4cdn.org/")

(define-syntax-rule (define-endpoint id uri args ... transform)
  (define (id args ...)
    (define url (string-append BASE-URL (format uri args ...) ".json"))
    (transform
     (response-json
      (get url)))))

(define ((flatten-pages key) pages)
  (for/fold ([acc empty])
            ([page pages])
    (append acc (hash-ref page key))))

(define-endpoint boards "boards"
  (curryr hash-ref 'boards))
(define-endpoint threads "~a/threads" board
  (flatten-pages 'threads))
(define-endpoint catalog "~a/catalog" board
  (flatten-pages 'threads))
(define-endpoint archive "~a/archive" board
  identity)
(define-endpoint page "~a/~a" board page-no
  (curryr hash-ref 'threads))
(define-endpoint thread "~a/thread/~a" board thread-no
  (curryr hash-ref 'posts))

