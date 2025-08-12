#!/usr/bin/env bash

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
VERSION=2.0.0

trap ctrl_c INT

function ctrl_c(){
    # Manejar la interrupción del script con Ctrl+C
    echo -e "\n${LBlue}[${BYellow}!${LBlue}]${BYellow} Saliendo...${Color_Off}\n"
    rm $tmp_file 2>/dev/null
    tput cnorm
    exit 1
}

function helpPanel(){
    # Mostrar el panel de ayuda con opciones y ejemplos de uso
    echo -e "\n${BWhite}uso: rpcrecon [-h] -e MODE -i IP [-u USERNAME] [-p PASSWORD] [-o {txt,json,grep,html,all}] [-n] [-v] [--update]${Color_Off}\n"

    echo -e "${BPurple}Opciones:${Color_Off}"
    echo -e "  ${BPurple}-e, --enumeration${Color_Off}  ${IWhite}Modo de enumeración:${Color_Off} "
    echo -e "                     ${BYellow}Users${Color_Off}        ${IWhite}Listar usuarios del dominio${Color_Off}"
    echo -e "                     ${BYellow}UsersInfo${Color_Off}    ${IWhite}Usuarios con descripciones${Color_Off}"
    echo -e "                     ${BYellow}Admins${Color_Off}       ${IWhite}Usuarios administradores${Color_Off}"
    echo -e "                     ${BYellow}Groups${Color_Off}       ${IWhite}Grupos del dominio${Color_Off}"
    echo -e "                     ${BYellow}GroupsMember${Color_Off} ${IWhite}Grupos del dominio y sus usuarios${Color_Off}"
    echo -e "                     ${BYellow}MembersGroup${Color_Off} ${IWhite}Usuarios y sus grupos de dominio${Color_Off}"
    echo -e "                     ${BYellow}Domains${Color_Off}      ${IWhite}Listar dominios en la red${Color_Off}"
    echo -e "                     ${BYellow}RIDCycling${Color_Off}   ${IWhite}Enumeración de usuarios mediante RIDs${Color_Off}"
    echo -e "                     ${BYellow}All${Color_Off}          ${IWhite}Todos los modos${Color_Off}"
    echo -e "  ${BPurple}-i, --ip${Color_Off}           ${IWhite}Dirección IP o nombre del Host${Color_Off}"
    echo -e "  ${BPurple}-u, --username${Color_Off}     ${IWhite}Nombre de usuario (si es requerido)${Color_Off}"
    echo -e "  ${BPurple}-p, --password${Color_Off}     ${IWhite}Contraseña del usuario (si es requerido)${Color_Off}"
    echo -e "  ${BPurple}-o, --output${Color_Off}       ${IWhite}Formato de salida {txt,json,grep,html,all}${Color_Off}"
    echo -e "  ${BPurple}-n, --no-print${Color_Off}     ${IWhite}No mostrar resultados en pantalla (requiere -o)${Color_Off}"
    echo -e "  ${BPurple}-v, --version${Color_Off}      ${IWhite}Mostrar la versión instalada${Color_Off}"
    echo -e "  ${BPurple}--update${Color_Off}           ${IWhite}Actualizar la aplicación${Color_Off}"
    echo -e "  ${BPurple}-h, --help${Color_Off}         ${IWhite}Mostrar este panel de ayuda${Color_Off}\n"

    echo -e "${BBlue}[${BWhite}Ejemplos de uso${BBlue}]${Color_Off}\n"
    echo -e "${BGreen}Enumerar usuarios con Null Session a una IP:${Color_Off}"
    echo -e "   rpcrecon -e Users -i 192.168.1.10\n"
    echo -e "${BGreen}Guardar usuarios con descripciones en modo Grepable sin mostrar en pantalla:${Color_Off}"
    echo -e "   rpcrecon -e UsersInfo -i 192.168.1.10 -o grep -n\n"
    echo -e "${BGreen}Enumerar administradores con credenciales y salida en JSON:${Color_Off}"
    echo -e "   rpcrecon -e Admins -i 192.168.1.10 -u usuario -p password -o json\n"
    echo -e "${BGreen}Enumerar todos los modos y guardar en HTML:${Color_Off}"
    echo -e "   rpcrecon -e All -i 192.168.1.10 -o html\n"
    echo -e "${BGreen}Actualizar la herramienta:${Color_Off}"
    echo -e "   rpcrecon --update\n"

    tput cnorm; exit 1
}

function banner(){
    # Mostrar el banner estilizado de la herramienta
    echo -e "\n\t${BBlue}╔═══╗╔═══╗╔═══╗${Green}╔═══╗                ${Color_Off}"
    echo -e "\t${BBlue}║╔═╗║║╔═╗║║╔═╗║${Green}║╔═╗║                ${Color_Off}"
    echo -e "\t${BBlue}║╚═╝║║╚═╝║║║ ╚╝${Green}║╚═╝║╔══╗╔══╗╔══╗╔═╗ ${Color_Off}"
    echo -e "\t${BBlue}║╔╗╔╝║╔══╝║║ ╔╗${Green}║╔╗╔╝║╔╗║║╔═╝║╔╗║║╔╗╗${Color_Off}"
    echo -e "\t${BBlue}║║║╚╗║║   ║╚═╝║${Green}║║║╚╗║║═╣║╚═╗║╚╝║║║║║${Color_Off} ${IWhite}By @m4lal0${Color_Off}"
    echo -e "\t${BBlue}╚╝╚═╝╚╝   ╚═══╝${Green}╚╝╚═╝╚══╝╚══╝╚══╝╚╝╚╝${Color_Off}\n"
}

function printVersion(){
    # Mostrar la versión actual de la herramienta con el banner
    banner
    echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} RPCrecon - Herramienta de enumeración RPC${Color_Off}"
    echo -e "\n${White}Versión instalada: ${BWhite}$VERSION${Color_Off}\n"
    tput cnorm; exit 1
}

