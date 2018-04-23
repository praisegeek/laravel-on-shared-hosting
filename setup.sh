#!/bin/bash

usage() { echo "Usage: $0 [-a <appname>] [-d <webdir (optional) | default: 'public_html'>]" 1>&2; exit 1; }

while getopts ":a:u:d:" o; do
    case "${o}" in
        a)
            a=${OPTARG}
            ;;
        d)
            d=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))


if [ -z "${a}" ]; then
    usage
fi

webdir="${d:-"public_html"}"
eval webdir="~/${webdir}"
eval appdir="~/${u}${a}"
eval userpath="~${u}"
appdir_ok="\033[1;31m[x]\033[0m"
userpath_ok="\033[1;32m[ok]\033[0m"
laravel_appname_ok="\033[1;32m[ok]\033[0m"
webdir_ok="\033[1;31m[x]\033[0m"
eval symlink_dir="${webdir}/${a}_public"

if [ -d "${appdir}" ]; then
    appdir_ok="\033[1;32m[ok]\033[0m"
fi
if [ -d "${webdir}" ]; then
    webdir_ok="\033[1;32m[ok]\033[0m"
fi


echo
echo "Script will setup folder structure using the details below"
echo 
echo
echo -e "\033[1;36m ----------------------------------------------------------------------------------\033[0m"
echo
echo -e "\033[1;36m User Path = ${userpath} ${userpath_ok} \033[0m"
echo -e "\033[1;36m Laravel Appname = ${a} ${laravel_appname_ok} \033[0m"
echo -e "\033[1;36m Web Directory ${webdir} ${webdir_ok} \033[0m"
echo -e "\033[1;36m Laravel App Directory ${appdir} ${appdir_ok} \033[0m"
echo -e "\033[1;36m Symnlink Directory ${symlink_dir} \033[0m"
echo
echo -e "\033[1;36m ----------------------------------------------------------------------------------\033[0m"
echo
echo

read -p "Are these details correct? hit Y to confirm: " -n 1 -r
echo
echo 

if [[ $REPLY =~ ^[Yy]$ ]]
then
    eval app_path="~/${a}"
    echo -e "\033[1;36m[+] Preparing ${app_path}\033[0m"

    # eval "mkdir ${app_path} && chmod 755 ${app_path}"

    if [[ ! -d "${app_path}" ]] ; then
        echo -e "\033[1;31m[-] Laravel app directory: ${app_path} is not there, aborting.\033[0m"
        echo -e -n "\033[1;33m"
        echo "-----------------------------"
        echo "Before running again!"
        echo "Ensure you have deployed or checkout the laravel app to your web hosting"
        echo "server directory before running this script"
        echo "-----------------------------"
        echo -e -n "\033[0m"
        exit
    fi
    
    echo
    echo -e "\033[1;36m[+] setting permissions\033[0m"
    eval "chmod 755 ${app_path}/"
    eval "chmod 755 ${app_path}/public/"
    eval "chmod 644 ${app_path}/public/index.php"
    eval "chmod -R 777 ${app_path}/storage"
    echo
    echo -e "\033[1;36m[+] Creating symlinks\033[0m"
    echo -e "\033[1;33m e symlink ln -s ${app_path}/public ${webdir}/${a}_public\033[0m"
    echo -e "\033[1;36m[+] Creating .htaccess rule\033[0m"
    #eval "cd ~/${webdir} && touch .htaccess" 
    eval "cat > .htaccess << EOF
        Options -Indexes
        RewriteEngine On 
        RewriteCond %{REQUEST_URI} !^/${a}_public/ 
        RewriteCond %{REQUEST_FILENAME} !-f 
        RewriteCond %{REQUEST_FILENAME} !-d 
        RewriteRule ^(.*)$ ${a}_public/$1 
        RewriteRule ^(/)?$ ${a}_public/index.php [L]
    "
    #eval "cd -"
    echo -e -n "\033[1;32m[+] Tasks completed!\033[0m"
fi

# eval "chmod 755 /home/your_use/laravel_app/"