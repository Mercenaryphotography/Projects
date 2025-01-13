#!/bin/bash

clear
Player_Health=100

source ./Sources/config.txt
source ./Sources/saveload.txt
source ./Sources/combat.txt

# Game opening loop
cat Gametitle.txt | while IFS= read -r line; do echo -e "$line" ; done
while true; do
    if [ -f save.txt ]; then
		loadgame
        # If the save.txt file exists, Load the current player's data and proceed directly to the town_menu
        town_menu
        break
    else
        # If no save file is found, prompt for name
        read -p "What is your name, Adventurer? (This will set your character name!) " name
        
        # Ensure the name isn't empty
        if [[ -n "$name" ]]; then
            # Now prompt for weapon choice once the name is set
            while true; do
                cat $menu1
                echo
                read -p "What is your weapon of choice? " choice
                echo " "

                case $choice in
                    1) class_weapon=Sword ; Player_class=Warrior; break ;;
                    2) class_weapon=Staff ; break ;;
                    3) class_weapon=Dagger ; break ;;
                    *) echo "Invalid choice";;
                esac
            done
            break
        else
            echo "You must enter a name."
        fi
    fi
done

clear

# states that look for name or class_weapon 
source ./Sources/world.txt
source ./Sources/playerstate.txt
# Explore function, checks for map flags, then loads the appropriate menu and case option loop.
explore() {
    echo "Debugging Explore function: Checking map flags..."
    echo "Plains: $Plains, Caves: $Caves, Mountains: $Mountains, River: $River, Ruins: $Ruins, Lake: $Lake"
read -n 1 -srp "Hit any key to continue..."
    # Check conditions and display the appropriate menu
    if [[ "$Plains" == "1" ]] && [[ "$Caves" == "0" ]] && [[ "$Mountains" == "0" ]] && [[ "$River" == "0" ]] && [[ "$Ruins" == "0" ]] && [[ "$Lake" == "0" ]]; then
        clear
		cat ./menus/menuexl1.txt
		echo
        read -p "Choose an action: " action
        case $action in
            1) clear ; plains ;;
            2) clear ; return ;; 
            *) echo "Invalid choice";;
        esac
    elif [[ "$Plains" == "1" ]] && [[ "$Caves" == "0" ]] && [[ "$Mountains" == "1" ]] && [[ "$River" == "0" ]] && [[ "$Ruins" == "0" ]] && [[ "$Lake" == "0" ]]; then
        clear
		cat ./menus/menuexl2.txt
		echo
        read -p "Choose an action: " action
        case $action in
            1) clear ; plains ;;
            2) clear ; mountains ;;
            3) clear ; return ;; 
            *) echo "Invalid choice";;
        esac
    elif [[ "$Plains" == "1" ]] && [[ "$Caves" == "1" ]] && [[ "$Mountains" == "1" ]] && [[ "$River" == "0" ]] && [[ "$Ruins" == "0" ]] && [[ "$Lake" == "0" ]]; then
        cat ./menus/menuexl3.txt
		echo
		read -p "Choose an action; " action
		case $action in
			 1) clear ; plains ;;
            2) clear ; mountains ;;
			3) clear ; caves ;;
            4) clear ; return ;; 
            *) echo "Invalid choice";;
		esac
    elif [[ "$Plains" == "1" ]] && [[ "$Caves" == "1" ]] && [[ "$Mountains" == "1" ]] && [[ "$River" == "1" ]] && [[ "$Ruins" == "0" ]] && [[ "$Lake" == "0" ]]; then
        cat ./menus/menuexl4.txt
    elif [[ "$Plains" == "1" ]] && [[ "$Caves" == "1" ]] && [[ "$Mountains" == "1" ]] && [[ "$River" == "1" ]] && [[ "$Ruins" == "0" ]] && [[ "$Lake" == "1" ]]; then
        cat ./menus/menuexl5.txt
    elif [[ "$Plains" == "1" ]] && [[ "$Caves" == "1" ]] && [[ "$Mountains" == "1" ]] && [[ "$River" == "1" ]] && [[ "$Ruins" == "1" ]] && [[ "$Lake" == "1" ]]; then
        cat ./menus/menuexl6.txt
    else
        echo "No valid map configuration found!"
    fi
}


