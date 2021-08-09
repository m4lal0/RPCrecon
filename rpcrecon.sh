#!/bin/bash

# By @m4lal0

# Regular Colors
Black='\033[0;30m'      # Black
Red='\033[0;31m'        # Red
Green='\033[0;32m'      # Green
Yellow='\033[0;33m'     # Yellow
Blue='\033[0;34m'       # Blue
Purple='\033[0;35m'     # Purple
Cyan='\033[0;36m'       # Cyan
White='\033[0;97m'      # White
Blink='\033[5m'         # Blink
Color_Off='\033[0m'     # Text Reset

# Light
LRed='\033[0;91m'       # Ligth Red
LGreen='\033[0;92m'     # Ligth Green
LYellow='\033[0;93m'    # Ligth Yellow
LBlue='\033[0;94m'      # Ligth Blue
LPurple='\033[0;95m'    # Light Purple
LCyan='\033[0;96m'      # Ligth Cyan
LWhite='\033[0;90m'     # Ligth White

# Dark
DGray='\033[2;37m'      # Dark Gray
DRed='\033[2;91m'       # Dark Red
DGreen='\033[2;92m'     # Dark Green
DYellow='\033[2;93m'    # Dark Yellow
DBlue='\033[2;94m'      # Dark Blue
DPurple='\033[2;95m'    # Dark Purple
DCyan='\033[2;96m'      # Dark Cyan
DWhite='\033[2;90m'     # Dark White

# Bold
BBlack='\033[1;30m'     # Bold Black
BRed='\033[1;31m'       # Bold Red
BGreen='\033[1;32m'     # Bold Green
BYellow='\033[1;33m'    # Bold Yellow
BBlue='\033[1;34m'      # Bold Blue
BPurple='\033[1;35m'    # Bold Purple
BCyan='\033[1;36m'      # Bold Cyan
BWhite='\033[1;37m'     # Bold White

# Italics
IBlack='\033[3;30m'     # Italic Black
IGray='\033[3;90m'      # Italic Gray
IRed='\033[3;31m'       # Italic Red
IGreen='\033[3;32m'     # Italic Green
IYellow='\033[3;33m'    # Italic Yellow
IBlue='\033[3;34m'      # Italic Blue
IPurple='\033[3;35m'    # Italic Purple
ICyan='\033[3;36m'      # Italic Cyan
IWhite='\033[3;37m'     # Italic White

# Underline
UBlack='\033[4;30m'     # Underline Black
URed='\033[4;31m'       # Underline Red
UGreen='\033[4;32m'     # Underline Green
UYellow='\033[4;33m'    # Underline Yellow
UBlue='\033[4;34m'      # Underline Blue
UPurple='\033[4;35m'    # Underline Purple
UCyan='\033[4;36m'      # Underline Cyan
UWhite='\033[4;37m'     # Underline White

# Background
On_Black='\033[40m'     # Background Black
On_Red='\033[41m'       # Background Red
On_Green='\033[42m'     # Background Green
On_Yellow='\033[43m'    # Background Yellow
On_Blue='\033[44m'      # Background Blue
On_Purple='\033[45m'    # Background Purple
On_Cyan='\033[46m'      # Background Cyan
On_White='\033[47m'     # Background White

declare -r tmp_file="/dev/shm/tmp_file"
declare -r tmp_file2="/dev/shm/tmp_file2"
declare -r tmp_file3="/dev/shm/tmp_file3"

trap ctrl_c INT

function ctrl_c(){
    echo -e "\n${LBlue}[${BYellow}!${LBlue}]${BYellow} Saliendo...\n"
    rm $tmp_file 2>/dev/null
    tput cnorm
    exit 1
}

function helpPanel(){
    banner
	echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Uso: rpcrecon${Color_Off}"
	echo -e "\n\t${BPurple}-e|--enumeration :${BYellow} Modo de Enumeración${Color_Off}"
	echo -e "\n\t\t${BGreen}Users${Green} (Usuarios del Dominio)${Color_Off}"
	echo -e "\t\t${BGreen}UsersInfo${Green} (Usuarios del Dominio con descripciones)${Color_Off}"
	echo -e "\t\t${BGreen}Admins ${Green}(Usuarios Administradores del Dominio)${Color_Off}"
	echo -e "\t\t${BGreen}Groups ${Green}(Grupos del Dominio)${Color_Off}"
    echo -e "\t\t${BGreen}Domains ${Green}(Listar los Dominios en la red)${Color_Off}"
	echo -e "\t\t${BGreen}All ${Green}(Todos los modos)${Color_Off}"
	echo -e "\n\t${BPurple}-i|--ip :${BYellow} Dirección IP del Host${Color_Off}"
    echo -e "\n\t${BPurple}-u|--username :${BYellow} Usuario (en caso de requerirlo)${Color_Off}"
    echo -e "\n\t${BPurple}-p|--password :${BYellow} Password (en caso de requerirlo)${Color_Off}"
	echo -e "\n\t${BPurple}-h|--help :${BYellow} Mostrar este panel de ayuda${Color_Off}"
	exit 1
}

