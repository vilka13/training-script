






















#!/bin/bash

set -eu

print_menu() {
    clear
    echo '* 1 - Zbierz informacje o systemie *'
    echo '* 2 - Wyswietl zapisane informacje *'
    if [[ x"$EUID" == x"0" ]]; then
        echo '* 3 - Utworz grupe *'
        echo '* 4 - Utworz uzytkownika *'
    fi
    echo '* 5 - Pobierz i przetworz plik *'
    echo '* 6 - Wyszukaj frazy w plikach *'
    echo '* 0 - Opuszczenie skryptu *'
    echo
    echo 'Choose option'
}

main() {
    while :
    do
        print_menu
        read -s -n 1 opt
        case $opt in
            1)
            echo
            echo "Wybierasz opcję 1. Naciśnij dowolny klawisz"
            read -s -n 1
            ;;
            2)
            echo
            echo "Wybierasz opcję 2. Naciśnij dowolny klawisz"
            read -s -n 1
            ;;
            3)
            if [[ x"$EUID" == x"0" ]]; then
                echo
                read -p "Wprowadź nową nazwę grupy:" grp
                if [[ -z "$grp" ]]; then
                    echo "Error - pusta nazwa grupy. Naciśnij dowolny klawisz"
                    read -s -n 1
                else
                    if grep -q -E "^$grp:" /etc/group ; then
                        echo "Error-group exists. Naciśnij dowolny klawisz"
                        read -s -n 1
                    else
                        groupadd "$grp"
                        if [[ $? -eq 0 ]]; then
                            echo "Group $grp is wykonywany. Naciśnij dowolny klawisz"
                        else
                            echo "Błąd podczas tworzenia grupy $grp. Naciśnij dowolny klawisz"
                        fi
                        read -s -n 1
                    fi
                fi
            else
                echo
                echo "Zła opcja. Naciśnij dowolny klawisz"
                read -s -n 1
            fi
            ;;
            4)
            if [[ x"$EUID" == x"0" ]]; then
                echo
                read -p "Wprowadź nową nazwę użytkownika: " usr
                read -p "Wprowadź istniejącą nazwę grupy: " grp
                if [[ -z "$usr" ]]; then
                    echo "Błąd-pusta nazwa użytkownika. Naciśnij dowolny klawisz"
                    read -s -n 1
                elif [[ -z "$grp" ]]; then
                    echo "Błąd-pusta nazwa grupy. Naciśnij dowolny klawisz"
                    read -s -n 1
                else
                    if grep -q -E "^$usr:" /etc/passwd ; then
                        echo "Błąd - użytkownik istnieje. Naciśnij dowolny klawisz"
                        read -s -n 1
                    elif ! grep -q -E "^$grp:" /etc/group ; then
                        echo "Error-group nie istnieje. Naciśnij dowolny klawisz"
                        read -s -n 1
                    else
                        useradd -g "$grp" "$usr"
                        if [[ $? -eq 0 ]]; then
                            echo "User $usr is wykonywany. Wprowadź hasło"
                            passwd "$usr"
                        else
                            echo "Błąd podczas tworzenia użytkownika $usr. Naciśnij dowolny klawisz"
                            read -s -n 1
                        fi
                    fi
                fi
            else
                echo
                echo "Zła opcja. Naciśnij dowolny klawisz"
                read -s -n 1
            fi
            ;;
            5)
            echo
            sed  -i '1i **mini projekt systemy operacyjne**' file.txt
            sed -i -e '$scenariusz: Aleksiej Iwanow' file.txt
            clear
            cat file.txt
            echo
            read -s -n 1 -p "Czy chcesz edytować tekst? Jeśli tak, Naciśnij y: " prmt
            if [[ x"$prmt" == x"y" || x"$prmt" == x"Y" ]]; then
                nano file.txt
            fi
            ;;
            6)
            echo
            echo "Wybierasz opcję 6. Naciśnij dowolny klawisz"
            read -s -n 1
            ;;
            0)
            echo Bye
            break
            ;;
            *) 
            echo
            echo "Zła opcja. Naciśnij dowolny klawisz"
            read -s -n 1
            ;;
        esac    
    done

}

main