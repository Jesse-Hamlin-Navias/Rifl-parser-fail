#lang br
(require "lexer-f.rkt" brag/support)

(define (make-tokenizer ip [path #f])
  (port-count-lines! ip)
  (lexer-file-path path)
  (define (next-token) (RifL-lexer ip))
    next-token)

(provide make-tokenizer)