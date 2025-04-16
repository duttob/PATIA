(define (domain taquin)
  (:requirements :strips :typing)
  (:types tile-obj coords)
  (:predicates
    (placed-at ?t - tile-obj ?x - coords ?y - coords)
    (empty ?x - coords ?y - coords)
    (right-of ?x1 - coords ?x2 - coords)  ; x1 est à droite de x2
    (above ?y1 - coords ?y2 - coords)     ; y1 est au-dessus de y2
  )

  (:action move-up
    :parameters (?t - tile-obj ?x - coords ?y - coords ?y-above - coords)
    :precondition (and (empty ?x ?y-above) 
                       (placed-at ?t ?x ?y) 
                       (above ?y-above ?y))
    :effect (and (not (empty ?x ?y-above)) 
                 (not (placed-at ?t ?x ?y)) 
                 (empty ?x ?y) 
                 (placed-at ?t ?x ?y-above))
  )

  (:action move-down
    :parameters (?t - tile-obj ?x - coords ?y - coords ?y-below - coords)
    :precondition (and (empty ?x ?y-below) 
                       (placed-at ?t ?x ?y) 
                       (above ?y ?y-below))
    :effect (and (not (empty ?x ?y-below)) 
                 (not (placed-at ?t ?x ?y)) 
                 (empty ?x ?y) 
                 (placed-at ?t ?x ?y-below))
  )

  (:action move-left
    :parameters (?t - tile-obj ?x - coords ?y - coords ?x-left - coords)
    :precondition (and (empty ?x-left ?y) 
                       (placed-at ?t ?x ?y) 
                       (right-of ?x ?x-left))
    :effect (and (not (empty ?x-left ?y)) 
                 (not (placed-at ?t ?x ?y)) 
                 (empty ?x ?y) 
                 (placed-at ?t ?x-left ?y))
  )

  (:action move-right
    :parameters (?t - tile-obj ?x - coords ?y - coords ?x-right - coords)
    :precondition (and (empty ?x-right ?y) 
                       (placed-at ?t ?x ?y) 
                       (right-of ?x-right ?x))
    :effect (and (not (empty ?x-right ?y)) 
                 (not (placed-at ?t ?x ?y)) 
                 (empty ?x ?y) 
                 (placed-at ?t ?x-right ?y))
  )
)