function checkUpdate(){
    # Obtener la versión de GitHub
    GIT_VERSION=$(curl --silent https://raw.githubusercontent.com/m4lal0/RPCrecon/refs/heads/main/rpcrecon.sh | grep 'VERSION=' | head -n 1 | cut -d"=" -f 2)
    
    # Verificar si se obtuvo la versión de GitHub
    if [[ -z "$GIT_VERSION" ]]; then
        echo -e "\n${LBlue}[${BRed}✘${LBlue}]${Color_Off} ${On_Red}${BWhite}Error:${Color_Off} ${BRed}No se pudo obtener la versión de GitHub. Verifica tu conexión.${Color_Off}\n"
        tput cnorm; exit 1
    fi
    
    # Comparar versiones usando sort -V
    if [[ "$(printf '%s\n%s' "$VERSION" "$GIT_VERSION" | sort -V | head -n 1)" == "$GIT_VERSION" ]]; then
        echo -e "${BGreen}[✔]${Color_Off} ${BGreen}La versión actual ($VERSION) es la más reciente.${Color_Off}\n"
        tput cnorm; exit 0
    else
        echo -e "${Yellow}[*]${Color_Off} ${IWhite}Actualización disponible${Color_Off}"
        echo -e "${Yellow}[*]${Color_Off} ${IWhite}Actualización de la versión${Color_Off} ${BWhite}$VERSION${Color_Off} ${IWhite}a la${Color_Off} ${BWhite}$GIT_VERSION${Color_Off}"
        update="1"
    fi
}

function installUpdate(){
    # Descargar e instalar la actualización desde GitHub
    echo -en "${Yellow}[*]${Color_Off} ${IWhite}Instalando actualización...${Color_Off}"
    # Descargar a un archivo temporal
    wget -q https://raw.githubusercontent.com/m4lal0/RPCrecon/main/rpcrecon.sh -O /tmp/rpcrecon.sh
    if [ $? -eq 0 ]; then
        chmod +x /tmp/rpcrecon.sh
        mv /tmp/rpcrecon.sh /usr/local/bin/rpcrecon
        if [ $? -eq 0 ]; then
            echo -e "${BGreen}[ OK ]${Color_Off}"
            echo -e "\n${BGreen}[✔]${Color_Off} ${IGreen}Versión actualizada a${Color_Off} ${BWhite}$GIT_VERSION${Color_Off}\n"
            tput cnorm; exit 0
        else
            echo -e "${BRed}[ FAIL ]${Color_Off}"
            echo -e "${BRed}Error al mover el archivo. Verifica permisos.${Color_Off}"
            tput cnorm; exit 1
        fi
    else
        echo -e "${BRed}[ FAIL ]${Color_Off}"
        echo -e "${BRed}Error al descargar la actualización.${Color_Off}"
        tput cnorm; exit 1
    fi
}

function update(){
    # Gestionar el proceso de actualización de la herramienta
    banner
    echo -e "${BBlue}[+]${Color_Off} ${BWhite}rpcrecon Versión $VERSION${Color_Off}"
    echo -e "${BBlue}[+]${Color_Off} ${BWhite}Verificando actualización de rpcrecon${Color_Off}"
    checkUpdate
    echo -e "\t${BWhite}$VERSION ${IWhite}Versión Instalada${Color_Off}"
    echo -e "\t${BWhite}$GIT_VERSION ${IWhite}Versión en Git${Color_Off}\n"
    if [ "$update" != "1" ]; then
        tput cnorm; exit 0
    else
        echo -e "${BBlue}[+]${Color_Off} ${BWhite}Necesita actualizar!${Color_Off}"
        tput cnorm
        echo -en "${BPurple}[?]${Color_Off} ${BCyan}¿Quiere actualizar? (${BGreen}Y${BCyan}/${BRed}n${BCyan}):${Color_Off} "
        read CONDITION
        tput civis
        case "$CONDITION" in
            n|N)
                echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BRed}No se actualizó, se queda en la versión ${BWhite}$VERSION${Color_Off}\n"
                tput cnorm; exit 0
                ;;
            *)
                installUpdate
                ;;
        esac
    fi
}

function printTable(){
    # Generar una tabla formateada a partir de datos con un delimitador
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
    # Eliminar líneas vacías de un contenido dado
    local -r content="${1}"
    echo -e "${content}" | sed '/^\s*$/d'
}

function repeatString(){
    # Repetir un string un número específico de veces
    local -r string="${1}"
    local -r numberToRepeat="${2}"

    if [[ "${string}" != '' && "${numberToRepeat}" =~ ^[1-9][0-9]*$ ]]
    then
        local -r result="$(printf "%${numberToRepeat}s")"
        echo -e "${result// /${string}}"
    fi
}

function isEmptyString(){
    # Verificar si un string está vacío después de eliminar espacios
    local -r string="${1}"

    if [[ "$(trimString "${string}")" = '' ]]
    then
        echo 'true' && return 0
    fi

    echo 'false' && return 1
}

function trimString(){
    # Eliminar espacios en blanco al inicio y final de un string
    local -r string="${1}"
    sed 's,^[[:blank:]]*,,' <<< "${string}" | sed 's,[[:blank:]]*$,,'
}

function csv_to_json(){
    # Convertir un archivo CSV a formato JSON
    local csv_file=$1
    local json_file=$2

    echo "[" > "$json_file"

    # Leer cabecera, usando ';' como delimitador
    IFS=';' read -r -a keys < "$csv_file"

    first=1

    tail -n +2 "$csv_file" | while IFS=';' read -r -a values; do
        if [ $first -eq 0 ]; then
            echo "," >> "$json_file"
        fi
        first=0

        echo -n "  {" >> "$json_file"
        for i in "${!keys[@]}"; do
            # Escapamos comillas dobles dentro del valor, si las hubiera
            value=$(echo "${values[$i]}" | sed 's/"/\\"/g')
            echo -n "\"${keys[$i]}\": \"$value\"" >> "$json_file"
            if [ "$i" -lt "$(( ${#keys[@]} - 1 ))" ]; then
                echo -n ", " >> "$json_file"
            fi
        done
        echo -n "}" >> "$json_file"
    done

    echo "]" >> "$json_file"
}

function csv_to_grep(){
    # Convertir un archivo CSV a formato grepable
    local csv_file=$1
    local grep_file=$2

    # Leer cabecera, asumiendo separador ';'
    IFS=';' read -r -a keys < "$csv_file"

    # Leer las líneas restantes
    tail -n +2 "$csv_file" | while IFS=';' read -r -a values; do
        line=""
        for i in "${!keys[@]}"; do
            line+="${keys[$i]}: ${values[$i]} "
        done
        echo "$line" >> "$grep_file"
    done
}

