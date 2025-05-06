(define (problem hanoi-3-disks)
  (:domain hanoi)
  (:objects
    d1 d2 d3 - disk   ; Trois disques, d1 est le plus petit
    r1 r2 r3 - rod    ; Trois piquets
  )

  (:init
    (handempty)

    ; Relations de taille entre les disques
    (smaller d1 d2)
    (smaller d1 d3)
    (smaller d2 d3)

    ; Les piquets r2 et r3 sont vides
    (rod-empty r2)
    (rod-empty r3)

    ; Tous les disques sont empilés sur r1
    (on-rod d1 r1)
    (on-rod d2 r1)
    (on-rod d3 r1)

    ; Relations d'empilement
    (on d1 d2)
    (on d2 d3)

    ; Le disque du bas
    (bottom-disk d3)

    ; Le disque supérieur est dégagé
    (clear d1)
  )

  (:goal
    (and
      (on-rod d1 r3)
      (on-rod d2 r3)
      (on-rod d3 r3)
      (on d1 d2)
      (on d2 d3)
      (bottom-disk d3)
    )
  )
)
