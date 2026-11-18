; LLM-generated, attempt 2 (v1 was over the certificate size cap): same program, proof
; restructured around two small generic lemmas so the big literals appear only once or twice.
(program
  (define (main opp cert)
    (if (isPair opp)
        (if (check cert (subst @K opp) @F) @C @D)
        (if (check cert (subst @K opp) @F) @C @D))))
(proof
 (forall-intro y (forall-intro k
  (intro hy (bound y @L) (intro hk (bound k @Kmax)
   (have L6 (forall c (forall x (-> (= x (ite (isPair y) (ite c @C @D) (ite c @C @D))) (= x (ite c @C @D)))))
     (forall-intro c (forall-intro x
       (intro hx (= x (ite (isPair y) (ite c @C @D) (ite c @C @D)))
         (bool-cases (isPair y)
           (intro hp (= (isPair y) @true)
             (rw w (= x w) (ite-t (ite c @C @D) (ite c @C @D) (hyp hp)) (hyp hx)))
           (intro hp (= (isPair y) @false)
             (rw w (= x w)
               (ite-f (ite c @C @D) (ite c @C @D)
                 (intro h (= (isPair y) @true)
                   (mp (eval-ne @false @true) (rw w (= w @true) (hyp hp) (hyp h)))))
               (hyp hx)))))))
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
       (mp (forall-elim (forall-elim (hyp L6) (check k (subst @K y) @F)) (run @T @self y k))
           (sym-run @T @self ((y @L hy) (k @Kmax hk))))))))))))
