# ---------

while [[ -z "$domain" ]]
do
  read -p "¿Como llamamos a este proyecto? (Ejemplo frontid, agora, google, etc): " domain
done

export domain


# ---------
echo ''
# ---------

while [[ -z "$db" ]]
do
  read -p "Puedes indicar el path de la DB si quieres que la carguemos inicialmente(Ej: $HOME/Downloads/bkp-$domain.sql). O pulsa intro si quires saltarte este paso: " db

  # Exit loop if user just press enter.
  if [[ $db = '' ]]; then
    unset db
    break
  fi

  # Check provided file exit and copy to the needed location.
  if [ ! -f "$db" ]; then
    echo "No encuentro la base de datos."
    echo ""
    unset db
  fi
done

export db

# ---------
echo ''
# ---------

read -p "Si el repositorio tiene la aplicación web en un subdirectorio en lugar de en la raiz pon la ruta en el repositorio (Ej: web). O pulsa intro si la raiz es '/': " base_web_root

export base_web_root

# ---------
echo ''
# ---------

read -p "Ubicación real de la app: " app_path

export app_path

# ---------
echo ''
# ---------

PS3="Especifica la versión de PHP que vas a usar: "
options=( '7.1-3.3.1' '7.0-3.3.1' '5.6-3.3.1' '5.3-3.3.1' )

select phpver in "${options[@]}" ; do

    if (( REPLY > 0 && REPLY <= ${#options[@]} )) ; then
        export phpver
        break

    else
        echo "Se te fue el dedo, esa no es una opción válida."
    fi
done

# ---------
echo ''
# ---------

PS3="Y el servidor http: "
options=( 'apache' 'nginx' )

select webserver in "${options[@]}" ; do

    if (( REPLY > 0 && REPLY <= ${#options[@]} )) ; then
        export webserver
        break

    else
        echo "Se te fue el dedo, esa no es una opción válida."
    fi
done

# ---------
echo ''
# ---------

PS3="Y la versión de MariaBD: "
options=( '10.2-x => Compatible con Mysql 5.7' '10.1-x => compatible con MySQL 5.6')

select mysqlver in "${options[@]}" ; do

    if (( REPLY > 0 && REPLY <= ${#options[@]} )) ; then
	mysqlver=$(echo $mysqlver| cut -d'-' -f 1)
        export mysqlver
        break

    else
        echo "Se te fue el dedo, esa no es una opción válida."
    fi
done

echo $mysqlver


# ---------
echo ''
# ---------


PS3="¿Qué tipo de proyecto es?: "
options=( 'D8' 'D7' 'generic' )

select app_kind in "${options[@]}" ; do

    if (( REPLY > 0 && REPLY <= ${#options[@]} )) ; then
        export app_kind
        break

    else
        echo "Se te fue el dedo, esa no es una opción válida."
    fi
done

# ---------
echo ''
# ---------