function csv_to_html(){
    # Convertir un archivo CSV a formato HTML con estilos
    local csv_file=$1
    local html_file=$2
    local current_time_str=$(date)

    # Generar el inicio del archivo HTML
    echo '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">' > $html_file
    echo '<html xmlns:fo="http://www.w3.org/1999/XSL/Format">' >> $html_file
    echo '<head>' >> $html_file
    echo '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">' >> $html_file
    echo '<style type="text/css">' >> $html_file
    echo '
/* stylesheet print */
@media print
{
  #menu { display:none; }
  body { font-family: Verdana, Helvetica, sans-serif; }
  h1 { font-size: 13pt; font-weight:bold; margin:4pt 0pt 0pt 0pt; padding:0; }
  h2 { font-size: 12pt; font-weight:bold; margin:3pt 0pt 0pt 0pt; padding:0; }
  h3, a:link, a:visited { font-size: 9pt; font-weight:bold; margin:1pt 0pt 0pt 20pt; padding:0; text-decoration: none; color: #000000; }
  p,ul { font-size: 9pt; margin:1pt 0pt 8pt 40pt; padding:0; text-align:left; }
  li { font-size: 9pt; margin:0; padding:0; text-align:left; }
  table { margin:1pt 0pt 8pt 40pt; border:0px; width:90%; }
  td { border:0px; border-top:1px solid black; font-size: 9pt; }
  .head td { border:0px; font-weight:bold; font-size: 9pt; }
  .noprint { display: none; }
}

/* stylesheet screen */
@media screen
{
  body { font-family: Verdana, Helvetica, sans-serif; margin: 0px; background-color: #FFFFFF; color: #000000; text-align: center; }
  #container { text-align:left; margin: 10px auto; width: 90%; }
  h1 { font-family: Verdana, Helvetica, sans-serif; font-weight:bold; font-size: 14pt; color: #FFFFFF; background-color:#2A0D45; margin:10px 0px 0px 0px; padding:5px 4px 5px 4px; width: 100%; border:1px solid black; text-align: left; }                                                                                                                                                               
  h2 { font-family: Verdana, Helvetica, sans-serif; font-weight:bold; font-size: 11pt; color: #000000; margin:30px 0px 0px 0px; padding:4px; width: 100%; background-color:#F0F8FF; text-align: left; }                                                                                                                                                                                                   
  h2.green { color: #000000; background-color:#CCFFCC; border-color:#006400; }
  h3 { font-family: Verdana, Helvetica, sans-serif; font-weight:bold; font-size: 10pt; color:#000000; background-color: #FFFFFF; width: 75%; text-align: left; }
  p { font-family: Verdana, Helvetica, sans-serif; font-size: 8pt; color:#000000; background-color: #FFFFFF; width: 75%; text-align: left; }
  p i { font-family: Verdana, Helvetica, sans-serif; font-size: 8pt; color:#000000; background-color: #CCCCCC; }
  ul { font-family: Verdana, Helvetica, sans-serif; font-size: 8pt; color:#000000; background-color: #FFFFFF; width: 75%; text-align: left; }
  a { font-family: Verdana, Helvetica, sans-serif; text-decoration: none; font-size: 8pt; color:#000000; font-weight:bold; background-color: #FFFFFF; }
  li a { font-family: Verdana, Helvetica, sans-serif; text-decoration: none; font-size: 10pt; color:#000000; font-weight:bold; background-color: #FFFFFF; }
  a:hover { text-decoration: underline; }
  a.up { color:#006400; }
  table { width: 80%; border:0px; color: #000000; background-color: #000000; margin:10px; }
  tr { vertical-align:top; font-family: Verdana, Helvetica, sans-serif; font-size: 8pt; color:#000000; background-color: #FFFFFF; }
  tr.head { background-color: #E1E1E1; color: #000000; font-weight:bold; }
  tr.open { background-color: #CCFFCC; color: #000000; }
  td { padding:2px; }
  #menu li { display: inline; margin: 0; padding: 0; list-style-type: none; }
  .up { color: #000000; background-color:#CCFFCC; }
  .print_only { display: none; }
  .hidden { display: none; }
  .unhidden { display: block; }
}
' >> $html_file
    echo '</style>' >> $html_file
    echo "<title>RPCrecon Scan Report - Scanned at $current_time_str</title>" >> $html_file
    echo '</head>' >> $html_file
    echo '<body>' >> $html_file
    echo '<div id="container">' >> $html_file
    echo "<h1>RPCrecon Scan Report - Scanned at $current_time_str</h1>" >> $html_file

    # Resumen de la enumeración
    echo '<h2>Scan Summary</h2>' >> $html_file
    echo "<p>RPCrecon was initiated at $current_time_str with these arguments:<br><i>$(echo $0 $@)</i><br></p>" >> $html_file
    echo "<p>Enumeration Mode: <b>$ENUM_MODE</b><br></p>" >> $html_file
    echo "<p>Records: $RECORDS</p>" >> $html_file

    # Información del host
    echo "<h2 class=\"up\">$HOST_IP<span class=\"print_only\">(online)</span></h2>" >> $html_file
    echo '<div id="hostblock" class="unhidden">' >> $html_file
    echo '<h3>Address</h3>' >> $html_file
    echo "<ul><li>$HOST_IP (ipv4)</li></ul>" >> $html_file

    # Tabla de resultados
    echo '<h3>Results</h3>' >> $html_file
    echo '<table cellspacing="1">' >> $html_file

    # Leer la primera línea para obtener el encabezado
    read -r header < $csv_file

    if echo "$header" | grep -q ';'; then
        # Múltiples columnas
        delimiter=';'
        IFS="$delimiter" read -r -a keys <<< "$header"
        echo '<tr class="head">' >> $html_file
        for key in "${keys[@]}"; do
            echo "<td>$key</td>" >> $html_file
        done
        echo '</tr>' >> $html_file

        tail -n +2 $csv_file | while IFS="$delimiter" read -r -a values; do
            echo '<tr class="open">' >> $html_file
            for i in "${!values[@]}"; do
                value="${values[$i]}"
                if [ $i -eq 1 ]; then  # Segunda columna (índice 1)
                    items=$(echo "$value" | sed 's/,/<\/li><li>/g')
                    value="<ul><li>$items</li></ul>"
                fi
                echo "<td>$value</td>" >> $html_file
            done
            echo '</tr>' >> $html_file
        done
    else
        # Una sola columna
        echo "<tr class=\"head\"><td>$header</td></tr>" >> $html_file
        tail -n +2 $csv_file | while read -r line; do
            echo "<tr class=\"open\"><td>$line</td></tr>" >> $html_file
        done
    fi

    # Cerrar el HTML
    echo '</table>' >> $html_file
    echo '</div>' >> $html_file
    echo '</div>' >> $html_file
    echo '</body>' >> $html_file
    echo '</html>' >> $html_file
}

function rpc_call(){
    # Ejecutar un comando rpcclient con manejo de credenciales y errores
    local cmd="$1"
    local output
    if [[ -z $USER || -z $PASSWORD ]]; then
        # Null Session: sin credenciales
        output=$(rpcclient -U "" "$HOST_IP" -c "$cmd" -N 2>&1)
    else
        # Autenticación con usuario y contraseña
        output=$(rpcclient -U "$USER%$PASSWORD" "$HOST_IP" -c "$cmd" 2>&1)
    fi
    if [ $? -ne 0 ]; then
        # Mostrar error y salir si rpcclient falla
        echo -e "\n${LBlue}[${BRed}✘${LBlue}]${Color_Off} ${On_Red}${BWhite}Error:${Color_Off} ${BRed}$output${Color_Off}"
        tput cnorm; exit 1
    fi
    echo "$output"
}

function validate_target(){
    # Validar que HOST_IP esté definido
    if [ -z "$HOST_IP" ]; then
        echo -e "\n${LBlue}[${BRed}✘${LBlue}]${Color_Off} ${On_Red}${BWhite}Error:${Color_Off} ${BRed}IP o nombre del dominio no definido.${Color_Off}"
        tput cnorm; exit 1
    else
        if ! echo $HOST_IP | grep -P '^(\d{1,3}\.){3}\d{1,3}$' > /dev/null || [ $(echo $HOST_IP | tr '.' '\n' | wc -l) -ne 4 ] || [ $(echo $HOST_IP | tr '.' '\n' | awk '$1 > 255 {print}' | wc -l) -ne 0 ]; then                                        
            if ! getent hosts $HOST_IP > /dev/null; then
                echo -e "\n${LBlue}[${BRed}✘${LBlue}]${Color_Off} ${On_Red}${BWhite}Error:${Color_Off} ${BRed}$HOST_IP no es una IP válida ni un nombre de dominio resoluble.${Color_Off}"
                tput cnorm; exit 1
            fi
        fi
    fi
}

function validate_output(){
    # Validar que el formato de salida sea uno de los permitidos: txt, json, grep, html, all
    OUTPUT_FORMAT=$(echo "$OUTPUT_FORMAT" | tr '[:upper:]' '[:lower:]')
    if [ -n "$OUTPUT_FORMAT" ]; then
        case $OUTPUT_FORMAT in
            txt|json|grep|html|all) ;;
            *) echo -e "\n${LBlue}[${BRed}✘${LBlue}]${Color_Off} ${On_Red}${BWhite}Error:${Color_Off} ${BRed}$OUTPUT_FORMAT no es un formato de salida válido. Use txt, json, grep o html.${Color_Off}"; tput cnorm; exit 1;;
        esac
    fi
}

function enum_Users(){
    # Mostrar mensaje inicial de enumeración de usuarios
    echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Enumerando los Ususarios del Dominio...${Color_Off}\n"
    
    # Obtener lista de usuarios del dominio usando rpc_call
    domain_users=$(rpc_call "enumdomusers" -N | grep -oP '\[.*?\]' | grep -v 0x | tr -d '[]')

    # Guardar los usuarios en un archivo temporal con encabezado
    echo "Users" > $tmp_file && for user in $domain_users; do echo "$user" >> $tmp_file; done

    # Mostrar resultados en pantalla si NO_PRINT no está activado
    if [ "$NO_PRINT" != "true" ]; then
        echo -ne "${BGreen}"; printTable ' ' "$(cat $tmp_file)"; echo -ne "${Color_Off}"
    fi

    # Calcula y muestra el número de registros encontrados
    RECORDS=$(( $(wc -l < $tmp_file) - 1 ))
    echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Número de usuarios:${Color_Off} ${BGreen}$RECORDS${Color_Off}"

    # Guardar resultados en el formato especificado
    if [ -n "$OUTPUT_FORMAT" ]; then
        case $OUTPUT_FORMAT in
            txt)
                cp $tmp_file "rpcrecon_Users_$HOST_IP.txt"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Users_$HOST_IP.txt${Color_Off}"
                ;;
            json)
                csv_to_json $tmp_file "rpcrecon_Users_$HOST_IP.json"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Users_$HOST_IP.json${Color_Off}"
                ;;
            grep)
                csv_to_grep $tmp_file "rpcrecon_Users_$HOST_IP.grep"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Users_$HOST_IP.grep${Color_Off}"
                ;;
            html)
                csv_to_html $tmp_file "rpcrecon_Users_$HOST_IP.html"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Users_$HOST_IP.html${Color_Off}"
                ;;
            all)
                cp $tmp_file "rpcrecon_Users_$HOST_IP.txt"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Users_$HOST_IP.txt${Color_Off}"
                csv_to_json $tmp_file "rpcrecon_Users_$HOST_IP.json"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Users_$HOST_IP.json${Color_Off}"
                csv_to_grep $tmp_file "rpcrecon_Users_$HOST_IP.grep"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Users_$HOST_IP.grep${Color_Off}"
                csv_to_html $tmp_file "rpcrecon_Users_$HOST_IP.html"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Users_$HOST_IP.html${Color_Off}"
                ;;
        esac
    fi

    # Limpiar archivo temporal
    rm $tmp_file 2>/dev/null
}

function enum_Users_Info(){
    # Mostrar mensaje inicial de enumeración de usuarios con descripciones
    echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Listando los Usuarios del Dominio con su descripción...${Color_Off}\n"

    # Obtener lista de usuarios llamando a enum_Users (que ya usa rpc_call)
    enum_Users > /dev/null 2>&1

    # Obtener información detallada de cada usuario usando rpc_call
    for user in $domain_users; do
        rpc_call "queryuser $user" | grep -E 'User Name|Description' | cut -d ':' -f 2-100 | sed 's/\t//' | tr '\n' ',' | sed 's/.$//' >> $tmp_file
        echo -e '\n' >> $tmp_file
    done

    # Preparar archivo con encabezado y formato final
    echo "User;Description" > $tmp_file2
    cat $tmp_file | sed '/^\s*$/d' | while read user_representation; do
        if [ "$(echo $user_representation | awk '{print $2}' FS=',')" ]; then
            echo "$(echo $user_representation | awk '{print $1}' FS=',');$(echo $user_representation | awk '{print $2}' FS=',')" >> $tmp_file2
        fi
    done

    # Reemplazar archivo temporal original con el formateado
    rm $tmp_file; mv $tmp_file2 $tmp_file

    # Mostrar resultados en pantalla si NO_PRINT no está activado
    if [ "$NO_PRINT" != "true" ]; then
        sleep 1; echo -ne "${BGreen}"; printTable ';' "$(cat $tmp_file)"; echo -ne "${Color_Off}"
    fi

    # Calcula y muestra el número de registros encontrados
    RECORDS=$(( $(wc -l < $tmp_file) - 1 ))
    echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Número de usuarios:${Color_Off} ${BGreen}$RECORDS${Color_Off}"

    # Guardar resultados en el formato especificado
    if [ -n "$OUTPUT_FORMAT" ]; then
        case $OUTPUT_FORMAT in
            txt)
                cp $tmp_file "rpcrecon_UsersInfo_$HOST_IP.txt"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_UsersInfo_$HOST_IP.txt${Color_Off}"
                ;;
            json)
                csv_to_json $tmp_file "rpcrecon_UsersInfo_$HOST_IP.json"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_UsersInfo_$HOST_IP.json${Color_Off}"
                ;;
            grep)
                csv_to_grep $tmp_file "rpcrecon_UsersInfo_$HOST_IP.grep"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_UsersInfo_$HOST_IP.grep${Color_Off}"
                ;;
            html)
                csv_to_html $tmp_file "rpcrecon_UsersInfo_$HOST_IP.html"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_UsersInfo_$HOST_IP.html${Color_Off}"
                ;;
            all)
                cp $tmp_file "rpcrecon_UsersInfo_$HOST_IP.txt"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_UsersInfo_$HOST_IP.txt${Color_Off}"
                csv_to_json $tmp_file "rpcrecon_UsersInfo_$HOST_IP.json"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_UsersInfo_$HOST_IP.json${Color_Off}"
                csv_to_grep $tmp_file "rpcrecon_UsersInfo_$HOST_IP.grep"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_UsersInfo_$HOST_IP.grep${Color_Off}"
                csv_to_html $tmp_file "rpcrecon_UsersInfo_$HOST_IP.html"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_UsersInfo_$HOST_IP.html${Color_Off}"
                ;;
        esac
    fi

    # Limpiar archivo temporal
    rm $tmp_file 2>/dev/null
}

function enum_Admins(){
    # Mostrar mensaje inicial de enumeración de administradores
    echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Enumerando los Usuarios Administradores del Dominio...${Color_Off}\n"
    
    # Obtener RID del grupo "Domain Admins" usando rpc_call
    rid_dagroup=$(rpc_call "enumdomgroups" | grep -E "Domain Admins|Admins. del dominio" | awk 'NF{print $NF}' | grep -oP '\[.*?\]' | tr -d '[]')

    # Obtener RIDs de los miembros del grupo "Domain Admins"
    rid_dausers=$(rpc_call "querygroupmem $rid_dagroup" | awk '{print $1}' | grep -oP '\[.*?\]' | tr -d '[]')

    # Preparar archivo temporal con encabezado
    echo "DomainAdminUsers" > $tmp_file

    # Obtener nombres de usuarios administradores usando rpc_call
    for da_user_rid in $rid_dausers; do
        rpc_call "queryuser $da_user_rid" | grep 'User Name' | awk 'NF{print $NF}' >> $tmp_file
    done

    # Mostrar resultados en pantalla si NO_PRINT no está activado
    if [ "$NO_PRINT" != "true" ]; then
        echo -ne "${BGreen}"; printTable ' ' "$(cat $tmp_file)"; echo -ne "${Color_Off}"
    fi

    # Calcula y muestra el número de registros encontrados
    RECORDS=$(( $(wc -l < $tmp_file) - 1 ))
    echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Número de usuarios Admins:${Color_Off} ${BGreen}$RECORDS${Color_Off}"

    # Guardar resultados en el formato especificado
    if [ -n "$OUTPUT_FORMAT" ]; then
        case $OUTPUT_FORMAT in
            txt)
                cp $tmp_file "rpcrecon_Admins_$HOST_IP.txt"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Admins_$HOST_IP.txt${Color_Off}"
                ;;
            json)
                csv_to_json $tmp_file "rpcrecon_Admins_$HOST_IP.json"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Admins_$HOST_IP.json${Color_Off}"
                ;;
            grep)
                csv_to_grep $tmp_file "rpcrecon_Admins_$HOST_IP.grep"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Admins_$HOST_IP.grep${Color_Off}"
                ;;
            html)
                csv_to_html $tmp_file "rpcrecon_Admins_$HOST_IP.html"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Admins_$HOST_IP.html${Color_Off}"
                ;;
            all)
                cp $tmp_file "rpcrecon_Admins_$HOST_IP.txt"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Admins_$HOST_IP.txt${Color_Off}"
                csv_to_json $tmp_file "rpcrecon_Admins_$HOST_IP.json"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Admins_$HOST_IP.json${Color_Off}"
                csv_to_grep $tmp_file "rpcrecon_Admins_$HOST_IP.grep"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Admins_$HOST_IP.grep${Color_Off}"
                csv_to_html $tmp_file "rpcrecon_Admins_$HOST_IP.html"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Admins_$HOST_IP.html${Color_Off}"
                ;;
        esac
    fi

    # Limpiar archivo temporal
    rm $tmp_file 2>/dev/null
}

