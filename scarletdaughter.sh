#!/bin/bash

clear

#Font colour
R='\033[0;31m'   
G='\033[0;32m'   
Y='\033[1;32m'   
B='\033[0;34m' 
Std='\033[0m'

titleurl="https://raw.github.com/Mercenaryphotography/Projects/master/Gametitle.txt"
file_contents=$(wget -qO- "$URL")
echo $File contents


read -p "What is your name Adventurer? " name

#Starting Stats
Player_Health=100
Player_Experience=0
Player_Strength=15
Player_Defense=10

#Monster Pool

# Monster A
Amon_Health=20
Amon_experience=9
Amon_Strenght=10
Amon_Defense=8

# Monster B
Bmon_Health=60
Bmon_experience=20
Bmon_Strength=15
Bmon_Defense=10

# Monster C
Cmon_Health=100
Cmon_experience=100
Cmon_Strength=20
Cmon_Defense=15


#Functions for User

Character_info(){
echo $name
echo ${G} HP ${Std} $Player_Health
echo Level up at 25  $Player_Experience
echo Str $Player_Strength
echo Def $Player_Defense
}

echo $(Character_info)