function banner(){
    echo -e "\n\t${BBlue}╔═══╗╔═══╗╔═══╗${Green}╔═══╗                ${Color_Off}"
    echo -e "\t${BBlue}║╔═╗║║╔═╗║║╔═╗║${Green}║╔═╗║                ${Color_Off}"
    echo -e "\t${BBlue}║╚═╝║║╚═╝║║║ ╚╝${Green}║╚═╝║╔══╗╔══╗╔══╗╔═╗ ${Color_Off}"
    echo -e "\t${BBlue}║╔╗╔╝║╔══╝║║ ╔╗${Green}║╔╗╔╝║╔╗║║╔═╝║╔╗║║╔╗╗${Color_Off}"
    echo -e "\t${BBlue}║║║╚╗║║   ║╚═╝║${Green}║║║╚╗║║═╣║╚═╗║╚╝║║║║║${Color_Off} ${IWhite}By @m4lal0${Color_Off}"
    echo -e "\t${BBlue}╚╝╚═╝╚╝   ╚═══╝${Green}╚╝╚═╝╚══╝╚══╝╚══╝╚╝╚╝${Color_Off}\n"
}

function printTable(){

    local -r delimiter="${1}"
    local -r data="$(removeEmptyLines "${2}")"

    if [[ "${delimiter}" != '' && "$(isEmptyString "${data}")" = 'false' ]]
    then
        local -r numberOfLines="$(wc -l <<< "${data}")"

        if [[ "${numberOfLines}" -gt '0' ]]
        then
            local table=''
            local i=1

            for ((i = 1; i <= "${numberOfLines}"; i = i + 1))
            do
                local line=''
                line="$(sed "${i}q;d" <<< "${data}")"

                local numberOfColumns='0'
                numberOfColumns="$(awk -F "${delimiter}" '{print NF}' <<< "${line}")"

                if [[ "${i}" -eq '1' ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi

                table="${table}\n"

                local j=1

                for ((j = 1; j <= "${numberOfColumns}"; j = j + 1))
                do
                    table="${table}$(printf '#| %s' "$(cut -d "${delimiter}" -f "${j}" <<< "${line}")")"
                done

                table="${table}#|\n"

                if [[ "${i}" -eq '1' ]] || [[ "${numberOfLines}" -gt '1' && "${i}" -eq "${numberOfLines}" ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi
            done

            if [[ "$(isEmptyString "${table}")" = 'false' ]]
            then
                echo -e "${table}" | column -s '#' -t | awk '/^\+/{gsub(" ", "-", $0)}1'
            fi
        fi
    fi
}

function removeEmptyLines(){

    local -r content="${1}"
    echo -e "${content}" | sed '/^\s*$/d'
}

function repeatString(){

    local -r string="${1}"
    local -r numberToRepeat="${2}"

    if [[ "${string}" != '' && "${numberToRepeat}" =~ ^[1-9][0-9]*$ ]]
    then
        local -r result="$(printf "%${numberToRepeat}s")"
        echo -e "${result// /${string}}"
    fi
}

function isEmptyString(){

    local -r string="${1}"

    if [[ "$(trimString "${string}")" = '' ]]
    then
        echo 'true' && return 0
    fi

    echo 'false' && return 1
}

function trimString(){

    local -r string="${1}"
    sed 's,^[[:blank:]]*,,' <<< "${string}" | sed 's,[[:blank:]]*$,,'
}

function extract_Users(){
    if [[ -z $2 || -z $3 ]]; then
        echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Enumerando los Ususarios del Dominio...${Color_Off}\n"
        domain_users=$(rpcclient -U "" $1 -c "enumdomusers" -N | grep -oP '\[.*?\]' | grep -v 0x | tr -d '[]')

        echo "Users" > $tmp_file && for user in $domain_users; do echo "$user" >> $tmp_file; done

        echo -ne "${BGreen}"; printTable ' ' "$(cat $tmp_file)"; echo -ne "${Color_Off}"
        rm $tmp_file 2>/dev/null
    else
        echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Enumerando los Ususarios del Dominio...${Color_Off}\n"
        domain_users=$(rpcclient -U "$2%$3" $1 -c "enumdomusers" | grep -oP '\[.*?\]' | grep -v 0x | tr -d '[]')

        echo "Users" > $tmp_file && for user in $domain_users; do echo "$user" >> $tmp_file; done

        echo -ne "${BGreen}"; printTable ' ' "$(cat $tmp_file)"; echo -ne "${Color_Off}"
        rm $tmp_file 2>/dev/null
    fi
}

function extract_Users_Info(){
    if [[ -z $2 || -z $3 ]]; then
        extract_Users $1 > /dev/null 2>&1

        echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Listando los Usuarios del Dominio con su descripción...${Color_Off}\n"

        for user in $domain_users; do
            rpcclient -U "" $1 -c "queryuser $user" -N | grep -E 'User Name|Description' | cut -d ':' -f 2-100 | sed 's/\t//' | tr '\n' ',' | sed 's/.$//' >> $tmp_file
            echo -e '\n' >> $tmp_file
        done

        echo "User,Description" > $tmp_file2

        cat $tmp_file | sed '/^\s*$/d' | while read user_representation; do
            if [ "$(echo $user_representation | awk '{print $2}' FS=',')" ]; then
                echo "$(echo $user_representation | awk '{print $1}' FS=','),$(echo $user_representation | awk '{print $2}' FS=',')" >> $tmp_file2
            fi
        done

        rm $tmp_file; mv $tmp_file2 $tmp_file
        sleep 1; echo -ne "${BGreen}"; printTable ',' "$(cat $tmp_file)"; echo -ne "${Color_Off}"
        rm $tmp_file 2>/dev/null
    else
        extract_Users $1 $2 $3 > /dev/null 2>&1

        echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Listando los Usuarios del Dominio con su descripción...${Color_Off}\n"

        for user in $domain_users; do
            rpcclient -U "$2%$3" $1 -c "queryuser $user" | grep -E 'User Name|Description' | cut -d ':' -f 2-100 | sed 's/\t//' | tr '\n' ',' | sed 's/.$//' >> $tmp_file
            echo -e '\n' >> $tmp_file
        done

        echo "User,Description" > $tmp_file2

        cat $tmp_file | sed '/^\s*$/d' | while read user_representation; do
            if [ "$(echo $user_representation | awk '{print $2}' FS=',')" ]; then
                echo "$(echo $user_representation | awk '{print $1}' FS=','),$(echo $user_representation | awk '{print $2}' FS=',')" >> $tmp_file2
            fi
        done

        rm $tmp_file; mv $tmp_file2 $tmp_file
        sleep 1; echo -ne "${BGreen}"; printTable ',' "$(cat $tmp_file)"; echo -ne "${Color_Off}"
        rm $tmp_file 2>/dev/null
    fi
}

function extract_Admins(){
    if [[ -z $2 || -z $3 ]]; then
        echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Enumerando los Usuarios Administradores del Dominio...${Color_Off}\n"
        rid_dagroup=$(rpcclient -U "" $1 -c "enumdomgroups" -N | grep -E "Domain Admins|Admins. del dominio" | awk 'NF{print $NF}' | grep -oP '\[.*?\]' | tr -d '[]')
        rid_dausers=$(rpcclient -U "" $1 -c "querygroupmem $rid_dagroup" -N | awk '{print $1}' | grep -oP '\[.*?\]' | tr -d '[]')

        echo "DomainAdminUsers" > $tmp_file; for da_user_rid in $rid_dausers; do
            rpcclient -U "" $1 -c "queryuser $da_user_rid" -N | grep 'User Name'| awk 'NF{print $NF}' >> $tmp_file
        done

        echo -ne "${BGreen}"; printTable ' ' "$(cat $tmp_file)"; echo -ne "${Color_Off}"
        rm $tmp_file 2>/dev/null
    else
        echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Enumerando los Usuarios Administradores del Dominio...${Color_Off}\n"
        rid_dagroup=$(rpcclient -U "$2%$3" $1 -c "enumdomgroups" | grep -E "Domain Admins|Admins. del dominio" | awk 'NF{print $NF}' | grep -oP '\[.*?\]' | tr -d '[]')
        rid_dausers=$(rpcclient -U "$2%$3" $1 -c "querygroupmem $rid_dagroup" | awk '{print $1}' | grep -oP '\[.*?\]' | tr -d '[]')

        echo "DomainAdminUsers" > $tmp_file; for da_user_rid in $rid_dausers; do
            rpcclient -U "$2%$3" $1 -c "queryuser $da_user_rid" | grep 'User Name'| awk 'NF{print $NF}' >> $tmp_file
        done

        echo -ne "${BGreen}"; printTable ' ' "$(cat $tmp_file)"; echo -ne "${Color_Off}"
        rm $tmp_file 2>/dev/null
    fi
}

function extract_Groups(){
    if [[ -z $2 || -z $3 ]]; then
        echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Enumerando los Grupos del Dominio...${Color_Off}\n"

        rpcclient -U "" $1 -c "enumdomgroups" -N | grep -oP '\[.*?\]' | grep "0x" | tr -d '[]' >> $tmp_file

        echo "DomainGroup,Description" > $tmp_file2
        cat $tmp_file | while read rid_domain_groups; do
            rpcclient -U "" $1 -c "querygroup $rid_domain_groups" -N | grep -E 'Group Name|Description' | sed 's/\t//' > $tmp_file3
            group_name=$(cat $tmp_file3 | grep "Group Name" | awk '{print $2}' FS=":")
            group_description=$(cat $tmp_file3 | grep "Description" | awk '{print $2}' FS=":")

            echo "$(echo $group_name),$(echo $group_description)" >> $tmp_file2
        done

        rm $tmp_file $tmp_file3 2>/dev/null && mv $tmp_file2 $tmp_file
        echo -ne "${BGreen}"; printTable ',' "$(cat $tmp_file)"; echo -ne "${Color_Off}"
        rm $tmp_file 2>/dev/null
    else
        echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Enumerando los Grupos del Dominio...${Color_Off}\n"

        rpcclient -U "$2%$3" $1 -c "enumdomgroups" | grep -oP '\[.*?\]' | grep "0x" | tr -d '[]' >> $tmp_file

        echo "DomainGroup,Description" > $tmp_file2
        cat $tmp_file | while read rid_domain_groups; do
            rpcclient -U "$2%$3" $1 -c "querygroup $rid_domain_groups" | grep -E 'Group Name|Description' | sed 's/\t//' > $tmp_file3
            group_name=$(cat $tmp_file3 | grep "Group Name" | awk '{print $2}' FS=":")
            group_description=$(cat $tmp_file3 | grep "Description" | awk '{print $2}' FS=":")

            echo "$(echo $group_name),$(echo $group_description)" >> $tmp_file2
        done

        rm $tmp_file $tmp_file3 2>/dev/null && mv $tmp_file2 $tmp_file
        echo -ne "${BGreen}"; printTable ',' "$(cat $tmp_file)"; echo -ne "${Color_Off}"
        rm $tmp_file 2>/dev/null
    fi
}

function extract_Domains(){
    if [[ -z $2 || -z $3 ]]; then
        echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Enumerando los Dominios...${Color_Off}\n"
        domains=$(rpcclient -U "" $1 -c "enumdomains" -N | grep -oP '\[.*?\]' | grep -v 0x | tr -d '[]')

        echo "Domains" > $tmp_file && for domain in $domains; do echo "$domain" >> $tmp_file; done

        echo -ne "${BGreen}"; printTable ' ' "$(cat $tmp_file)"; echo -ne "${Color_Off}"
        rm $tmp_file 2>/dev/null
    else
        echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Enumerando los Dominios...${Color_Off}\n"
        domains=$(rpcclient -U "$2%$3" $1 -c "enumdomains" | grep -oP '\[.*?\]' | grep -v 0x | tr -d '[]')

        echo "Domains" > $tmp_file && for domain in $domains; do echo "$domain" >> $tmp_file; done

        echo -ne "${BGreen}"; printTable ' ' "$(cat $tmp_file)"; echo -ne "${Color_Off}"
        rm $tmp_file 2>/dev/null
    fi
}

function extract_All(){
    if [[ -z $2 || -z $3 ]]; then
        extract_Users $1
        extract_Users_Info $1
        extract_Admins $1
        extract_Groups $1
        extract_Domains $1
    else
        extract_Users $1 $2 $3
        extract_Users_Info $1 $2 $3
        extract_Admins $1 $2 $3
        extract_Groups $1 $2 $3
        extract_Domains $1 $2 $3
    fi
}

function enumeration(){
    tput civis; nmap -p139 --open -T5 -v -n $HOST_IP | grep open > /dev/null 2>&1 && port_status=$?
    if [[ -z $USER || -z $PASSWORD ]]; then
        rpcclient -U "" $HOST_IP -c "enumdomusers" -N > /dev/null 2>&1
        if [ "$(echo $?)" == "0" ]; then
            if [ "$port_status" == "0" ]; then
                case $ENUM_MODE in
                    Users)
                        extract_Users $HOST_IP
                        ;;
                    UsersInfo)
                        extract_Users_Info $HOST_IP
                        ;;
                    Admins)
                        extract_Admins $HOST_IP
                        ;;
                    Groups)
                        extract_Groups $HOST_IP
                        ;;
                    Domains)
                        extract_Domains $HOST_IP
                        ;;
                    All)
                        extract_All $HOST_IP
                        ;;
                    *)
                        echo -e "\n${LBlue}[${BRed}✘${LBlue}]${BRed} Error: Opción no válida${Color_Off}"
                        helpPanel
                        exit 1
                        ;;
                esac
            else
                echo -e "\n${IYellow}El puerto 139 parece estar cerrado en $HOST_IP${Color_Off}"
                tput cnorm; exit 0
            fi
        else
            echo -e "\n${LBlue}[${BRed}✘${LBlue}]${BRed} Error: Acceso denegado${Color_Off}"
            tput cnorm; exit 0
        fi
    else
        rpcclient -U "$USER%$PASSWORD" $HOST_IP -c "enumdomusers" > /dev/null 2>&1
        if [ "$(echo $?)" == "0" ]; then
            if [ "$port_status" == "0" ]; then
                case $ENUM_MODE in
                    Users)
                        extract_Users $HOST_IP $USER $PASSWORD
                        ;;
                    UsersInfo)
                        extract_Users_Info $HOST_IP $USER $PASSWORD
                        ;;
                    Admins)
                        extract_Admins $HOST_IP $USER $PASSWORD
                        ;;
                    Groups)
                        extract_Groups $HOST_IP $USER $PASSWORD
                        ;;
                    Domains)
                        extract_Domains $HOST_IP $USER $PASSWORD
                        ;;
                    All)
                        extract_All $HOST_IP $USER $PASSWORD
                        ;;
                    *)
                        echo -e "\n${LBlue}[${BRed}✘${LBlue}]${BRed} Error: Opción no válida${Color_Off}"
                        helpPanel
                        exit 1
                        ;;
                esac
            else
                echo -e "\n${IYellow}El puerto 139 parece estar cerrado en $HOST_IP${Color_Off}"
                tput cnorm; exit 0
            fi
        else
            echo -e "\n${LBlue}[${BRed}✘${LBlue}]${BRed} Error: Acceso denegado${Color_Off}"
            tput cnorm; exit 0
        fi
    fi
}

arg=""
for arg; do
	delim=""
	case $arg in
		--enumeration)	args="${args}-e";;
        --ip)	        args="${args}-i";;
        --username)	    args="${args}-u";;
        --password)	    args="${args}-p";;
		--help)	        args="${args}-h";;
		*) [[ "${arg:0:1}" == "-" ]] || delim="\""
        args="${args}${delim}${arg}${delim} ";;
	esac
done

eval set -- $args

if [[ "$(echo $UID)" == "0" ]]; then
    declare -i parameter_counter=0; while getopts ":e:i:u:p:h:" arg; do
        case $arg in
            e) ENUM_MODE=$OPTARG; let parameter_counter+=1;;
            i) HOST_IP=$OPTARG; let parameter_counter+=1;;
            u) USER=$OPTARG;;
            p) PASSWORD=$OPTARG;;
            h) helpPanel;;
        esac
    done

    if [[ $parameter_counter -ne 2 ]]; then
        helpPanel
    else
        banner
        enumeration
        tput cnorm
    fi
else
    echo -e "\n${LBlue}[${BYellow}!${BBlue}]${BYellow} Ejecute el script como r00t!${Color_Off}\n"
fi