function enum_Groups(){
    # Mostrar mensaje inicial de enumeración de grupos
    echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Enumerando los Grupos del Dominio...${Color_Off}\n"

    # Obtener lista de RIDs de grupos del dominio usando rpc_call
    groups=$(rpc_call "enumdomgroups" | grep -oP '\[.*?\]' | grep "0x" | tr -d '[]')

    # Preparar archivo temporal con encabezado
    echo "DomainGroup;Description" > $tmp_file

    # Obtener nombre y descripción de cada grupo usando rpc_call
    for rid_domain_groups in $groups; do
        group_info=$(rpc_call "querygroup $rid_domain_groups")
        group_name=$(echo "$group_info" | grep "Group Name" | awk '{print $2}' FS=":")
        group_description=$(echo "$group_info" | grep "Description" | awk '{print $2}' FS=":")
        echo "$(echo $group_name);$(echo $group_description)" >> $tmp_file
    done

    # Mostrar resultados en pantalla si NO_PRINT no está activado
    if [ "$NO_PRINT" != "true" ]; then
        echo -ne "${BGreen}"; printTable ';' "$(cat $tmp_file)"; echo -ne "${Color_Off}"
    fi

    # Calcula y muestra el número de registros encontrados
    RECORDS=$(( $(wc -l < $tmp_file) - 1 ))
    echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Número de grupos:${Color_Off} ${BGreen}$RECORDS${Color_Off}"

    # Guardar resultados en el formato especificado
    if [ -n "$OUTPUT_FORMAT" ]; then
        case $OUTPUT_FORMAT in
            txt)
                cp $tmp_file "rpcrecon_Groups_$HOST_IP.txt"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Groups_$HOST_IP.txt${Color_Off}"
                ;;
            json)
                csv_to_json $tmp_file "rpcrecon_Groups_$HOST_IP.json"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Groups_$HOST_IP.json${Color_Off}"
                ;;
            grep)
                csv_to_grep $tmp_file "rpcrecon_Groups_$HOST_IP.grep"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Groups_$HOST_IP.grep${Color_Off}"
                ;;
            html)
                csv_to_html $tmp_file "rpcrecon_Groups_$HOST_IP.html"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Groups_$HOST_IP.html${Color_Off}"
                ;;
            all)
                cp $tmp_file "rpcrecon_Groups_$HOST_IP.txt"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Groups_$HOST_IP.txt${Color_Off}"
                csv_to_json $tmp_file "rpcrecon_Groups_$HOST_IP.json"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Groups_$HOST_IP.json${Color_Off}"
                csv_to_grep $tmp_file "rpcrecon_Groups_$HOST_IP.grep"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Groups_$HOST_IP.grep${Color_Off}"
                csv_to_html $tmp_file "rpcrecon_Groups_$HOST_IP.html"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Groups_$HOST_IP.html${Color_Off}"
                ;;
        esac
    fi

    # Limpiar archivo temporal
    rm $tmp_file 2>/dev/null
}

