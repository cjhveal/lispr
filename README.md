# lispr

`lispr` is a tiny lisp implementation in ruby. Standard library included.

Inspiration borrowed heavily from Peter Norvig's [Lispy Tutorial](http://norvig.com/lispy.html)

### Examples:
```
(define fib (lambda(n) (if (or (== n 0) (== n 1)) n (+ (fib (- n 1))

(fib (- n 2))))))
```
