# This bash library contains useful functions to enable proxy on Ubuntu-Systems
# Beware doing too much hardcoing in case giving VM to s'one else!

# USE:
# ~/> proxy
#       - to activate proxy-settings
# ~/> proxyoff
#       - to delete your settings (DELETE PASSWORD FROM SETTINGS!!!!)


# Enable Proxy
function proxy() {
    echo -e
    read -p "Username           : " username
        if ! which cntlm > /dev/null; then
            while true; do
                unset password
                prompt="Password           : "
                while IFS= read -p "$prompt" -r -s -n 1 char
                do
                    if [[ $char == $'\0' ]]; then
                        break
                    fi
                prompt='*'
                password+="$char"
                done
                echo
                unset password2
                prompt="Password (again)   : "
                while IFS= read -p "$prompt" -r -s -n 1 char
                do
                    if [[ $char == $'\0' ]]; then
                        break
                    fi
                prompt='*'
                password2+="$char"
                done
                echo
                [ "$password" = "$password2" ] && break
                echo -e "\033[31m\nCHECK YOUR PASSWORD!!!\n\033[0m"
            done
#
# HARDCODING SECTION ON
#
            read -p "Proxy (host:port)  : " proxyaddr   # kick this line for hardcoded PROXY
            #proxyaddr=myproxy:port                     # uncomment this line and FILL IN DOMAIN
#
# HARDCODING SECTION OFF
#

            export http_proxy=http://$username:$password@$proxyaddr/
            export https_proxy=$http_proxy
            export ftp_proxy=$http_proxy
            export rsync_proxy=$http_proxy
            export no_proxy="localhost,127.0.0.1"
            if which git > /dev/null; then
                git config --global http.proxy $http_proxy
                git config --global https.proxy $http_proxy
                git config --global git.proxy $http_proxy
            fi
            if which curl > /dev/null; then
                alias curl="curl -x $http_proxy"
            fi
# Check if you can reach www.google.de, if you can't there might be something wrong with your password
            timeout 4s wget www.google.de
            if [ "$?" -gt 0 ];
            then
              echo -e
              echo -e "\033[31m\nUpps there went something wrong, please try again.\033[0m"
              proxy
              echo -e
            else
              echo -e
              echo -e "\033[31m"
              sudo sh -c '(echo "Acquire::http::proxy \"'$http_proxy'\";"; echo "Acquire::ftp::proxy \"'$http_proxy'\";"; echo "Acquire::https::proxy \"'$http_proxy'\";") > /etc/apt/apt.conf'
              echo -e "\033[32mProxy environment variable set.\033[0m"
              echo -e "\033[31m\nRemember to tun \[\033[34m\nproxypff\033[0m if you want to delete your proxy-settings. "
              echo -e "\nInstall CNTLM now! But first try \"sudo apt-get update\" :-)"
              echo -e
            fi
        else
# cannot be tabbed, otherwise no function of EOL
sudo sh -c "sudo cat > /etc/cntlm.conf" <<EOL
Username        set_username_here
Domain          set_domain_here
Auth            NTLMv2
PassNTLMv2      set_hash_here
Proxy           set_proxy_here
Listen          3128
EOL
#
# HARDCODING SECTION ON
#
        read -p "Domain             : " domain          # kick this line for hardcoded DOMAIN
        read -p "Proxy (host:port)  : " proxyaddr       # kick this line for hardcoded PROXY

        #domain=mydomain                                # uncomment this line and FILL IN DOMAIN
        #proxyaddr=myproxy:port                         # uncomment this line and FILL IN DOMAIN
#
# HARDCODING SECTION OFF
#
        sudo sh -c "/etc/init.d/cntlm stop"
        sudo sh -c "sed -i 's/Username.*/Username\t$username/g' /etc/cntlm.conf"
        sudo sh -c "sed -i 's/Domain.*/Domain\t\t$domain/g' /etc/cntlm.conf"
        sudo sh -c "sed -i 's/Proxy.*/Proxy\t\t$proxyaddr/g' /etc/cntlm.conf"
        sudo sh -c "cntlm -v -I -M http://www.heise.de -c /etc/cntlm.conf"
        echo    
        echo -e ================================================
        echo -e "\033[31mCopy and paste the HASH from PassNTLMv2 now.\033[0m"
        echo -e "(no PassNTLMv2, maybe wrong user/pass?)"
        echo -e ================================================
        echo -e
        read -p "PassNTLMv2      " password
        sudo sh -c "sed -i 's/PassNTLMv2.*/PassNTLMv2\t$password/g' /etc/cntlm.conf"
        sudo sh -c "/etc/init.d/cntlm restart"
        export http_proxy='http://localhost:3128'
        export https_proxy=$http_proxy
        export ftp_proxy=$http_proxy
        export rsync_proxy=$http_proxy
        export no_proxy="localhost,127.0.0.1"
        if which git > /dev/null; then
            git config --global http.proxy $http_proxy
            git config --global https.proxy $http_proxy
            git config --global git.proxy $http_proxy
        fi
        if which curl > /dev/null; then
            alias curl="curl -x $http_proxy"
        fi
        echo -e "\033[31m"
        sudo sh -c '(echo "Acquire::http::proxy \"'$http_proxy'\";"; echo "Acquire::ftp::proxy \"'$http_proxy'\";"; echo "Acquire::https::proxy \"'$http_proxy'\";") > /etc/apt/apt.conf'
        echo -e "\033[32mProxy environment variable set.\033[0m"
        echo -e "\nIf proxy is needed, use \"localhost:3128\""
        echo -e
        fi
}

# Disable Proxy
function proxyoff() {
    unset http_proxy
    unset https_proxy
    unset ftp_proxy
    unset rsync_proxy
        if which git > /dev/null; then
            git config --global --unset http.proxy
            git config --global --unset https.proxy
            git config --global --unset git.proxy
        fi
        if which curl > /dev/null; then
            unalias curl >/dev/null 2>&1
        fi
        if which cntlm > /dev/null; then
            echo -e
            sudo sh -c "/etc/init.d/cntlm stop"
            sudo sh -c "sed -i 's/Username.*/Username\tset_username_here/g' /etc/cntlm.conf"
            sudo sh -c "sed -i 's/PassNTLMv2.*/PassNTLMv2\tinsert_hash_here/g' /etc/cntlm.conf"
            sudo sh -c "sed -i 's/Domain.*/Domain\t\tset_domain_here/g' /etc/cntlm.conf"
            sudo sh -c "sed -i 's/Proxy.*/Proxy\t\tset_proxy_here/g' /etc/cntlm.conf"
        fi
    echo -e "\033[31m"
    sudo sh -c '(echo "";) > /etc/apt/apt.conf'
    echo -e "\033[32mProxy environment variable removed.\033[31m"
    echo -e
}

# Sometimes sync fails through proxy
function synctime() {
     sudo date -s "$(curl -sD - google.com | grep ^Date: | cut -d' ' -f3-6)Z"
}