function enum_GroupsMember(){
    # Mostrar mensaje inicial de enumeración de grupos y sus miembros
    echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Enumerando los grupos del dominio y sus usuarios...${Color_Off}\n"

    # Obtener lista de RIDs de grupos del dominio usando rpc_call
    groups=$(rpc_call "enumdomgroups" | grep -oP '\[.*?\]' | grep "0x" | tr -d '[]')

    # Verificar si se obtuvieron grupos
    if [ -z "$groups" ]; then
        echo -e "\n${LBlue}[${BRed}✘${LBlue}]${Color_Off} ${On_Red}${BWhite}Error:${Color_Off} ${BRed}No se pudieron obtener los grupos del dominio.${Color_Off}"
        tput cnorm; exit 1
    fi

    # Preparar archivo temporal con encabezado
    echo "DomainGroup;Users" > "$tmp_file"

    # Iterar sobre cada grupo para obtener sus miembros
    for group_rid in $groups; do
        # Obtener nombre del grupo
        group_name=$(rpc_call "querygroup $group_rid" | grep "Group Name" | awk -F ':' '{print $2}' | sed 's/\t//g')
        
        # Obtener RIDs de los miembros del grupo
        members_rids=$(rpc_call "querygroupmem $group_rid" | awk '{print $1}' | grep -oP '\[.*?\]' | tr -d '[]')

        if [ -z "$members_rids" ]; then
            # Si no hay miembros, registrar como "Sin miembros"
            echo "$group_name;Sin miembros" >> "$tmp_file"
        else
            # Usar un array para almacenar los nombres de los miembros
            member_names=()
            for member_rid in $members_rids; do
                member_name=$(rpc_call "queryuser $member_rid" | grep "User Name" | awk '{print $4}')
                member_names+=("$member_name")
            done

            # Unir los nombres con comas y guardar en el archivo
            members=$(IFS=','; echo "${member_names[*]}")
            echo "$group_name;$members" >> "$tmp_file"
        fi
    done

    # Mostrar resultados en pantalla si NO_PRINT no está activado
    if [ "$NO_PRINT" != "true" ]; then
        echo -ne "${BGreen}"; printTable ';' "$(cat "$tmp_file")"; echo -ne "${Color_Off}"
    fi

    # Calcula y muestra el número de registros encontrados
    RECORDS=$(( $(wc -l < $tmp_file) - 1 ))
    echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Número de grupos con miembros listados:${Color_Off} ${BGreen}$RECORDS${Color_Off}"

    # Guardar resultados en el formato especificado
    if [ -n "$OUTPUT_FORMAT" ]; then
        case $OUTPUT_FORMAT in
            txt)
                cp "$tmp_file" "rpcrecon_GroupsMember_$HOST_IP.txt"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_GroupsMember_$HOST_IP.txt${Color_Off}"
                ;;
            json)
                csv_to_json "$tmp_file" "rpcrecon_GroupsMember_$HOST_IP.json"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_GroupsMember_$HOST_IP.json${Color_Off}"
                ;;
            grep)
                csv_to_grep "$tmp_file" "rpcrecon_GroupsMember_$HOST_IP.grep"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_GroupsMember_$HOST_IP.grep${Color_Off}"
                ;;
            html)
                csv_to_html "$tmp_file" "rpcrecon_GroupsMember_$HOST_IP.html"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_GroupsMember_$HOST_IP.html${Color_Off}"
                ;;
            all)
                cp "$tmp_file" "rpcrecon_GroupsMember_$HOST_IP.txt"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_GroupsMember_$HOST_IP.txt${Color_Off}"
                csv_to_json "$tmp_file" "rpcrecon_GroupsMember_$HOST_IP.json"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_GroupsMember_$HOST_IP.json${Color_Off}"
                csv_to_grep "$tmp_file" "rpcrecon_GroupsMember_$HOST_IP.grep"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_GroupsMember_$HOST_IP.grep${Color_Off}"
                csv_to_html "$tmp_file" "rpcrecon_GroupsMember_$HOST_IP.html"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_GroupsMember_$HOST_IP.html${Color_Off}"
                ;;
        esac
    fi

    # Limpiar archivo temporal
    rm "$tmp_file" 2>/dev/null
}

