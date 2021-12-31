#lang racket

(require "http.rkt"
         openssl/md5
         net/base64
         "api.rkt"
         "logger.rkt")

(provide (prefix-out 4ch- (combine-out download-file download-thread-images)))

(define BASE-URL "https://i.4cdn.org/")

(define (my-copy-port src dest . dests*)
  (unless (input-port? src)
    (raise-type-error 'copy-port "input-port" src))
  (for-each
   (lambda (dest)
     (unless (output-port? dest)
       (raise-type-error 'copy-port "output-port" dest)))
   (cons dest dests*))

  (define sz 4096)
  (define s (make-bytes sz))
  (define dests (cons dest dests*))
  (define read-count 0)

  (let loop ()
    (log-4ch-debug "Copy beginning of (loop)")
    (define c (read-bytes-avail! s src))
    (cond
      [(number? c)
       (set! read-count (+ read-count c))
       (log-4ch-debug "Writing ~a bytes (~a total)" c read-count)
       (for ([dest (in-list dests)])
         (let write-loop ([bytes-written 0])
           (unless (= bytes-written c)
             (define c2 (write-bytes-avail s dest bytes-written c))
             (write-loop (+ bytes-written c2)))))
       (loop)]
      [(procedure? c)
       (log-4ch-debug "Proc")
       (define-values (l col p) (port-next-location src))
       (define v (c (object-name src) l col p))
       (for ([dest (in-list dests)])
         (write-special v dest))
       (loop)]
      [else
       (log-4ch-debug "EOF")
       ;; Must be EOF
       (void)])))

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
                  (my-copy-port in out)
                  ;; Tell GC we still want the response object around (and
                  ;; leave its input port alone until we're finished with it).
                  #;res
                  )
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