coward() {
running=$((Player_lvl * 6))
	if [ $run -gt $running ] ; then 
	echo You get away ; sleep 2
	Amon_Health=Amon_Maxhealth
	town_menu 
	else
	echo You are unable to escape
	get_damage_mon ; sleep 2 
	fi
}
# Battle System

# Functions for User
Character_info() {
    echo "$name"
	echo "$Player_class"
	echo -e "$Gld $Player_lvl"
	echo -e "Gold $Player_gold "
    echo -e "$G HP $Std $Player_Health"
    echo -e "$Gld Exp $Std $Player_exp  Exp required for next level $cy $exp_required $Std"
    echo -e "$R Str $Std $Player_Strength"
    echo -e "$B Def $Std $Player_Defense"
	echo -e "$Y luck $Std $Player_Luck"
    if [ "$statusp" = "1" ]; then
        echo -e "$P POISONED $std Antidote to Cure"
	elif [[ "$Witch_Amulet" == "obtained" ]] && [[ "$Witch_Heart" == "missing" ]] && [[ "$Witch_Cauldron" == "missing" ]] && [[ "$Witch_Eyes" == "missing" ]] && [[ "$Witch_Book" == "missing" ]]; then
    echo -e "$Gld Witch Amulet $Std"
	elif [[ "$Witch_Amulet" == "obtained" ]] && [[ "$Witch_Heart" == "obtained" ]] && [[ "$Witch_Cauldron" == "missing" ]] && [[ "$Witch_Eyes" == "missing" ]] && [[ "$Witch_Book" == "missing" ]]; then
    echo -e "$Gld Witch Amulet $Std $Gld Witch Heart $Std"
	elif [[ "$Witch_Amulet" == "obtained" ]] && [[ "$Witch_Heart" == "obtained" ]] && [[ "$Witch_Cauldron" == "obtained" ]] && [[ "$Witch_Eyes" == "missing" ]] && [[ "$Witch_Book" == "missing" ]]; then
    echo -e "$Gld Witch Amulet $Std $Gld Witch Heart $Std $Gld Witch Cauldron $Std"
	elif [[ "$Witch_Amulet" == "obtained" ]] && [[ "$Witch_Heart" == "obtained" ]] && [[ "$Witch_Cauldron" == "obtained" ]] && [[ "$Witch_Eyes" == "obtained" ]] && [[ "$Witch_Book" == "missing" ]]; then
    echo -e "$Gld Witch Amulet $Std $Gld Witch Heart $Std $Gld Witch Cauldron $Std $Gld Witch Eyes $Std"
	elif [[ "$Witch_Amulet" == "obtained" ]] && [[ "$Witch_Heart" == "obtained" ]] && [[ "$Witch_Cauldron" == "obtained" ]] && [[ "$Witch_Eyes" == "obtained" ]] && [[ "$Witch_Book" == "obtained" ]]; then
    echo -e "$Gld Witch Amulet $Std $Gld Witch Heart $Std $Gld Witch Cauldron $Std $Gld Witch Eyes $Std $Gld Witch Book $Std"
    fi
}



# Main Loop
while true; do
   if [[ $Player_Health -gt 0 ]]; then
      town_menu
   elif [[ $Player_Health -lt 1 ]]; then
      echo "You have met an untimely end, good luck in your next life."
      read -p "Would you like to try again? (Y/N) " yn
      if [[ "$yn" == "Y" || "$yn" == "y" ]]; then
         ./scarletdaughter.sh
      elif [[ "$yn" == "N" || "$yn" == "n" ]]; then
         echo "Goodbye"
		 gettime
         sleep 2
         exit
      fi
   fi
done