function enum_MembersGroup(){
    # Mostrar mensaje inicial de enumeración de usuarios y sus grupos
    echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Enumerando los usuarios y sus grupos de dominio...${Color_Off}\n"

    # Obtener lista de RIDs de usuarios del dominio usando rpc_call
    users=$(rpc_call "enumdomusers" | grep -oP '\[.*?\]' | grep 0x | tr -d '[]')

    # Verificar si se obtuvieron usuarios
    if [ -z "$users" ]; then
        echo -e "\n${LBlue}[${BRed}✘${LBlue}]${Color_Off} ${On_Red}${BWhite}Error:${Color_Off} ${BRed}No se pudieron obtener los usuarios del dominio.${Color_Off}"
        tput cnorm; exit 1
    fi

    # Preparar archivo temporal con encabezado
    echo "User;DomainGroup" > "$tmp_file"

    # Iterar sobre cada usuario para obtener sus grupos
    for user in $users; do
        # Obtener nombre del usuario
        user_name=$(rpc_call "queryuser $user" | grep "User Name" | awk -F ':' '{print $2}' | sed 's/\t//g')
        
        # Obtener RIDs de los grupos a los que pertenece el usuario
        group_rids=$(rpc_call "queryusergroups $user" | awk '{print $2}' | grep -oP '\[.*?\]' | tr -d '[]')

        if [ -z "$group_rids" ]; then
            # Si no pertenece a ningún grupo, registrar como "Sin grupo"
            echo "$user_name;Sin grupo" >> "$tmp_file"
        else
            # Usar un array para almacenar los nombres de los grupos
            group_names=()
            for group_rid in $group_rids; do
                group_name=$(rpc_call "querygroup $group_rid" | grep "Group Name" | awk -F ':' '{print $2}' | sed 's/\t//g')
                group_names+=("$group_name")
            done

            # Unir los nombres con comas y guardar en el archivo
            groups=$(IFS=','; echo "${group_names[*]}")
            echo "$user_name;$groups" >> "$tmp_file"
        fi
    done

    # Mostrar resultados en pantalla si NO_PRINT no está activado
    if [ "$NO_PRINT" != "true" ]; then
        echo -ne "${BGreen}"; printTable ';' "$(cat $tmp_file)"; echo -ne "${Color_Off}"
    fi

    # Calcula y muestra el número de registros encontrados
    RECORDS=$(( $(wc -l < $tmp_file) - 1 ))
    echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Número de usuarios listados:${Color_Off} ${BGreen}$RECORDS${Color_Off}"

    # Guardar resultados en el formato especificado
    if [ -n "$OUTPUT_FORMAT" ]; then
        case $OUTPUT_FORMAT in
            txt)
                cp "$tmp_file" "rpcrecon_MembersGroup_$HOST_IP.txt"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_MembersGroup_$HOST_IP.txt${Color_Off}"
                ;;
            json)
                csv_to_json "$tmp_file" "rpcrecon_MembersGroup_$HOST_IP.json"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_MembersGroup_$HOST_IP.json${Color_Off}"
                ;;
            grep)
                csv_to_grep "$tmp_file" "rpcrecon_MembersGroup_$HOST_IP.grep"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_MembersGroup_$HOST_IP.grep${Color_Off}"
                ;;
            html)
                csv_to_html "$tmp_file" "rpcrecon_MembersGroup_$HOST_IP.html"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_MembersGroup_$HOST_IP.html${Color_Off}"
                ;;
            all)
                cp "$tmp_file" "rpcrecon_MembersGroup_$HOST_IP.txt"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_MembersGroup_$HOST_IP.txt${Color_Off}"
                csv_to_json "$tmp_file" "rpcrecon_MembersGroup_$HOST_IP.json"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_MembersGroup_$HOST_IP.json${Color_Off}"
                csv_to_grep "$tmp_file" "rpcrecon_MembersGroup_$HOST_IP.grep"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_MembersGroup_$HOST_IP.grep${Color_Off}"
                csv_to_html "$tmp_file" "rpcrecon_MembersGroup_$HOST_IP.html"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_MembersGroup_$HOST_IP.html${Color_Off}"
                ;;
        esac
    fi

    # Limpiar archivo temporal
    rm $tmp_file 2>/dev/null
}

