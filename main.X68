*-----------------------------------------------------------
* Program    : 	Puissance 4
* Written by :  Fabien RECCO
* vim: set ft=asm:
*
* Date de création :  19 mars 2009
* Dernière modification :  31 mars 2009
* GROUPE 4 - POSTE 2
*
* Description : Version 2 joueurs
*-----------------------------------------------------------

	
		
	ORG	$300
	
	
	
	
SON	DC.B	'\my_path\kangoo.wav',0
	
	
*** Titre ***
LIGNE		DC.B	'###########################################',0		on a besoin de concaténer avec 0 pour utiliser le TRAP #15 avec DO=14 (pour que ça s'arrête !!)
LIGNE2		DC.B	'#                                         #',0
LIGNE_TEXTE	DC.B	'#          PROJET IPM : PUISSANCE 4       #',0

SAUT	DC.B	$0a,$0d,'                  ',0


*** Motifs de la grille ***
NBRS	DC.B	'   1     2     3     4     5     6     7  ',0
HAUT	DC.B	' _ _ _',0
BAS	DC.B	'|_ _ _',0
BARRE	DC.B	'|',0


*** L'affichage du "pion" varie selon que c'est le joueur 1 qui a joué dans la case, le joueur 2, ou que la case est vide ***
EMPTY	DC.B	'|     ',0	Case vide
JOUEUR1 DC.B	'|  X  ',0	Joueur 1
JOUEUR2 DC.B	'|  O  ',0	Joueur 2


*** JEU ***
J1	DC.B	'Joueur 1, entrez un numero de colonne : ',0
J2	DC.B	'Joueur 2, entrez un numero de colonne : ',0
COL_PLN	DC.B	'La colonne est pleine ! Veuillez choisir une autre colonne.',$0a,$0d,0
ERROR	DC.B	'Le numero de colonne doit etre compris entre 1 et 7.',0

NUL	DC.B	'!!!!!!!!!!!!!!!! Match nul !!!!!!!!!!!!!!!!',$0a,$0d,0
END	DC.B	'Partie finie !!',0

G1	DC.B	'Le joueur 1 a gagne !',0
G2	DC.B	'Le joueur 2 a gagne !',0


*** MODE ***
MOD	DC.B	'Choisissez le mode de jeu : 1=mode un joueur, 2=mode deux joueurs',0
REJOUER	DC.B	'Voulez-vous rejouer la partie ? (y/n) ',0


*** SCORE ***
SCR	DC.B	'     Joueur1 (X) - Joueur2 (O) : ',0
ESP	DC.B	' - ',0


*** NOM DES JOUEURS ***
NOMJ1	DS.B	20
NOMJ2	DS.B	20







START	ORG	$2000	
	
	MOVE.L	#0,D7		Joueur1 commence (pour la première partie !!)
	
	MOVE.L	#0,A2		A2: score du joueur 1 	(initialisation)
	MOVE.L	#0,A3		A3: score du joueur 2	(initialisation)
	
	BRA	MODE
	
	
		
	
TITRE
	BSR	SAUTER		J'utilise la subroutine	SAUTER pour sauter une ligne (et se déplacer vers la droite)
	LEA	LIGNE,A1
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	
	BSR	SAUTER		J'utilise la subroutine	SAUTER pour sauter une ligne (et se déplacer vers la droite)
	LEA	LIGNE2,A1	Je mets l'adresse LIGNE2 dans A1
	TRAP	#15
	
	BSR	SAUTER		J'utilise la subroutine	SAUTER pour sauter une ligne (et se déplacer vers la droite)
	LEA	LIGNE_TEXTE,A1	Je mets l'adresse LIGNE_TEXTE dans A1
	TRAP	#15
	
	BSR	SAUTER		J'utilise la subroutine	SAUTER pour sauter une ligne (et se déplacer vers la droite)
	LEA	LIGNE2,A1	Je mets l'adresse LIGNE2 dans A1
	TRAP	#15
	
	BSR	SAUTER		J'utilise la subroutine	SAUTER pour sauter une ligne (et se déplacer vers la droite)
	LEA	LIGNE,A1	Je mets l'adresse LIGNE dans A1
	TRAP	#15
	
	BSR	SAUTER		J'utilise la subroutine	SAUTER pour sauter une ligne (et se déplacer vers la droite)
	BSR	SAUTER		J'utilise la subroutine	SAUTER pour sauter une ligne (et se déplacer vers la droite)
	
	BSR	SCORE		***
	
	RTS


