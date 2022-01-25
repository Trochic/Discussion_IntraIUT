#!/bin/bash
user=$(who | cut -d" " -f1)
echo "Tape 0 pour setup le programme"
echo "Tape 1 pour écrire dans le fichier du destinataire que tu entres"
echo "Tape 2 pour lire ton fichier"
echo "Tape 3 pour fermer ton canal"
echo "Tape 4 pour voir les personnes ouvertes"
echo "Tape 5 pour partager un fichier"
echo "Tape 6 pour afficher menu"
echo "Tape -1 pour quitter le programme (NE FERME PAS LE CANAL FAUT LE FERMER AVANT)"
read choix
while test $choix != -1
do
    if test $choix == "0"
    then
        cd $HOME
        chmod go+rwx $HOME
        if ! test -d $HOME/prog/
        then
            mkdir $HOME/prog
        fi
        chmod go+rwx $HOME/prog/
        if ! test -f $HOME/prog/input
        then
            touch $HOME/prog/input
        fi
        chmod go+rwx $HOME/prog/input
    elif test $choix == "1"
    then
        echo "Ecris destinataire (Si plusieurs écrire *) :"
        read destinataire
        if test $destinataire == "*"
        then
            echo "Saisir message à envoyer à plusieurs destinataires : "
            read -ra mess
            echo "Saisir destinataires (Arrêter saisie avec *) :"
            read destis
            while test $destis != "*"
                do
                if test -w /home/etuinfo/$destis/prog/input
                then
                    date=$(date +%a" "%k:%M)
                    echo "$date|$user : ${ecriture[@]}" >> $HOME/../$destis/prog/input
                else
                    echo "$destis : Canal pas ouvert"
                fi
                done
        else 
            if test -w /home/etuinfo/$destinataire/prog/input
            then
                echo "Commencer saisie :"
                read -ra ecriture
                date=$(date +%a" "%k:%M)
                echo "$date|$user : ${ecriture[@]}" >> $HOME/../$destinataire/prog/input
            else
                echo "Canal pas ouvert"
            fi
        fi
    elif test $choix == "2"
    then
        lastline=$(cat $HOME/prog/input | tail -n1)
        if [ -t 0 ]; 
        then
            SAVED_STTY="`stty --save`"
            stty -echo -icanon -icrnl time 0 min 0
        fi
        keypress=''
        while [ "x$keypress" = "x" ]; 
        do
            newLine=$(cat $HOME/prog/input | tail -n1)
            if [[ $lastline != $newLine ]]
            then
                echo -ne $newLine'\n'
                lastline=$newLine
            fi
            keypress="`cat -v`"
        done
        if [ -t 0 ]; 
        then 
            stty "$SAVED_STTY"; 
        fi
    elif test $choix == "3"
    then
        chmod go-rwx $HOME
        chmod go-rwx $HOME/prog/
        chmod go-rwx $HOME/prog/input
        echo "Canal fermé"
    elif test $choix == "4"
    then
        for d in $HOME/../*
        do
        etudiants=$(echo $d | cut -d'/' -f6)
            if test -x $d
            then
                echo $etudiants
            fi
        done
    elif test $choix == "5"
    then
        echo "Chemin du fichier (Depuis le home directory) :"
        read path
        echo "Destinataire (Si plusieurs destinataires écrire *) :"
        read dest
        if test -f $path
        then
            if test $dest == "*"
            then
                echo "Saisir destinataires (Arrêter saisie avec *) :"
                read dests
                while test $dests != "*"
                    do
                    if test -x $HOME/../$dests/
                    then
                        cp $path $HOME/../$dests/prog/
                    else
                        echo "$dests : Canal pas ouvert"
                    fi
                    done
            else
                if test -x $HOME/../$dest/
                then
                    cp $path $HOME/../$dest/prog/
                else
                    echo "$dest : Canal pas ouvert"
                fi
            fi
        else
            echo "Fichier pas trouvé"
        fi
    elif test $choix == "6"
    then
        echo "Tape 0 pour setup le programme"
        echo "Tape 1 pour envoyer un message"
        echo "Tape 2 pour lire tes messages"
        echo "Tape 3 pour fermer ton canal"
        echo "Tape 4 pour voir les personnes ouvertes"
        echo "Tape 5 pour partager un fichier"
        echo "Tape 6 pour afficher menu"
        echo "Tape -1 pour quitter le programme (NE FERME PAS LE CANAL FAUT LE FERMER AVANT)"
    else
        echo "Va te faire foutre et met un bon chiffre"
    fi
echo "------------------------------------------------"
echo "Nouveau choix :"
read choix
done