function enum_Domains(){
    # Mostrar mensaje inicial de enumeración de dominios
    echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Enumerando los Dominios...${Color_Off}\n"

    # Obtener lista de dominios usando rpc_call
    domains=$(rpc_call "enumdomains" | grep -oP '\[.*?\]' | grep -v 0x | tr -d '[]')

    # Guardar dominios en archivo temporal con encabezado
    echo "Domains" > $tmp_file && for domain in $domains; do echo "$domain" >> $tmp_file; done

    # Mostrar resultados en pantalla si NO_PRINT no está activado
    if [ "$NO_PRINT" != "true" ]; then
        echo -ne "${BGreen}"; printTable ' ' "$(cat $tmp_file)"; echo -ne "${Color_Off}"
    fi

    # Calcula y muestra el número de registros encontrados
    RECORDS=$(( $(wc -l < $tmp_file) - 1 ))
    echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Número de dominios:${Color_Off} ${BGreen}$RECORDS${Color_Off}"

    # Guardar resultados en el formato especificado
    if [ -n "$OUTPUT_FORMAT" ]; then
        case $OUTPUT_FORMAT in
            txt)
                cp $tmp_file "rpcrecon_Domains_$HOST_IP.txt"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Domains_$HOST_IP.txt${Color_Off}"
                ;;
            json)
                csv_to_json $tmp_file "rpcrecon_Domains_$HOST_IP.json"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Domains_$HOST_IP.json${Color_Off}"
                ;;
            grep)
                csv_to_grep $tmp_file "rpcrecon_Domains_$HOST_IP.grep"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Domains_$HOST_IP.grep${Color_Off}"
                ;;
            html)
                csv_to_html $tmp_file "rpcrecon_Domains_$HOST_IP.html"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Domains_$HOST_IP.html${Color_Off}"
                ;;
            all)
                cp $tmp_file "rpcrecon_Domains_$HOST_IP.txt"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Domains_$HOST_IP.txt${Color_Off}"
                csv_to_json $tmp_file "rpcrecon_Domains_$HOST_IP.json"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Domains_$HOST_IP.json${Color_Off}"
                csv_to_grep $tmp_file "rpcrecon_Domains_$HOST_IP.grep"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Domains_$HOST_IP.grep${Color_Off}"
                csv_to_html $tmp_file "rpcrecon_Domains_$HOST_IP.html"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_Domains_$HOST_IP.html${Color_Off}"
                ;;
        esac
    fi

    # Limpiar archivo temporal
    rm $tmp_file 2>/dev/null
}

function enum_RIDCycling(){
    # Mostrar mensaje inicial de enumeración de usuarios mediante RIDs
    echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Enumerando usuarios mediante RIDs...${Color_Off}\n"

    # Obtener el SID base del dominio usando el usuario "Administrator"
    sid_base=$(rpc_call "lookupnames Administrator" | grep -oP 'S-\d+-\d+-\d+-\d+-\d+-\d+' | head -n1)
    if [ -z "$sid_base" ]; then
        echo -e "${LBlue}[${BRed}✘${LBlue}]${BRed} No se pudo obtener el SID base.${Color_Off}"
        return
    fi
    echo -e "${LBlue}[${BBlue}*${LBlue}]${BWhite} SID del dominio: $sid_base${Color_Off}\n"

    # Preparar archivo temporal con encabezado
    echo "SID;User" > $tmp_file

    # Enumerar usuarios en el rango de RIDs 400 a 3000 usando rpc_call
    for rid in $(seq 400 3000); do
        output=$(rpc_call "lookupsids $sid_base-$rid")
        if ! echo "$output" | grep -q "unknown"; then
            sid_user=$(echo "$output" | awk '{print $1}' FS=" ")
            user=$(echo "$output" | awk '{print $2}' | cut -d'\' -f2)
            if [[ -n "$sid_user" || -n "$user" ]]; then
                echo "$(echo $sid_user);$(echo $user)" >> $tmp_file
            fi
        fi
    done

    # Enumerar usuarios en el rango de RIDs 400 a 3000
    for rid in $(seq 400 3000); do
        # Intentar obtener el nombre del usuario para el RID actual
        output=$(rpc_call "lookupsids $sid_base-$rid")
        if ! echo "$output" | grep -q "unknown"; then
            sid_user=$(echo "$output" | awk '{print $1}' FS=" ")
            user=$(echo "$output" | awk '{print $2}' | cut -d'\' -f2)
            if [[ -n "$user" ]]; then
                # Verificar si el usuario existe usando lookupnames
                lookup_output=$(rpc_call "lookupnames $user")
                if echo "$lookup_output" | grep -q "$sid_user"; then
                    # Si el usuario existe, agregar al archivo temporal
                    echo "$sid_user;$user" >> $tmp_file
                fi
            fi
        fi
    done

    # Mostrar resultados en pantalla si NO_PRINT no está activado
    if [ "$NO_PRINT" != "true" ]; then
        echo -ne "${BGreen}"; printTable ';' "$(cat $tmp_file)"; echo -ne "${Color_Off}"
    fi

    # Calcula y muestra el número de registros encontrados
    RECORDS=$(( $(wc -l < $tmp_file) - 1 ))
    echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Número de usuarios encontrados:${Color_Off} ${BGreen}$RECORDS${Color_Off}"

    # Guardar resultados en el formato especificado
    if [ -n "$OUTPUT_FORMAT" ]; then
        case $OUTPUT_FORMAT in
            txt)
                cp $tmp_file "rpcrecon_RIDCycling_$HOST_IP.txt"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_RIDCycling_$HOST_IP.txt${Color_Off}"
                ;;
            json)
                csv_to_json $tmp_file "rpcrecon_RIDCycling_$HOST_IP.json"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_RIDCycling_$HOST_IP.json${Color_Off}"
                ;;
            grep)
                csv_to_grep $tmp_file "rpcrecon_RIDCycling_$HOST_IP.grep"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_RIDCycling_$HOST_IP.grep${Color_Off}"
                ;;
            html)
                csv_to_html $tmp_file "rpcrecon_RIDCycling_$HOST_IP.html"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_RIDCycling_$HOST_IP.html${Color_Off}"
                ;;
            all)
                cp $tmp_file "rpcrecon_RIDCycling_$HOST_IP.txt"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_RIDCycling_$HOST_IP.txt${Color_Off}"
                csv_to_json $tmp_file "rpcrecon_RIDCycling_$HOST_IP.json"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_RIDCycling_$HOST_IP.json${Color_Off}"
                csv_to_grep $tmp_file "rpcrecon_RIDCycling_$HOST_IP.grep"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_RIDCycling_$HOST_IP.grep${Color_Off}"
                csv_to_html $tmp_file "rpcrecon_RIDCycling_$HOST_IP.html"
                echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} Resultados guardados en:${Color_Off} ${IGreen}rpcrecon_RIDCycling_$HOST_IP.html${Color_Off}"
                ;;
        esac
    fi

    # Limpiar archivo temporal
    rm $tmp_file 2>/dev/null
}

