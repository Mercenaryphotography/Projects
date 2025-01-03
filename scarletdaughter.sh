#!/bin/bash

clear
Player_Health=100

source ./Sources/config.txt
source ./Sources/saveload.txt
source ./Sources/combat.txt

# Game opening loop
cat Gametitle.txt | while IFS= read -r line; do echo -e "$line" ; done
while true; do
    loadgame
    if [ -f save.txt ]; then
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
source ./Sources/monsterstate.txt
source ./Sources/playerstate.txt
# Explore function, checks for map flags, then loads the appropriate menu and case option loop.
explore() {
    echo "Debugging Explore function: Checking map flags..."
    echo "Plains: $Plains, Caves: $Caves, Mountains: $Mountains, River: $River, Ruins: $Ruins, Lake: $Lake"

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
	if [ $run -gt 6 ] ; then 
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
    echo -e "$G HP $Std $Player_Health"
    echo -e "$Gld Exp $Std $Player_exp"
    echo -e "$R Str $Std $Player_Strength"
    echo -e "$B Def $Std $Player_Defense"
	echo -e "$Y luck $Std $Player_Luck"
    if [ "$statusp" = "1" ]; then
        echo -e "$P POISONED $std Antidote to Cure"
    else
        echo "HEALTHY"
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
         sleep 1
         exit
      fi
   fi
done