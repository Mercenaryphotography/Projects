#!/bin/bash

clear
Player_Health=100
source ./Sources/config.txt



cat Gametitle.txt | while IFS= read -r line; do echo -e "$line" ; done
# Get character name and weapon
while true ; do

read -p "What is your name Adventurer? (This will set your character name!) " name
 if [[ -n "$name" ]]; then
 break
 else
 echo "You must enter something"
 fi
done

while true; do
cat $menu1
echo
read -p "What is your weapon of choice? " choice
echo " "

	case $choice in
	1) class_weapon=Sword ; break ;;
	2) class_weapon=Staff ; break ;;
	3) class_weapon=Dagger ; break ;;
	*) echo "Invalid choice"
	esac
done
clear

#loads the Playerstate file and all Variables associated with the player themselves
source ./Sources/playerstate.txt
source ./Sources/world.txt

# Explore function, checks for map flags, then loads the appropriate menu and case option loop.
explore() {
    echo "Debugging Explore function: Checking map flags..."
    echo "Plains: $Plains, Caves: $Caves, Mountains: $Mountains, River: $River, Ruins: $Ruins, Lake: $Lake"

    # Check conditions and display the appropriate menu
    if [[ "$Plains" == "1" ]] && [[ "$Caves" == "0" ]] && [[ "$Mountains" == "0" ]] && [[ "$River" == "0" ]] && [[ "$Ruins" == "0" ]] && [[ "$Lake" == "0" ]]; then
        clear
		cat ./menus/menuexl1.txt
        read -p "Choose an action: " action
        case $action in
            1) plains ;;
            2) return ;; # Exit explore function
            *) echo "Invalid choice";;
        esac
    elif [[ "$Plains" == "1" ]] && [[ "$Caves" == "0" ]] && [[ "$Mountains" == "1" ]] && [[ "$River" == "0" ]] && [[ "$Ruins" == "0" ]] && [[ "$Lake" == "0" ]]; then
        clear
		cat ./menus/menuexl2.txt
        read -p "Choose an action: " action
        case $action in
            1) plains ;;
            2) mountains ;;
            3) return ;; # Exit explore function
            *) echo "Invalid choice";;
        esac
    elif [[ "$Plains" == "1" ]] && [[ "$Caves" == "1" ]] && [[ "$Mountains" == "1" ]] && [[ "$River" == "0" ]] && [[ "$Ruins" == "0" ]] && [[ "$Lake" == "0" ]]; then
        cat ./menus/menuexl3.txt
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


# the town menu function
town_menu() {
    cat ./menus/menu.txt
    read -p "Choose an action: " action
    case $action in
        1) clear; explore ;;          # Option 1: Explore the world
        2) clear; Character_info ;;   # Option 2: Show character info
        3) clear; echo "resting.."; sleep 2; Player_Health=$Player_MaxHealth ;;  # Option 3: Rest and heal
        4) clear; echo "testing damage"; Player_Health=0; sleep 2 ;;  # Option 4: Test damage (set health to 0)
        5) clear; echo "goodbye"; sleep 2; exit ;;  # Option 5: Exit the game
        *) clear; echo "Invalid choice" ;;  # Default case for invalid input
    esac
}


# Monster Stats - I want to do an array style system where each zone can pull from 1 of 10 battles, and when it pulls the monster it randomly assigs their stats. 
Amon_Health=20
Amon_Maxhealth=20
Amon_exp=9
Amon_Strength=10
Amon_Defense=8
a2=5
a1=2

Monster_Health=$Amon_Health
Monster_Strength=$Amon_Strength

