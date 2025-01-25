#!/bin/bash

# This game was coded by Keagan Leroux during the 2024-2025 CST program at Algonquin College
# It is a labor of love, and just a fun little thing
# This is hosted under (CC) 3.0 so feel free to take and modify, just credit me somewhere nice.
# Special Thanks -
# KPberry and their image-to-ascii tool https://github.com/kpberry/image-to-ascii
# Dom Hastings Image to ANSI tool https://dom111.github.io/image-to-ansi/ 

# GAME VERSION - ALPHA 0.1
clear
Player_Health=100

source ./Sources/config.txt
source ./Sources/saveload.txt
source ./Sources/combat.txt

# Game opening sequence
while true; do
    cat ./menus/newmenu.txt
    echo
    read -p "Choose: " new1  
    case $new1 in
        1) clear ; movie_style_echo " There exists many places between the worlds when things fall and get lost but they do not tumble into eternity.
You find yourself now falling into an endless void your previous life wiped away in an instant
Shapes form and you see flashes of lives CHOOSE A NEW DESTINY suddenly reverberates in your skull.
You feel compelled to make a choice" 0.01 ; break ;;
        2) clear ; break ;;
        *) echo "Invalid choice" ;;
    esac
done

# Game opening loop
cat ./assets/Gametitle.txt | while IFS= read -r line; do echo -e "$line" ; done

while true; do
    if [ -f save.txt ]; then
        loadgame
        explore_menu
        break
    else
        read -p "What is your name, Adventurer? (This will set your character name!) " name
        if [[ -n "$name" ]]; then
            while true; do
                cat $menu1
				echo
                read -p "What is your weapon of choice? " choice
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
    # Check conditions and display the appropriate menu
    if [[ "$Plains" == "1" ]] && [[ "$Caves" == "0" ]] && [[ "$Mountains" == "0" ]] && [[ "$River" == "0" ]] && [[ "$Ruins" == "0" ]] && [[ "$Lake" == "0" ]]; then
        clear
        cat ./menus/menuexl1.txt
        echo
        read -p "Choose an action: " action
        case $action in
            1) clear ; plains ;;
            2) clear ; return ;; 
            3) clear ; explore_menu ;;
            *) echo "Invalid choice" ;;
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
            *) echo "Invalid choice" ;;
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
            *) echo "Invalid choice" ;;
        esac
    elif [[ "$Plains" == "1" ]] && [[ "$Caves" == "1" ]] && [[ "$Mountains" == "1" ]] && [[ "$River" == "1" ]] && [[ "$Ruins" == "0" ]] && [[ "$Lake" == "0" ]]; then
        cat ./menus/menuexl4.txt
        echo
        read -p "Choose an action; " action
        case $action in
            1) clear ; plains ;;
            2) clear ; mountains ;;
            3) clear ; caves ;;
            4) clear ; river ;;
            5) clear ; return ;; 
            *) echo "Invalid choice" ;;
        esac
    elif [[ "$Plains" == "1" ]] && [[ "$Caves" == "1" ]] && [[ "$Mountains" == "1" ]] && [[ "$River" == "1" ]] && [[ "$Ruins" == "0" ]] && [[ "$Lake" == "1" ]]; then
        cat ./menus/menuexl5.txt
        echo
        read -p "Choose an action; " action
        case $action in
            1) clear ; plains ;;
            2) clear ; mountains ;;
            3) clear ; caves ;;
            4) clear ; river ;;
            5) clear ; lake ;;
            6) clear ; return ;; 
            *) echo "Invalid choice" ;;
        esac
    elif [[ "$Plains" == "1" ]] && [[ "$Caves" == "1" ]] && [[ "$Mountains" == "1" ]] && [[ "$River" == "1" ]] && [[ "$Ruins" == "1" ]] && [[ "$Lake" == "1" ]]; then
        cat ./menus/menuexl6.txt
        echo
        read -p "Choose an action; " action
        case $action in
            1) clear ; plains ;;
            2) clear ; mountains ;;
            3) clear ; caves ;;
            4) clear ; river ;;
            5) clear ; lake ;;
            6) clear ; ruins ;;
            7) clear ; return ;; 
            *) echo "Invalid choice" ;;
        esac
    elif [[ "$Plains" == "1" ]] && [[ "$Caves" == "1" ]] && [[ "$Mountains" == "1" ]] && [[ "$River" == "1" ]] && [[ "$Ruins" == "1" ]] && [[ "$Lake" == "1" ]] && [[ "$FinalFight" == "1" ]]; then
        cat ./menus/menuexl7.txt
        echo
        read -p "Choose an action; " action
        case $action in
            1) clear ; plains ;;
            2) clear ; mountains ;;
            3) clear ; caves ;;
            4) clear ; river ;;
            5) clear ; lake ;;
            6) clear ; ruins ;;
            7) clear ; scarletfight ;;
            8) clear ; return ;; 
            *) echo "Invalid choice" ;; 
        esac
    else
        echo "No valid map configuration found!"
    fi
}


coward() {
    running=$((Player_lvl * 6))
    if [ $running -gt $running ] ; then 
        echo "You get away" 
        sleep 2
        Amon_Health=Amon_Maxhealth
        town_menu 
    else
        echo "You are unable to escape"
        get_damage_mon 
        sleep 2 
    fi
}

# Functions for User
Character_info() {
    echo "$name"
    echo "$Player_class"
    echo -e "$Gld $Player_lvl"
    echo -e "Gold $Player_gold"
    echo -e "$G HP $Std $Player_Health"
    echo -e "$Gld Exp $Std $Player_exp Exp required for next level $cy $exp_required $Std"
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
gameover(){
cat ./assets/endscreenframe.txt
echo
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
}
# Main Loop
while true; do
    if [[ $Player_Health -gt 0 ]]; then
        explore_menu
    elif [[ $Player_Health -le 0 ]]; then
        gameover
    fi
	
# End Game
Endgame(){
# Place holder, this should be 3 - 4 pages of text describing the end of the game that then displays an end screen in full colour
echo "You win"
exit
}
done
