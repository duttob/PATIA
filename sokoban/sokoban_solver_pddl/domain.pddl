(define (domain sokoban)
  (:requirements :strips :typing)
  (:types coords player)
  (:predicates
    (player-at ?p - player ?x - coords ?y - coords)     ; joueur p en x, y              
    (box-at ?x - coords ?y - coords)          ; caisse en x, y 
    (empty ?x - coords ?y - coords)          ; case libre en x, y
    (right-of ?x1 - coords ?x2 - coords)            ; x1 est à droite de x2
    (above ?y1 - coords ?y2 - coords)               ; y1 est au-dessus de y2
  )

  (:action move-up
    :parameters (?p - player ?x - coords ?y - coords ?y_above - coords)
    :precondition (and (player-at ?p ?x ?y) 
                       (above ?y_above ?y)  ; y_above = y - 1
                       (empty ?x ?y_above)) ; vide(x, y - 1)

    :effect (and (not (player-at ?p ?x ?y)) ; déplacement: p(x, y) = p(x, y - 1)
                 (player-at ?p ?x ?y_above) 
                 (not (empty ?x ?y_above))
                 (empty ?x ?y)))            


   (:action push-up
      :parameters (?p - player ?x - coords ?y - coords ?y_above_1 - coords ?y_above_2 - coords)
      :precondition (and (player-at ?p ?x ?y) 
                         (above ?y_above_1 ?y)          ; y_above_1 = y - 1 
                         (above ?y_above_2 ?y_above_1)  ; y_above_2 = y_above_1 - 1
                         (box-at ?x ?y_above_1)         ; caisse en (x, y - 1)
                         (empty ?x ?y_above_2))         ; rien en (x, y - 2) -> on peut pousser        
      
      :effect (and (not (player-at ?p ?x ?y)) ; déplacement vers le haut (joueur): p(x, y) = p(x, y - 1)
                   (player-at ?p ?x ?y_above_1) 
                   (empty ?x ?y)              
                   
                   (not (empty ?x ?y_above_2))
                   (not (box-at ?x ?y_above_1)) ; déplacement vers le haut (caisse): c(x, y - 1) = c(x, y - 2) 
                   (box-at ?x ?y_above_2))) 
                 

    (:action move-down
      :parameters (?p - player ?x - coords ?y - coords ?y_below - coords)
      :precondition (and (player-at ?p ?x ?y)
                       (above ?y ?y_below)    ; y_below = y + 1 
                       (empty ?x ?y_below))   ; vide(x, y + 1)

      :effect (and (not (player-at ?p ?x ?y)) ; déplacement: p(x, y) = p(x, y - 1)
                 (player-at ?p ?x ?y_below)             
                 (not (empty ?x ?y_below))    
                 (empty ?x ?y)))              


   (:action push-down ; pousse la caise c au dessous du joueur p
      :parameters (?p - player ?x - coords ?y - coords ?y_below_1 - coords ?y_below_2 - coords)
      :precondition (and (player-at ?p ?x ?y) 
                         (above ?y ?y_below_1)          ; y_below_1 = y + 1 
                         (above ?y_below_1 ?y_below_2)  ; y_below_1 = y_below_2 + 1 
                         (box-at ?x ?y_below_1)     ; caisse en (x, y + 1)
                         (empty ?x ?y_below_2))         ; rien en (x, y + 2) -> on peut pousser              
      
      :effect (and (not (player-at ?p ?x ?y))           ; déplacement vers le bas (joueur): p(x, y) = p(x, y + 1)
                   (player-at ?p ?x ?y_below_1) 
                   (empty ?x ?y)              

                   (not (empty ?x ?y_below_2))
                   (not (box-at ?x ?y_below_1))     ; déplacement vers le bas (caisse): c(x, y + 1) = c(x, y + 2) 
                   (box-at ?x ?y_below_2))) 



    (:action move-left
      :parameters (?p - player ?x - coords ?y - coords ?x_left - coords)
      :precondition (and (player-at ?p ?x ?y)
                       (right-of ?x ?x_left)    ; x_left = x - 1
                       (empty ?x_left ?y))      ; vide(x - 1, y)

      :effect (and (not (player-at ?p ?x ?y))   ; déplacement: p(x, y) = p(x - 1, y)
                 (player-at ?p ?x_left ?y) 
                 (empty ?x ?y)              
                 (not (empty ?x_left ?y))))

    (:action push-left 
      :parameters (?p - player ?x - coords ?y - coords ?x_left_1 - coords ?x_left_2 - coords)
      :precondition (and (player-at ?p ?x ?y) 
                         (right-of ?x ?x_left_1)        ; x_left_1 = x - 1
                         (right-of ?x_left_1 ?x_left_2) ; x_left_2 = x_left_1 - 1 
                         (box-at ?x_left_1 ?y)      ; caisse en (x - 1, y)
                         (empty ?x_left_2 ?y))          ; rien en (x - 2, y) -> on peut pousser            
      
      :effect (and (empty ?x ?y)                        ; déplacement vers la gauche (joueur): p(x, y) = p(x - 1, y)
                   (not (player-at ?p ?x ?y))           
                   (player-at ?p ?x_left_1 ?y)        

                   (not (box-at ?x_left_1 ?y))      ; déplacement vers la gauche (caisse): c(x - 1, y) = c(x - 2, y) 
                   (not (empty ?x_left_2 ?y))
                   (box-at ?x_left_2 ?y))) 

    
    (:action move-right
      :parameters (?p - player ?x - coords ?y - coords ?x_right - coords)
      :precondition (and (player-at ?p ?x ?y)
                       (right-of ?x_right ?x)   ; x_right = x + 1
                       (empty ?x_right ?y))     ; vide(x + 1, y)

      :effect (and (not (player-at ?p ?x ?y))   ; déplacement: p(x, y) = p(x + 1, y)
                 (player-at ?p ?x_right ?y) 
                 (empty ?x ?y)              
                 (not (empty ?x_right ?y))))

    (:action push-right
      :parameters (?p - player ?x - coords ?y - coords ?x_right_1 - coords ?x_right_2 - coords)
      :precondition (and (player-at ?p ?x ?y) 
                         (right-of ?x_right_1 ?x)         ; x_right_1 = x + 1
                         (right-of ?x_right_2 ?x_right_1) ; x_right_2 = x_right_1 + 1
                         (box-at ?x_right_1 ?y)       ; caisse en (x + 1, y)
                         (empty ?x_right_2 ?y))           ; rien en (x + 2, y) -> on peut pousser             
      
      :effect (and (empty ?x ?y)                          ; déplacement vers la droite (joueur): p(x, y) = p(x + 1, y)
                   (not (player-at ?p ?x ?y))
                   (player-at ?p ?x_right_1 ?y)        

                   (not (empty ?x_right_2 ?y))
                   (not (box-at ?x_right_1 ?y))       ; déplacement vers la droite (caisse): c(x + 1, y) = c(x + 2, y) 
                   (box-at ?x_right_2 ?y))) 
)