# Base attack function for player
get_damage_user() {
    damage=$((RANDOM % ( ($max_dmg - $min_dmg + 1) ) + Player_Strength))
	Monster_Health=$((Monster_Health - $damage))
	echo Orc takes $damage damage
	sleep 2
}
# Warriors lifegain attack
lifesteal() {
    lfslcost=$(( 6 * Player_lvl ))
    Player_Health=$(( $Player_Health - $lfslcost ))

    # Ensure damage is an integer and division works with floating-point precision
    damage=$((RANDOM % ( ($max_dmg - $min_dmg) ) + 10 + Player_Strength))

    # Calculate lifesteal damage with floating-point precision
    lfsldmg=$(( $damage /5 ))
    # Apply the damage to monster and health to player
    Monster_Health=$(( $Monster_Health - $damage ))
    Player_Health=$(( $Player_Health + $lfsldmg ))

    echo "You focus into your primal core and unleash a beastial attack dealing $damage damage and gaining $lfsldmg health."
    sleep 2
}

# Monster attack
get_damage_mon() {
    damage=$((RANDOM % ($a2 - $a1 + $Monster_Strength) ))
	Player_Health=$((Player_Health - $damage))
	echo You take $damage damage
	sleep 2
	
}

coward() {
	if [ $run -gt 6 ] ; then 
	echo You get away ; sleep 2
	town_menu 
	else
	echo You are unable to escape
	get_damage_mon ; sleep 2 
	fi
}

# Load Monster Image
monsterimg() {
    count=0
# Cat the ascii art, pipe that into a loop that reads each line and inputs it one line at a time into a variable called line, then we
# Echo -e $line to display the txt files with their ansi codes inbedded
Orc1="./Masset/o1.txt"
Orc2="./Masset/o2.txt"
Orc3="./Masset/o3.txt"
while [ $count -le 2 ] ; do
clear
cat $Orc1 | while IFS= read -r line; do echo -e "$line" ; done
sleep 0.25
clear
cat $Orc2 | while IFS= read -r line; do echo -e "$line" ; done
sleep 0.25
clear
cat $Orc3 | while IFS= read -r line; do echo -e "$line" ; done
sleep 0.25
let count++
done
}

# Battle System
fightfight() {
monsterimg
# I need to implement a system here to pick the monster type so it can call the right monsterimg files
    while true; do
		clear
		run=$((RANDOM % 10 + 1 + $Player_Luck))
       cat ./Masset/o3.txt | while IFS= read -r line; do echo -e "$line" ; done
        # Monster Image and Health always stays on screen during combat
        echo "Player Health: $Player_Health, Monster Health: $Monster_Health"
        cat $menu2
		echo
       #load the action menu and provides the actuall actions.
	   # NEED TO FIX COMBAT TO NOT APPLY DAMAGE IF THE MONSTER DIES BEFORE THEIR DAMAGE ACTION
	   read -p "Choose your action: " action
		case $action in
        1)  get_damage_user ; get_damage_mon ; clear ;;
        2)  if [ $Player_class == "Warrior" ] ; then  lifesteal ; elif [ $Player_class == "Mage" ]; then fireball; elif [ $Player_class == "cutthroat" ]; then backstap; fi ; clear ; get_damage_mon ;;
        #3) clear ; def_up ;clear ; get_damage_mon ;;
        4) clear; coward ;;
        *) clear ; echo "Invalid choice" ;;
    esac
	if [ $Player_Health -le 1 ] ; then
	break
	elif [ $Monster_Health -le 1 ] ; then
	echo "Monster defeated! you gain $Amon_exp" experience points
	Player_exp=$((Player_exp + $Amon_exp))
	sleep 2
    break
	fi
    done
}

# Functions for User
Character_info() {
    echo "$name"
	echo "$Player_class"
	echo -e "$Gld $Player_lvl"
    echo -e "$G HP $Std $Player_Health"
    echo -e "$Gld Level up at 25 $Std $Player_Experience"
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
         Player_Health=$Player_MaxHealth
      elif [[ "$yn" == "N" || "$yn" == "n" ]]; then
         echo "Goodbye"
         sleep 1
         exit
      fi
   fi
done