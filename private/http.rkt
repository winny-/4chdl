#lang racket/base

(require (rename-in net/http-easy [get easy-get])
         racket/string
         "logger.rkt")

(provide get
         (except-out (all-from-out net/http-easy) easy-get))

(define get
  (make-keyword-procedure
   (λ (kws kw-args . args)
     (define res (keyword-apply easy-get kws kw-args args))
     (log-4ch-debug "GET ~a (~a) (~a)" (car args) (response-status-line res) (string-join (map bytes->string/utf-8 (response-headers res)) " // "))
     res)))