function enum_All(){
    # Ejecutar todas las funciones de enumeración en secuencia
    enum_Users
    enum_Users_Info
    enum_Admins
    enum_Groups
    enum_Domains
    enum_GroupsMember
    enum_MembersGroup
    enum_RIDCycling
}

function enumeration(){
    # Gestionar el modo de enumeración seleccionado y validar conexión
    ENUM_MODE=$(echo "$ENUM_MODE" | tr '[:upper:]' '[:lower:]')
    tput civis; nmap -p139 --open -T5 -v -n $HOST_IP | grep open > /dev/null 2>&1 && port_status=$?
    if [[ -z $USER || -z $PASSWORD ]]; then
        rpcclient -U "" $HOST_IP -c "enumdomusers" -N > /dev/null 2>&1
        if [ "$(echo $?)" == "0" ]; then
            if [ "$port_status" == "0" ]; then
                case $ENUM_MODE in
                    users)
                        enum_Users $HOST_IP
                        ;;
                    usersinfo)
                        enum_Users_Info $HOST_IP
                        ;;
                    admins)
                        enum_Admins $HOST_IP
                        ;;
                    groups)
                        enum_Groups $HOST_IP
                        ;;
                    domains)
                        enum_Domains $HOST_IP
                        ;;
                    groupsmember)
                        enum_GroupsMember $HOST_IP
                        ;;
                    membersgroup)
                        enum_MembersGroup $HOST_IP
                        ;;
                    ridcycling)
                        enum_RIDCycling $HOST_IP
                        ;;
                    all)
                        enum_All $HOST_IP
                        ;;
                    *)
                        echo -e "\n${LBlue}[${BRed}✘${LBlue}]${Color_Off} ${On_Red}${BWhite}Error:${Color_Off} ${BRed}$ENUM_MODE no es un tipo de Enumeración válida${Color_Off}"
                        tput cnorm
                        exit 1
                        ;;
                esac
            else
                echo -e "\n${IYellow}El puerto 139 parece estar cerrado en $HOST_IP${Color_Off}"
                tput cnorm; exit 0
            fi
        else
            echo -e "\n${LBlue}[${BRed}✘${LBlue}]${Color_Off} ${On_Red}${BWhite}Error:${Color_Off} ${BRed}Acceso denegado, revisa IP/hostname o las credenciales.${Color_Off}"
            tput cnorm; exit 0
        fi
    else
        rpcclient -U "$USER%$PASSWORD" $HOST_IP -c "enumdomusers" > /dev/null 2>&1
        if [ "$(echo $?)" == "0" ]; then
            if [ "$port_status" == "0" ]; then
                case $ENUM_MODE in
                    users)
                        enum_Users $HOST_IP $USER $PASSWORD
                        ;;
                    usersinfo)
                        enum_Users_Info $HOST_IP $USER $PASSWORD
                        ;;
                    admins)
                        enum_Admins $HOST_IP $USER $PASSWORD
                        ;;
                    groups)
                        enum_Groups $HOST_IP $USER $PASSWORD
                        ;;
                    domains)
                        enum_Domains $HOST_IP $USER $PASSWORD
                        ;;
                    groupsmember)
                        enum_GroupsMember $HOST_IP $USER $PASSWORD
                        ;;
                    membersgroup)
                        enum_MembersGroup $HOST_IP $USER $PASSWORD
                        ;;
                    ridcycling)
                        enum_RIDCycling $HOST_IP $USER $PASSWORD
                        ;;
                    all)
                        enum_All $HOST_IP $USER $PASSWORD
                        ;;
                    *)
                        echo -e "\n${LBlue}[${BRed}✘${LBlue}]${Color_Off} ${On_Red}${BWhite}Error:${Color_Off} ${BRed}$ENUM_MODE no es un tipo de Enumeración válida${Color_Off}"
                        tput cnorm
                        exit 0
                        ;;
                esac
            else
                echo -e "\n${IYellow}El puerto 139 parece estar cerrado en $HOST_IP${Color_Off}"
                tput cnorm; exit 0
            fi
        else
            echo -e "\n${LBlue}[${BRed}✘${LBlue}]${Color_Off} ${On_Red}${BWhite}Error:${Color_Off} ${BRed}Acceso denegado, revisa IP/hostname o las credenciales.${Color_Off}"
            tput cnorm; exit 0
        fi
    fi
}

# Procesar los argumentos de línea de comandos
arg=""
for arg; do
        delim=""
        case $arg in
        --enumeration)  args="${args}-e";;
        --ip)           args="${args}-i";;
        --username)     args="${args}-u";;
        --password)     args="${args}-p";;
        --output)       args="${args}-o";;
        --no-print)     args="${args}-n";;
        --version)      args="${args}-v";;
        --update)       update;;
        --help)         args="${args}-h";;
        *) [[ "${arg:0:1}" == "-" ]] || delim="\""
        args="${args}${delim}${arg}${delim} ";;
        esac
done

eval set -- $args

if [[ "$(echo $UID)" == "0" ]]; then
    declare -i parameter_counter=0; while getopts ":e:i:u:p:o:nvh:" arg; do
        case $arg in
            e) ENUM_MODE=$OPTARG; let parameter_counter+=1;;
            i) HOST_IP=$OPTARG; let parameter_counter+=1;;
            u) USER=$OPTARG;;
            p) PASSWORD=$OPTARG;;
            o) OUTPUT_FORMAT=$OPTARG;;
            n) NO_PRINT=true;;
            v) printVersion;;
            h) banner;helpPanel;;
        esac
    done

    if [[ $parameter_counter -ne 2 ]]; then
        if [[ $parameter_counter -eq 1 ]]; then
            banner
            echo -e "\n${LBlue}[${BRed}✘${LBlue}]${Color_Off} ${On_Red}${BWhite}Error:${Color_Off} ${BRed}Utilice por lo menos la opción -i y -e${Color_Off}"
            tput cnorm; exit 1
        fi
        banner
        helpPanel
    else
        banner
        if [[ "$NO_PRINT" == "true" && -z "$OUTPUT_FORMAT" ]]; then
            echo -e "\n${LBlue}[${BRed}✘${LBlue}]${Color_Off} ${On_Red}${BWhite}Error:${Color_Off} ${BRed}--no-print requiere que se especifique --output${Color_Off}"
            tput cnorm; exit 1
        fi
        validate_target
        validate_output
        enumeration
        tput cnorm
    fi
else
    echo -e "\n${LBlue}[${BYellow}!${BBlue}]${BYellow} Ejecute el script como r00t!${Color_Off}\n"
fi