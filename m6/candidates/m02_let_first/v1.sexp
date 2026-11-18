; LLM-generated. Member of K: let-bind the substituted statement and the verdict first.
(program
  (define (main opp cert)
    (let stmt (subst @K opp)
      (let ok (check cert stmt @F)
        (if ok @C @D)))))
(proof
 (forall-intro y (forall-intro k
  (intro hy (bound y @L) (intro hk (bound k @Kmax)
   (have hr (= (run @T @self y k) (ite (check k (subst @K y) @F) @C @D))
     (sym-run @T @self ((y @L hy) (k @Kmax hk)))
   (rw z (iff (= (run @T @self y k) @C) (= (check k (subst z y) @F) @true))
     (eval @K @delta)
     (and-intro
       (intro h1 (= (run @T @self y k) @C)
         (dne (intro h2 (not (= (check k (subst @K y) @F) @true))
           (mp (eval-ne @D @C)
             (rw w (= w @C) (ite-f @C @D (hyp h2))
               (rw w (= w @C) (hyp hr) (hyp h1)))))))
       (intro h1 (= (check k (subst @K y) @F) @true)
         (rw w (= (run @T @self y k) w) (ite-t @C @D (hyp h1)) (hyp hr)))))))))))