SCORE
	LEA	SCR,A1
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	
	MOVE.L	A2,D1
	MOVE.L	#3,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	
	LEA	ESP,A1
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	
	MOVE.L	A3,D1
	MOVE.L	#3,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	
		
	BSR	SAUTER
	
	RTS






SAUTER
	LEA	SAUT,A1		Je mets l'adresse SAUT dans le registre d'adresses A1
	MOVE.L	#14,D0		Je mets 14 dans le registre de données D0 pour utiliser le TRAP #15 correspondant à l'affichage
	TRAP	#15
	RTS	
	
AFFICHAGE_HAUT
	LEA	NBRS,A1		Je donne à A1 l'adresse de NBRS
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	BSR	SAUTER		Je vais à la subroutine SAUTER
	BSR	AFFICHAGE_HAUT2
	RTS
	
AFFICHAGE_HAUT2
	LEA	HAUT,A1		Je donne à A1 l'adresse de HAUT
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	DBF 	D1,AFFICHAGE_HAUT2	Si D1!=-1 je vais à AFFICHAGE_HAUT
	BSR	SAUTER		Je vais à la subroutine SAUTER
	RTS


INTERMEDIAIRE			*écriture de la ligne sans pions
	LEA	EMPTY,A1	Je donne à A1 l'adresse de MESSAGE
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15		
	DBF 	D1,INTERMEDIAIRE	Si D1!=-1 je vais à INTERMEDIAIRE
	
	LEA	BARRE,A1
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	
	LEA	SAUT,A1		Je donne à A1 l'adresse SAUT
	MOVE.L	#6,D1		Je mets 6(valeur décimale) dans le registre de données D1
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	
	BSR	INTERMEDIAIRE2	On va à la subroutine INTERMEDIAIRE2
	
	RTS

	
INTERMEDIAIRE2			*écriture de la ligne avec les pions
	BSR	ECRIRE_PION	
	DBF 	D1,INTERMEDIAIRE2	Si D1!=-1 je vais à INTERMEDIAIRE2
	
	
	LEA	BARRE,A1	Je mets BARRE dans A1
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP #15 correspondant à l'affichage
	TRAP	#15
	
	LEA	SAUT,A1		Je mets SAUT dans A1
	MOVE.L	#6,D1		Le registre D1 prend la valeur #6 (move immédiat)
	MOVE.L	#14,D0		Le registre D0 prend la valeur 14 pour utiliser le TRAP #15 correspondant
	TRAP	#15
	
	RTS

	
AFFICHAGE_BAS
	LEA	BAS,A1		Je donne à A1 l'adresse de MESSAGE
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	DBF 	D1,AFFICHAGE_BAS
	
	LEA	BARRE,A1
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	BSR	SAUTER
	RTS
 
 
 
*** Programme d'écriture d'un pion dans la grille : X, 0 ou vide ***
	

ECRIRE_PION
	ADD.L	#1,A5
	MOVE.L 	#0,D3
	MOVE.B	(A5),D3
	BSR	ECRITURE
	
	RTS

ADDMULT7
	ADD.L	D5,A5
	DBF	D4,ADDMULT7
	RTS
	


ECRITURE
 	CMP.L	#1,D3
 	BEQ	PION1
 	CMP.L	#2,D3
 	BEQ	PION2
	LEA	EMPTY,A1	Je donne à A1 l'adresse de EMPTY
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	
	RTS
	
PION1
	LEA	JOUEUR1,A1	Je donne à A1 l'adresse de JOUEUR1
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	
	RTS
	
PION2
	LEA	JOUEUR2,A1	Je donne à A1 l'adresse de JOUEUR2
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	
	RTS
*** FIN du prgm ***


CLEAR				*Efface l'écran
	MOVE.W	#$FF00,D1
	MOVE.L	#11,D0
	TRAP	#15
	RTS
		
	
CREER_GRILLE
	MOVE.L	#6,D1
	BSR	INTERMEDIAIRE
	
	MOVE.L	#6,D1
	BSR	AFFICHAGE_BAS
	

	SUB.L	#7,A5
	ADD.L	#$10,A5
	
	DBF	D2,CREER_GRILLE
	RTS
	
	
	




******** MEMOIRE **************

DEBUT
	MOVE.L	#6,D1
	BSR	INITIALISATION
	SUB.L	#$17,A0
	DBF	D0,DEBUT
	
	RTS

	
