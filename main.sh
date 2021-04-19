#!/bin/bash
######################################################
#Create and edit by Lucas Ruffiner and Joaquim Pittet
#Last edit 19.04.2021 
#M122 EPSIC
######################################################


##############VARIABLE DE DÉPART##############
J1="X"
J2="O"

turn=1
game_on=true

case=( 1 2 3 4 5 6 7 8 9 )

##############FONCTION MENU##############
menu() {  
  clear
  echo "########################### Jouons au morpion ###########################
Voici les règles : il faut réussir à aligner 3 de ses signes pour gagner
La partie va commencer dans 10 secondes"
  sleep 1
}

##############FONCTION TABLEAU##############
tableau() { 
clear
echo ""
echo "          _________________"
echo "         |     |     |     |"
echo "         |  ${case[0]}  |  ${case[1]}  |  ${case[2]}  |"
echo "         |     |     |     |"
echo "         |  ${case[3]}  |  ${case[4]}  |  ${case[5]}  |"
echo "         |     |     |     |"
echo "         |  ${case[6]}  |  ${case[7]}  |  ${case[8]}  |"
echo "         |_____|_____|_____|"
echo ""
}

##############FONCTION JOUEURS##############
joueurs(){ 
  if [[ $(($turn % 2)) == 0 ]]
  then
    jouer=$J2
    echo -n "Joueur 2 choissi une case: "
  else
    echo -n "Joueur 1 choissi une case: "
    jouer=$J1
  fi

  read choix

  while (($choix<1))||(($choix>9)); do
	  echo "Saisie invalide (1 à 9) :"
	  read choix
	done

  space=${case[($choix -1)]} 

##############CONTRÔLE DE CASE##############
  if [[ ! $choix =~ ^-?[0-9]+$ ]] || [[ ! $space =~ ^[0-9]+$  ]]
  then 
    echo "Cette case est déjà utilisé."
    joueurs
  else
    case[($choix -1)]=$jouer
    ((turn=turn+1))
  fi
  space=${case[($choix-1)]} 
}

##############CONTRÔLE DES COMBINAISONS##############
controle_combinaison() {
  if  [[ ${case[$1]} == ${case[$2]} ]]&& \
      [[ ${case[$2]} == ${case[$3]} ]]; then
    game_on=false
  fi
  if [ $game_on == false ]; then
    if [ ${case[$1]} == 'X' ];then
      echo "Joueur 1 gagne!"
      return
      else
    if [ ${case[$1]} == 'O' ];then
      echo "Joueur 2 gagne!"
      return 
    fi
  fi
  fi
}

##############FONCTION VICTOIRE##############
victoire(){
  if [ $game_on == false ]; then return; fi
  controle_combinaison 0 1 2
  if [ $game_on == false ]; then return; fi
  controle_combinaison 3 4 5
  if [ $game_on == false ]; then return; fi
  controle_combinaison 6 7 8
  if [ $game_on == false ]; then return; fi
  controle_combinaison 0 4 8
  if [ $game_on == false ]; then return; fi
  controle_combinaison 2 4 6
  if [ $game_on == false ]; then return; fi
  controle_combinaison 0 3 6
  if [ $game_on == false ]; then return; fi
  controle_combinaison 1 4 7
  if [ $game_on == false ]; then return; fi
  controle_combinaison 2 5 8
  if [ $game_on == false ]; then return; fi

  if [ $turn -gt 9 ]; then 
    $game_on=false
    echo "Egalité!"
    demo
  fi
}

##############FONCTION POUR RELANCER UNE PARTIE##############
demo() {
    echo "Voulez vous re-jouer ? (y/n)" >&2
    read -rsn1 input
    if [ "$input" = "y" ]; then
      turn=1
      game_on=true
      case=( 1 2 3 4 5 6 7 8 9 )
      rejouer
    fi
    return 0
}


rejouer() {
  tableau
  while $game_on
  do
    joueurs
    tableau
    victoire
  done
  demo
}

menu
rejouer

##############SOURCE##############
#https://www.linuxtricks.fr/wiki/bash-memo-pour-scripter
#https://fr.wikibooks.org/wiki/Programmation_Bash/Regex
#https://devhints.io/bash
#https://devdocs.io/bash/
#M122 Cours bash.pdf
#https://github.com/FergyAlexBray
