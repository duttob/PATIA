(define (problem taquin-4x4)
  (:domain taquin)
  (:objects 
    t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 - tile-obj 
    x1 x2 x3 x4 y1 y2 y3 y4 - coords                               
  )
  
  (:init
    (right-of x2 x1)
    (right-of x3 x2)
    (right-of x4 x3)
    
    (above y1 y2)
    (above y2 y3)
    (above y3 y4)
    
    (placed-at t15 x1 y1)
    (placed-at t12 x2 y1)
    (empty x3 y1)
    (placed-at t4 x4 y1)
      
    (placed-at t8 x1 y2)
    (placed-at t14 x2 y2)
    (placed-at t9 x3 y2)
    (placed-at t1 x4 y2)
      
    (placed-at t13 x1 y3)
    (placed-at t11 x2 y3)
    (placed-at t7 x3 y3)
    (placed-at t3 x4 y3)
      
    (placed-at t6 x1 y4)
    (placed-at t5 x2 y4)
    (placed-at t2 x3 y4)
    (placed-at t10 x4 y4)
  )
  
  (:goal 
    (and
      (placed-at t1 x1 y1)
      (placed-at t2 x2 y1)
      (placed-at t3 x3 y1)
      (placed-at t4 x4 y1)
      
      (placed-at t5 x1 y2)
      (placed-at t6 x2 y2)
      (placed-at t7 x3 y2)
      (placed-at t8 x4 y2)
      
      (placed-at t9 x1 y3)
      (placed-at t10 x2 y3)
      (placed-at t11 x3 y3)
      (placed-at t12 x4 y3)
      
      (placed-at t13 x1 y4)
      (placed-at t14 x2 y4)
      (placed-at t15 x3 y4)
      (empty x4 y4)
    )
  )
)