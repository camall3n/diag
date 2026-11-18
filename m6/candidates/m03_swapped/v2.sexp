; LLM-generated, attempt 2 (v1's certificate was over the size cap): same program, proof
; restructured around a small generic lemma so the big literals appear only once.
(program
  (define (main opp cert)
    (if (eq (check cert (subst @K opp) @F) @false) @D @C)))
(proof
 (forall-intro y (forall-intro k
  (intro hy (bound y @L) (intro hk (bound k @Kmax)
   (have L2 (forall a (forall b (forall x
              (-> (= a b) (-> (= x (ite (eq (check k (subst a y) @F) @false) @D @C))
                (iff (= x @C) (= (check k (subst b y) @F) @true)))))))
     (forall-intro a (forall-intro b (forall-intro x
       (intro hab (= a b) (intro hx (= x (ite (eq (check k (subst a y) @F) @false) @D @C))
         (have hx2 (= x (ite (eq (check k (subst b y) @F) @false) @D @C))
           (rw z (= x (ite (eq (check k (subst z y) @F) @false) @D @C)) (hyp hab) (hyp hx))
           (and-intro
             (intro h1 (= x @C)
               (bool-cases (check k (subst b y) @F)
                 (intro ht (= (check k (subst b y) @F) @true) (hyp ht))
                 (intro hf (= (check k (subst b y) @F) @false)
                   (exfalso (= (check k (subst b y) @F) @true)
                     (mp (eval-ne @D @C)
                       (rw w (= w @C)
                         (ite-t @D @C
                           (rw w (= (eq w @false) @true)
                             (rw w (= w (check k (subst b y) @F)) (hyp hf) (refl (check k (subst b y) @F)))
                             (eval (eq @false @false) @true)))
                         (rw w (= w @C) (hyp hx2) (hyp h1))))))))
             (intro h1 (= (check k (subst b y) @F) @true)
               (rw w (= x w)
                 (ite-f @D @C
                   (intro he (= (eq (check k (subst b y) @F) @false) @true)
                     (mp (eval-ne (eq @true @false) @true)
                       (rw w (= (eq w @false) @true) (hyp h1) (hyp he)))))
                 (hyp hx2))))))))))
   (mp (mp (forall-elim (forall-elim (forall-elim (hyp L2) @K) @delta) (run @T @self y k))
           (eval @K @delta))
       (sym-run @T @self ((y @L hy) (k @Kmax hk))))))))))
