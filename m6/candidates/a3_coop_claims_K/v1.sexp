; LLM-generated ADVERSARIAL attempt: an unconditional cooperator claims K.
(program (define (main opp cert) @C))
(proof
 (forall-intro y (forall-intro k
  (intro hy (bound y @L) (intro hk (bound k @Kmax)
   (have hr (= (run @T @self y k) @C)
     (sym-run @T @self ((y @L hy) (k @Kmax hk)))
   (and-intro
     ; "the check is true": try to evaluate it
     (intro h1 (= (run @T @self y k) @C) (eval (check k (subst @delta y) @F) @true))
     (intro h1 (= (check k (subst @delta y) @F) @true) (hyp hr)))))))))
