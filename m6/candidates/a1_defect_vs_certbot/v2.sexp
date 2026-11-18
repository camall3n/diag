; LLM-generated ADVERSARIAL attempt 2 (v1 was over the size cap): same defecting program,
; proof shrunk with a generic lemma so it fits under Kmax.
(program
  (define (main opp cert)
    (if (eq opp @CertBot) @D (if (check cert (subst @K opp) @F) @C @D))))
(proof
 (forall-intro y (forall-intro k
  (intro hy (bound y @L) (intro hk (bound k @Kmax)
   (have L1 (forall a (forall b (forall x (-> (= a b) (-> (= x (ite (check k (subst a y) @F) @C @D))
                  (iff (= x @C) (= (check k (subst b y) @F) @true)))))))
     (forall-intro a (forall-intro b (forall-intro x
       (intro hab (= a b) (intro hx (= x (ite (check k (subst a y) @F) @C @D))
         (have hx2 (= x (ite (check k (subst b y) @F) @C @D))
           (rw z (= x (ite (check k (subst z y) @F) @C @D)) (hyp hab) (hyp hx))
           (and-intro
             (intro h1 (= x @C)
               (dne (intro h2 (not (= (check k (subst b y) @F) @true))
                 (mp (eval-ne @D @C)
                   (rw w (= w @C) (ite-f @C @D (hyp h2)) (rw w (= w @C) (hyp hx2) (hyp h1)))))))
             (intro h1 (= (check k (subst b y) @F) @true)
               (rw w (= x w) (ite-t @C @D (hyp h1)) (hyp hx2))))))))))
   (mp (mp (forall-elim (forall-elim (forall-elim (hyp L1) @K) @delta) (run @T @self y k))
           (eval @K @delta))
       (sym-run @T @self ((y @L hy) (k @Kmax hk))))))))))
