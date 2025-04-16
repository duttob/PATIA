(define (problem hanoi-4-disks)
  (:domain hanoi)
  (:objects
    d1 d2 d3 d4 - disk   ; Quatre disques - d1 est le plus petit, d4 est le plus grand
    r1 r2 r3 - rod      ; Trois piques
  )
  
  (:init
    (handempty)
    
    (smaller d1 d2)
    (smaller d1 d3)
    (smaller d1 d4)
    (smaller d2 d3)
    (smaller d2 d4)
    (smaller d3 d4)
    
    (rod-empty r2)
    (rod-empty r3)
    
    (on-rod d1 r1)
    (on-rod d2 r1)
    (on-rod d3 r1)
    (on-rod d4 r1)
    
    (on d1 d2)
    (on d2 d3)
    (on d3 d4)
    
    (bottom-disk d4)
    
    (clear d1)
  )
  
  (:goal
    (and
      (on-rod d1 r3)
      (on-rod d2 r3)
      (on-rod d3 r3)
      (on-rod d4 r3)
      (on d1 d2)
      (on d2 d3)
      (on d3 d4)
      (bottom-disk d4)
    )
  )
)