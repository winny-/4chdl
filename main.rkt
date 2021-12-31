#lang racket/base

(module+ main
  (require "private/download.rkt"
           "private/url.rkt"
           "private/logger.rkt"
           racket/logging
           racket/cmdline
           racket/function
           racket/match)
  (define dir (make-parameter (current-directory)))
  (define verbosity (make-parameter 'error))
  [command-line
   #:once-each
   (["-d" "--directory"] user-specified-dir "Directory to save images to." (dir (string->path user-specified-dir)))
   (["-v" "--verbosity"] user-specified-verbosity "Verbosity: fatal, error, warning, info, debug - default to error" (verbosity (string->symbol user-specified-verbosity)))
   #:args threads
   (with-logging-to-port (current-error-port)
     (thunk (for ([th threads])
              (match-define (list board thread-no) (string->board+thread-no th))
              (4ch-download-thread-images board thread-no #:directory (dir))))
     #:logger 4ch-logger (verbosity))])
