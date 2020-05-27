#!/bin/bash

mknod /tmp/fifo p

clear
echo
echo "       v    0   1   2  "
echo "          ╔═══╦═══╦═══╗"  # номер строки | столбцов -- для вывода
echo "       0  ║   ║   ║   ║"  #            3 | 12 16 20
echo "          ╠═══╬═══╬═══╣"
echo "       1  ║   ║   ║   ║"  #            5 | 12 16 20
echo "          ╠═══╬═══╬═══╣"
echo "       2  ║   ║   ║   ║"  #            7 | 12 16 20
echo "          ╚═══╩═══╩═══╝"

tput cup 10 0 # ставим курсор сюда, чтобы не наслаивалось ничего
echo "    Введите X или O, чтобы начать"
echo -n "    "
read S
tput cup 10 0
if [[ $S == "X" || $S == "x" || $S == "Х" || $S == "х" ]]
        then echo "    Вы играете за X и ходите первыми"
        echo "    Введите q на своём ходу, чтобы завершить партию"
        while true
        do
            echo -n "    X: "
            read S
            echo $S > /tmp/fifo
            if [[ $S == "q" ]]
                then break
                fi
            X=$(echo -n $S | tail -c 1)
            let X*=4
            let X+=12
            Y=$(echo $S | head -c 1)
            let Y*=2
            let Y+=3
            tput sc
            tput cup $Y $X
            echo X # записываем что сами ввели
            tput rc

            A=$(cat /tmp/fifo) # сохраним это дело в переменную, чтобы нормально парсить
            echo -n "    O: "
            if [[ $A == "q" ]]
                then echo "Игрок завершил игру"
                rm /tmp/fifo
                break
                fi
            echo $A
            X=$(echo -n $A | tail -c 1)
            let X*=4
            let X+=12
            Y=$(echo $A | head -c 1)
            let Y*=2
            let Y+=3
            tput sc
            tput cup $Y $X
            echo O # записываем что получили
            tput rc
        done
    else
        echo "    Вы играете за O и ходите вторыми"
        echo "    Введите q на своём ходу, чтобы завершить партию"
        while true
        do
            A=$(cat /tmp/fifo) # сохраним это дело в переменную, чтобы нормально парсить
            echo -n "    X: "
            if [[ $A == "q" ]]
                then echo "Игрок завершил игру"
                rm /tmp/fifo
                break
                fi
            echo $A
            X=$(echo -n $A | tail -c 1)
            let X*=4
            let X+=12
            Y=$(echo $A | head -c 1)
            let Y*=2
            let Y+=3
            tput sc
            tput cup $Y $X
            echo X # записываем что получили
            tput rc

            echo -n "    O: "
            read S
            echo $S > /tmp/fifo
            if [[ $S == "q" ]]
                then break
                fi
            X=$(echo -n $S | tail -c 1)
            let X*=4
            let X+=12
            Y=$(echo $S | head -c 1)
            let Y*=2
            let Y+=3
            tput sc
            tput cup $Y $X
            echo O # записываем что сами ввели
            tput rc
        done
    fi