INITIALISATION
	MOVE.B	#0,(A0)+	Je mets 0 dans la case mémoire ayant l'adresse 1200
	DBF	D1,INITIALISATION
	
	RTS
	

ENTRERNOMBRE
	BSR	SAUTER
	MOVE.L	#$1206,A5
	
	ADD.L	#1,D7		On ajoute 1 à D7
	BSR	TEXTE_JOUER
	
	MOVE.L	#$1210,A0	
	
	MOVE.L 	#0,D1		initialisation D1
	MOVE.L	#4,D0		
	TRAP	#15		On lit un numéro de colonne au clavier, qui sera stocké dans D1 (Longword)
	MOVE.L	D1,D6
	
	BSR	SAUTER
	
	CMP.L	#1,D1
	BEQ	REMPLISSAGE
	
	ADD.L	#1,A0
	CMP.L	#2,D1
	BEQ	REMPLISSAGE
	
	ADD.L	#1,A0
	CMP.L	#3,D1
	BEQ	REMPLISSAGE
	
	ADD.L	#1,A0		
	CMP.L	#4,D1
	BEQ	REMPLISSAGE	
	
	ADD.L	#1,A0
	CMP.L	#5,D1
	BEQ	REMPLISSAGE
	
	ADD.L	#1,A0
	CMP.L	#6,D1
	BEQ	REMPLISSAGE
	
	ADD.L	#1,A0
	CMP.L	#7,D1
	BEQ	REMPLISSAGE
		
	SUB.L	#1,D7	
	LEA	ERROR,A1
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	BSR	SAUTER
	BSR	ENTRERNOMBRE	cas ou on a pas mis un numero de colonne valide
	
	RTS
	
	
JEU
	CMP.B	#00,(A5)
	BEQ	ENTRERNOMBRE
	
	SUB.L	#$1,A5
	CMP.L	#$11AF,A5
	BGT	JEU
	
	BRA	FINITO
	
	
FINITO
	BSR	SAUTER
	LEA	NUL,A1
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	
	SUB.L	#1,D7
	
	BRA FINDEPARTIE
	


REMPLISSAGE
	CMP.L	#$11AF,A0
	BLT	PLEIN	
	
	SUB.L	#$10,A0
	MOVE.L	A0,A6
	CMP.B	#0,(A0)
	BNE	REMPLISSAGE
	
	BSR	PARITE
	MOVE.B	D7,(A0)
	*JMP	JEU
	BSR	GAGNE	  	*** AJOUT EN IPM ***
	BSR	CLEAR
	
	JMP	 MAIN
	
PLEIN
	SUB.L	#1,D7
	LEA	COL_PLN,A1
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	
	JMP	JEU
		

PARITE
	CMP	#1,D7
	BEQ	RETOUR
	
	CMP	#2,D7
	BEQ	RETOUR
	
	SUB.B	#2,D7
	BRA 	PARITE
	
	RTS	

TEXTE_JOUER
	BSR 	PARITE
	CMP	#2,D7
	BEQ	TEXTE2
	
	LEA	J1,A1
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	RTS
	
	
TEXTE2
	LEA	J2,A1
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	RTS

	
RETOUR	RTS

	
	
PROGRAM

	MOVE.L	#$1206,A5
	MOVE.L	#$1200,A0
	MOVE.L	#5,D0
	BSR	DEBUT
	
	MOVE.L	#2,D0
	BSR	JEU


*********** Pour savoir si un joueur gagne la partie ************

GAGNE		*adresse du dernier pion ajouté : dans A6
		* pion du joueur dans D6 (colonne)
		* numero du joueur : D7
* il faut vérifier si il y a une ligne de 4 pions dans la colonne, la ligne et les deux diagonales
	
	
	
	
	
VERTICAL

	MOVE.L	A6,A5
	
	MOVE.B	#$0,D4
	
BASV	
	ADD.B	#$1,D4
	SUB.L	#$10,A5
	CMP.B	(A5),D7
	BEQ	BASV
	
	MOVE.L	A6,A5
	SUB.B	#$1,D4
	
HAUTV	
	ADD.B	#$1,D4
	ADD.L	#$10,A5
	CMP.B	(A5),D7
	BEQ	HAUTV
	
	CMP.B	#$4,D4
	BEQ	FINI


HORIZONTAL

	MOVE.L	A6,A5
	
	MOVE.B	#$0,D4
	
