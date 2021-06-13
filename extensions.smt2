(set-logic QF_BV)
(set-info :source |
	Constructed by Tjark Weber to test that the extensions defined
	in QF_BV are implemented according to their definition
|)
(set-info :smt-lib-version 2.0)
(set-info :category "check")
(set-info :status unsat)
; We could use any bit width m > 0.
(declare-fun s () (_ BitVec 5))
(declare-fun t () (_ BitVec 5))
(assert (not (and
; Bitvector constants
  (= (_ bv13 32) #b00000000000000000000000000001101)
; Bitwise operators
  (= (bvnand s t) (bvnot (bvand s t)))
  (= (bvnor s t) (bvnot (bvor s t)))
  (= (bvxor s t) (bvor (bvand s (bvnot t)) (bvand (bvnot s) t)))
  (= (bvxnor s t) (bvor (bvand s t) (bvand (bvnot s) (bvnot t))))
  (= (bvcomp s t) (bvand (bvxnor ((_ extract 4 4) s) ((_ extract 4 4) t))
                         (bvcomp ((_ extract 3 0) s) ((_ extract 3 0) t))))
; Arithmetic operators
  (= (bvsub s t) (bvadd s (bvneg t)))
  (= (bvsdiv s t) (let ((?msb_s ((_ extract 4 4) s))
                        (?msb_t ((_ extract 4 4) t)))
                    (ite (and (= ?msb_s #b0) (= ?msb_t #b0))
                         (bvudiv s t)
                    (ite (and (= ?msb_s #b1) (= ?msb_t #b0))
                         (bvneg (bvudiv (bvneg s) t))
                    (ite (and (= ?msb_s #b0) (= ?msb_t #b1))
                         (bvneg (bvudiv s (bvneg t)))
                         (bvudiv (bvneg s) (bvneg t)))))))
  (= (bvsrem s t) (let ((?msb_s ((_ extract 4 4) s))
                        (?msb_t ((_ extract 4 4) t)))
                    (ite (and (= ?msb_s #b0) (= ?msb_t #b0))
                         (bvurem s t)
                    (ite (and (= ?msb_s #b1) (= ?msb_t #b0))
                         (bvneg (bvurem (bvneg s) t))
                    (ite (and (= ?msb_s #b0) (= ?msb_t #b1))
                         (bvurem s (bvneg t))
                         (bvneg (bvurem (bvneg s) (bvneg t))))))))
  (= (bvsmod s t) (let ((?msb_s ((_ extract 4 4) s))
                        (?msb_t ((_ extract 4 4) t)))
                    (let ((abs_s (ite (= ?msb_s #b0) s (bvneg s)))
                          (abs_t (ite (= ?msb_t #b0) t (bvneg t))))
                      (let ((u (bvurem abs_s abs_t)))
                        (ite (= u (_ bv0 5))
                             u
                        (ite (and (= ?msb_s #b0) (= ?msb_t #b0))
                             u
                        (ite (and (= ?msb_s #b1) (= ?msb_t #b0))
                             (bvadd (bvneg u) t)
                        (ite (and (= ?msb_s #b0) (= ?msb_t #b1))
                             (bvadd u t)
                             (bvneg u)))))))))
  (= (bvule s t) (or (bvult s t) (= s t)))
  (= (bvugt s t) (bvult t s))
  (= (bvuge s t) (or (bvult t s) (= s t)))
  (= (bvslt s t) (or (and (= ((_ extract 4 4) s) #b1)
                          (= ((_ extract 4 4) t) #b0))
                     (and (= ((_ extract 4 4) s) ((_ extract 4 4) t))
                          (bvult s t))))
  (= (bvsle s t) (or (and (= ((_ extract 4 4) s) #b1)
                          (= ((_ extract 4 4) t) #b0))
                     (and (= ((_ extract 4 4) s) ((_ extract 4 4) t))
                          (bvule s t))))
  (= (bvsgt s t) (bvslt t s))
  (= (bvsge s t) (bvsle t s))
; Other operations
  (= (bvashr s t) (ite (= ((_ extract 4 4) s) #b0)
                       (bvlshr s t)
                       (bvnot (bvlshr (bvnot s) t))))
  (= ((_ repeat 1) t) t)
  (= ((_ repeat 2) t) (concat t ((_ repeat 1) t)))
  (= ((_ zero_extend 0) t) t)
  (= ((_ zero_extend 1) t) (concat ((_ repeat 1) #b0) t))
  (= ((_ sign_extend 0) t) t)
  (= ((_ sign_extend 1) t) (concat ((_ repeat 1) ((_ extract 4 4) t)) t))
  (= ((_ rotate_left 0) t) t)
  (= ((_ rotate_left 1) t) ((_ rotate_left 0)
                             (concat ((_ extract 3 0) t) ((_ extract 4 4) t))))
  (= ((_ rotate_right 0) t) t)
  (= ((_ rotate_right 1) t) ((_ rotate_right 0)
                              (concat ((_ extract 0 0) t) ((_ extract 4 1) t))))
)))
(check-sat)
(exit)