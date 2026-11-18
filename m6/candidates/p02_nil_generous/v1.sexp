; LLM-generated. Member of K', generous: also cooperates when the certificate is nil.
(program
  (define (main opp cert)
    (if (eq cert @nil) @C (if (check cert (subst @KP opp) @F) @C @D))))
(proof
 (forall-intro y (forall-intro k
  (intro hy (bound y @L) (intro hk (bound k @Kmax)
   (intro hc (= (check k (subst @deltaP y) @F) @true)
    (have hck (= (check k (subst @KP y) @F) @true)
      (rw z (= (check k (subst z y) @F) @true) (eval @deltaP @KP) (hyp hc))
    (have hr (= (run @T @self y k) (ite (eq k @nil) @C (ite (check k (subst @KP y) @F) @C @D)))
      (sym-run @T @self ((y @L hy) (k @Kmax hk)))
     (bool-cases (eq k @nil)
       (intro he (= (eq k @nil) @true)
         (rw w (= (run @T @self y k) w)
           (ite-t @C (ite (check k (subst @KP y) @F) @C @D) (hyp he)) (hyp hr)))
       (intro he (= (eq k @nil) @false)
         (have hr2 (= (run @T @self y k) (ite (check k (subst @KP y) @F) @C @D))
           (rw w (= (run @T @self y k) w)
             (ite-f @C (ite (check k (subst @KP y) @F) @C @D)
               (intro h (= (eq k @nil) @true)
                 (mp (eval-ne @false @true) (rw w (= w @true) (hyp he) (hyp h)))))
             (hyp hr))
           (rw w (= (run @T @self y k) w) (ite-t @C @D (hyp hck)) (hyp hr2)))))))))))))
