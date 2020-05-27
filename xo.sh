#!/bin/bash

if [ ! -e /tmp/fifo ]; then
    mknod /tmp/fifo p # тут по-любому во второй раз будет ошибка, так что проверим
fi

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
while true
do
if [[ $S == "X" || $S == "x" || $S == "Х" || $S == "х" ]]
        # Ветка для X. O после else и отличается только порядком чтения/записи
        then echo "    Вы играете за X и ходите первыми"
        echo "    Введите координаты в виде \"x y\", чтобы сделать ход"
        echo "    Введите q на своём ходу, чтобы завершить партию"
        while true
        do
            echo -n "    X: "
            read S
            if [[ $S == "q" ]]
                then echo $S > /tmp/fifo
                exit 0
                fi
            X=${S:2:1} # парсим координаты
            Y=${S:0:1}
            while [[ $X > 2 || $X < 0 || $Y > 2 || $Y < 0 || $( echo $S | wc -c ) != 4 || ${S:1:1} != " " ]]
            # проверяет соответствие ввода формату
                do
                tput setf 4 # красный цвет для красоты. И привлечения внимания
                echo "    Введите координаты между 0 и 2"
                tput setf 7 # возврат к белому
                echo -n "    X: "
                read S
                if [[ $( echo $S | wc -c ) != 4 ]]
                    then continue
                    fi
                if [[ $S == "q" ]]
                    then echo $S > /tmp/fifo
                    exit 0
                    fi
                X=${S:2:1} # парсим координаты
                Y=${S:0:1}
                done
            echo $S > /tmp/fifo
            let X=$X*4+12    # преобразование координат, введённых пользователем, в координаты в терминале
            let Y=$Y*2+3
            tput sc
            tput cup $Y $X
            echo X # записываем что сами ввели
            tput rc

            A=$(cat /tmp/fifo) # сохраним это дело в переменную, чтобы нормально парсить
            echo -n "    O: "
            if [[ $A == "q" ]]
                then tput setf 4
                echo "Игрок завершил игру"
                tput setf 7
                rm /tmp/fifo # прибираем созданный ранее файл
                exit 0
                fi
            echo $A
            X=${A:2:1} # парсим координаты
            Y=${A:0:1}
            let X=$X*4+12    # преобразование координат, введённых пользователем, в координаты в терминале
            let Y=$Y*2+3
            tput sc
            tput cup $Y $X
            echo O # записываем что получили
            tput rc
        done
    elif [[ $S == "O" || $S == "o" || $S == "О" || $S == "о" ]]
        then
        # Ветка для O. От X отличается только порядком чтения/записи
        echo "    Вы играете за O и ходите вторыми"
        echo "    Введите координаты в виде \"x y\", чтобы сделать ход"
        echo "    Введите q на своём ходу, чтобы завершить партию"
        while true
        do
            A=$(cat /tmp/fifo) # сохраним это дело в переменную, чтобы нормально парсить
            echo -n "    X: "
            if [[ $A == "q" ]]
                then tput setf 4
                echo "Игрок завершил игру"
                tput setf 7
                rm /tmp/fifo # прибираем созданный ранее файл
                exit 0
                fi
            echo $A
            X=${A:2:1} # парсим координаты
            Y=${A:0:1}
            let X=$X*4+12    # преобразование координат, введённых пользователем, в координаты в терминале
            let Y=$Y*2+3
            tput sc
            tput cup $Y $X
            echo X # записываем что получили
            tput rc

            echo -n "    O: "
            read S
            if [[ $S == "q" ]]
                then echo $S > /tmp/fifo
                exit 0
                fi
            X=${S:2:1} # парсим координаты
            Y=${S:0:1}
            while [[ $X > 2 || $X < 0 || $Y > 2 || $Y < 0 || $( echo $S | wc -c ) != 4 || ${S:1:1} != " " ]]
                do
                tput setf 4
                echo "    Введите координаты между 0 и 2"
                tput setf 7
                echo -n "    X: "
                read S
                if [[ $( echo $S | wc -c ) != 4 ]]
                    then continue
                    fi
                if [[ $S == "q" ]]
                    then echo $S > /tmp/fifo
                    exit 0
                    fi
                X=${S:2:1} # парсим координаты
                Y=${S:0:1}
                done
            echo $S > /tmp/fifo
            let X=$X*4+12    # преобразование координат, введённых пользователем, в координаты в терминале
            let Y=$Y*2+3
            tput sc
            tput cup $Y $X
            echo O # записываем что сами ввели
            tput rc
        done
    else
        tput setf 4
        echo "    Введите X или O, чтобы начать"
        tput setf 7
        echo -n "    "
        read S
        tput cup 10 0
    fi
done
