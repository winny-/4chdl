#lang racket

(provide (all-defined-out))

(define/match (string->board+thread-no s)
  [((regexp #px"https?://boards.4chan.org/([a-z]+)/thread/(\\d+)" (list _ board thread-no)))
   (list (string->symbol board)
         (string->number thread-no))])
