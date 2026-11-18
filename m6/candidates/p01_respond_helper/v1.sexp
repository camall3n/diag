; LLM-generated. Member of K' (one-way standard), cautious.
(program
  (define (main opp cert) (respond (check cert (subst @KP opp) @F)))
  (define (respond ok) (if ok @C @D)))
(proof
 (forall-intro y (forall-intro k
  (intro hy (bound y @L) (intro hk (bound k @Kmax)
   (intro hc (= (check k (subst @deltaP y) @F) @true)
    (have hr (= (run @T @self y k) (ite (check k (subst @KP y) @F) @C @D))
      (sym-run @T @self ((y @L hy) (k @Kmax hk)))
     (rw w (= (run @T @self y k) w)
       (ite-t @C @D (rw z (= (check k (subst z y) @F) @true) (eval @deltaP @KP) (hyp hc)))
       (hyp hr)))))))))
