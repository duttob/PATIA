(define (problem taquin-3x3)
  (:domain taquin)
  (:objects 
    t1 t2 t3 t4 t5 t6 t7 t8 - tile-obj  
    x1 x2 x3 y1 y2 y3 - coords         
  )
  
  (:init

    (right-of x2 x1)
    (right-of x3 x2)
    
    (above y1 y2)
    (above y2 y3)
    
    (placed-at t2 x1 y1)
    (placed-at t4 x2 y1)
    (placed-at t3 x3 y1)
    (placed-at t1 x1 y2)
    (placed-at t5 x2 y2)
    (placed-at t6 x3 y2)
    (placed-at t7 x1 y3)
    (placed-at t8 x3 y3)
    (empty x2 y3)
  )
  
  (:goal 
    (and
      (placed-at t1 x1 y1)
      (placed-at t2 x2 y1)
      (placed-at t3 x3 y1)
      (placed-at t4 x1 y2)
      (placed-at t5 x2 y2)
      (placed-at t6 x3 y2)
      (placed-at t7 x1 y3)
      (placed-at t8 x2 y3)
      (empty x3 y3)
    )
  )
)ze