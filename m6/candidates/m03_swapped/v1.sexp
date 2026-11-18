; LLM-generated. Member of K with swapped branches.
(program
  (define (main opp cert)
    (if (eq (check cert (subst @K opp) @F) @false) @D @C)))
(proof
 (forall-intro y (forall-intro k
  (intro hy (bound y @L) (intro hk (bound k @Kmax)
   (have hr (= (run @T @self y k) (ite (eq (check k (subst @K y) @F) @false) @D @C))
     (sym-run @T @self ((y @L hy) (k @Kmax hk)))
   (rw z (iff (= (run @T @self y k) @C) (= (check k (subst z y) @F) @true))
     (eval @K @delta)
     (and-intro
       ; R = C -> chk = true, by cases on the boolean chk
       (intro h1 (= (run @T @self y k) @C)
         (bool-cases (check k (subst @K y) @F)
           (intro ht (= (check k (subst @K y) @F) @true) (hyp ht))
           (intro hf (= (check k (subst @K y) @F) @false)
             (exfalso (= (check k (subst @K y) @F) @true)
               (mp (eval-ne @D @C)
                 (rw w (= w @C)
                   ; E = D, since eq(chk, false) = true
                   (ite-t @D @C
                     (rw w (= (eq w @false) @true)
                       (rw w (= w (check k (subst @K y) @F)) (hyp hf) (refl (check k (subst @K y) @F)))
                       (eval (eq @false @false) @true)))
                   ; E = C, from R = E and R = C
                   (rw w (= w @C) (hyp hr) (hyp h1))))))))
       ; chk = true -> R = C, since eq(chk, false) is then not true
       (intro h1 (= (check k (subst @K y) @F) @true)
         (rw w (= (run @T @self y k) w)
           (ite-f @D @C
             (intro he (= (eq (check k (subst @K y) @F) @false) @true)
               (mp (eval-ne (eq @true @false) @true)
                 (rw w (= (eq w @false) @true) (hyp h1) (hyp he)))))
           (hyp hr)))))))))))
