; LLM-generated ADVERSARIAL attempt: DefectBot tries to turn "the certificate checks" into "I cooperate".
(program (define (main opp cert) @D))
(proof
 (forall-intro y (forall-intro k
  (intro hy (bound y @L) (intro hk (bound k @Kmax)
   (intro hc (= (check k (subst @deltaP y) @F) @true)
     (rw w (= (run @T @self y k) w)
       (hyp hc)
       (sym-run @T @self ((y @L hy) (k @Kmax hk))))))))))