GAUCHE	
	ADD.B	#$1,D4
	SUB.L	#$1,A5
	CMP.B	(A5),D7
	BEQ	GAUCHE
	
	MOVE.L	A6,A5
	SUB.B	#$1,D4
	
DROITE	
	ADD.B	#$1,D4
	ADD.L	#$1,A5
	CMP.B	(A5),D7
	BEQ	DROITE
	
	CMP.B	#$4,D4
	BEQ	FINI

DIAGONAL1

	MOVE.L	A6,A5
	
	MOVE.B	#$0,D4
	
BASD1	
	ADD.B	#$1,D4
	SUB.L	#$11,A5
	CMP.B	(A5),D7
	BEQ	BASD1
	
	MOVE.L	A6,A5
	SUB.B	#$1,D4
	
HAUTD1	
	ADD.B	#$1,D4
	ADD.L	#$11,A5
	CMP.B	(A5),D7
	BEQ	HAUTD1
	
	CMP.B	#$4,D4
	BEQ	FINI

DIAGONAL2

	MOVE.L	A6,A5
	
	MOVE.B	#$0,D4
	
HAUTD2	
	ADD.B	#$1,D4
	SUB.L	#$1,A5
	ADD.L	#$10,A5
	CMP.B	(A5),D7
	BEQ	HAUTD2
	
	MOVE.L	A6,A5
	SUB.B	#$1,D4
	
BASD2	
	ADD.B	#$1,D4
	ADD.L	#$1,A5
	SUB.L	#$10,A5
	CMP.B	(A5),D7
	BEQ	BASD2
	
	CMP.B	#$4,D4
	BEQ	FINI

	RTS
	


FINI	
	BSR	CLEAR
	BSR	TITRE
	
	MOVE.L	#$11B0,A5
	SUB.L	#1,A5
	MOVE.L	#6,D1
	
	BSR	SAUTER
	BSR	AFFICHAGE_HAUT
	
	MOVE.L	#5,D2
	BSR	CREER_GRILLE
	
	BSR	SAUTER
	LEA	END,A1
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	
	BSR	SOUND

	CMP.B	#1,D7
	BEQ	G1GAGNE
	
	BSR	SAUTER
	LEA	G2,A1
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	ADD.L	#1,A3
	
	BRA 	FINDEPARTIE

SOUND
	LEA	SON,A1
	MOVE.W	#70,D0
	TRAP	#15
	
	RTS

		
G1GAGNE	
	BSR	SAUTER
	LEA	G1,A1
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	ADD.L	#1,A2
	
	BRA 	FINDEPARTIE
	
FINDEPARTIE
	BSR	SAUTER
	BSR 	SAUTER
	LEA	REJOUER,A1
	MOVE.L	#14,D0		Je mets 14 dans D0 pour utiliser le TRAP correspondant à l'affichage
	TRAP	#15
	
	MOVE.L	#5,D0
	TRAP	#15
	
	CMP.B	#'y',D1
	BEQ	DEUXJOUEURS
	
	CMP.B	#'Y',D1
	BEQ	DEUXJOUEURS
	
	CMP.B	#'n',D1
	BEQ	FIN
	
	CMP.B	#'N',D1
	BEQ	FIN
	
	BRA	FINDEPARTIE
	



*********** /MEMOIRE *************


INIT
	MOVE.L	#$1206,A5
	MOVE.L	#$1200,A0
	MOVE.L	#5,D0
	MOVE.L	#0,D2
	BSR	DEBUT
	BRA	MAIN



	
MAIN
	

	BSR	TITRE
	
	MOVE.L	#$11B0,A5
	SUB.L	#1,A5
	MOVE.L	#6,D1
	
	BSR	SAUTER
	BSR	AFFICHAGE_HAUT
	
	MOVE.L	#5,D2
	BSR	CREER_GRILLE
	
	BSR	JEU
	
	
	
MODE
	BSR	CLEAR
	LEA	MOD,A1
	MOVE.L	#13,D0
	TRAP	#15
	
	MOVE.L	#4,D0
	TRAP	#15
	
	CMP.L	#1,D1
	BEQ	UNJOUEUR
	
	CMP.L	#2,D1
	BEQ	DEUXJOUEURS
	
	BSR	CLEAR
	BRA 	MODE
	
UNJOUEUR
	BRA	MODE

	
DEUXJOUEURS
	BSR	CLEAR
	BRA 	INIT
	 

FIN
	MOVE.B 	#9,D0
	TRAP	#15
	END	START
