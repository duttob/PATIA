(define (domain hanoi)
  (:requirements :strips :typing)
  (:types disk rod)
  (:predicates 
    (on ?x - disk ?y - disk) ; le disque x est au dessus du disque y
    (clear ?x - disk)        ; x n'a aucun disque au dessus de lui
    (handempty)              ; la main est vide 
    (holding ?x - disk)      ; le disque x est dans la main
    (on-rod ?x - disk ?r - rod)  ; le disque x est sur le pique r
    (smaller ?x - disk ?y - disk); le disque x est plus petit que le disque y
    (rod-empty ?r - rod)      ; le pique r est vide
    (bottom-disk ?x - disk)   ; le disque x est un disque placé en premier sur un pique
  )
  
  (:action pick-up ; prendre dans la main le disque x placé sur le disque y sur le pique r
           :parameters (?x - disk ?y - disk ?r - rod)
           :precondition (and (clear ?x) (handempty) (on ?x ?y) (on-rod ?x ?r) (on-rod ?y ?r))
           :effect
           (and (not (clear ?x))
                (clear ?y)
                (not (handempty))
                (holding ?x)
                (not (on ?x ?y))
                (not (on-rod ?x ?r))))
  
  (:action pick-up-from-rod ; prendre dans la main le dernier disque x placé sur le pique r
           :parameters (?x - disk ?r - rod)
           :precondition (and (clear ?x) (handempty) (on-rod ?x ?r) (bottom-disk ?x))
           :effect
           (and (not (clear ?x))
                (not (handempty))
                (holding ?x)
                (not (on-rod ?x ?r))
                (not (bottom-disk ?x))
                (rod-empty ?r)))
  
  (:action put-on-empty-rod ; placer le disque dans la main sur le pique vide r
           :parameters (?x - disk ?r - rod)
           :precondition (and (holding ?x) (rod-empty ?r))
           :effect
           (and (not (holding ?x))
                (clear ?x)
                (handempty)
                (on-rod ?x ?r)
                (bottom-disk ?x)
                (not (rod-empty ?r))))
  
  (:action stack ; placer le disque x sur le disque y sur le pique r
           :parameters (?x - disk ?y - disk ?r - rod)
           :precondition (and (holding ?x) (clear ?y) (smaller ?x ?y) (on-rod ?y ?r))
           :effect
           (and (not (holding ?x))
                (not (clear ?y))
                (handempty)
                (clear ?x)
                (on ?x ?y)
                (on-rod ?x ?r)))
  
  (:action unstack ; placer dans la main le disque x placé au dessus de y sur le pique r
           :parameters (?x - disk ?y - disk ?r - rod)
           :precondition (and (on ?x ?y) (clear ?x) (handempty) (on-rod ?x ?r) (on-rod ?y ?r))
           :effect
           (and (holding ?x)
                (clear ?y)
                (not (clear ?x))
                (not (handempty))
                (not (on ?x ?y))
                (not (on-rod ?x ?r)))))