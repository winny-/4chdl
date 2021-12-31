#lang racket/base

(require net/base64
         openssl/md5
         racket/file
         racket/port
         "api.rkt"
         "http.rkt"
         "logger.rkt")

(provide (prefix-out 4ch- (combine-out download-file download-thread-images)))

(define BASE-URL "https://i.4cdn.org/")

(define (download-file url filename [digest #f])
  (if (and digest (file-exists? filename) (bytes=? digest (call-with-input-file filename md5-bytes)))
      (log-4ch-debug "~a already exists with same MD5.  Skipping." filename)
      (let ()
        (define res (get url #:stream? #t))
        (if (eq? 200 (response-status-code res))
            (let ()
              (log-4ch-info "~a" filename)
              (define in (response-output res))
              (call-with-output-file filename
                (λ (out)
                  (log-4ch-debug "(port-closed? in) = ~a (port-closed? out) = ~a" (port-closed? in) (port-closed? out))
                  (collect-garbage)
                  (copy-port in out)
                  ;; Tell GC we still want the response object around (and
                  ;; leave its input port alone until we're finished with it).
                  res)
                #:exists 'truncate))
            (log-4ch-warning "Got bad response from server: ~a" (response-status-line res))))))

(define ((default-filename thread-no) post)
  (string->path (format "~a_~a_~a~a"
                        thread-no
                        (hash-ref post 'tim)
                        (hash-ref post 'filename)
                        (hash-ref post 'ext))))

(define (download-thread-images board thread-no
                                #:filename [filename (default-filename thread-no)]
                                #:directory [directory (current-directory)])
  (make-directory* directory)
  (define posts (4ch-thread board thread-no))
  (for ([p posts]
        #:when (hash-has-key? p 'fsize))
    (define destination (build-path directory (filename p)))
    (define url (format "~a~a/~a~a" BASE-URL board (hash-ref p 'tim) (hash-ref p 'ext)))
    (download-file url destination
                   (base64-decode (string->bytes/utf-8 (hash-ref p 'md5))))))
