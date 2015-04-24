# This bash library contains useful functions to enable proxy on Ubuntu-Systems
# Beware doing too much hardcoing in case giving VM to s'one else!

# Enable Proxy
function proxy(){
	echo -e
	echo -n "Username : "
	read -e username
		if ! which cntlm > /dev/null; then
			echo -n "Password : "
			read -es password
			#wanna kick next two line and hardcode your $proxyaddr ?
            echo -n "Proxy (host:port) : "
            read -e proxyaddr
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
			echo -e
			echo -e "\033[31m"
			sudo sh -c '(echo "Acquire::http::proxy \"'$http_proxy'\";"; echo "Acquire::ftp::proxy \"'$http_proxy'\";"; echo "Acquire::https::proxy \"'$http_proxy'\";") > /etc/apt/apt.conf'
			echo -e "\033[32mProxy environment variable set.\033[0m"
			echo -e
		else
            if [ ! -f "/etc/cntlm.conf" ]; then
                echo -e "\n File \"/etc/cntlm.conf\"not found!\n"; 
            else

		echo -n "Domain	: "
		read -e domain
		echo -n "Proxy (host:port) : "
		read -e proxyaddr
		sudo sh -c "/etc/init.d/cntlm stop"
		sudo sh -c "sed -i 's/Username.*/Username\t$username/g' /etc/cntlm.conf"
		sudo sh -c "sed -i 's/Domain.*/Domain\t\t$domain/g' /etc/cntlm.conf"
		sudo sh -c "sed -i 's/Proxy.*/Proxy\t\t$proxyaddr/g' /etc/cntlm.conf"
		sudo sh -c "cntlm -v -I -M http://www.heise.de -c /etc/cntlm.conf"
		echo -e ================================================================================
		echo -e
		echo -e "\033[31mJUST FILL IN THE HASH FROM ABOVE\033[0m"
		echo -e "(if there is none, wrong user/pass?)"
		echo -e
		echo -e	"Auth        NTLMv2"
		echo -n "PassNTLMv2: "
                read -e password
		sudo sh -c "sed -i 's/PassNTLMv2.*/PassNTLMv2\t$password/g' /etc/cntlm.conf"
		sudo sh -c "/etc/init.d/cntlm start"
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
		echo -e
		fi
}

# Disable Proxy
function proxyoff(){
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

#Sometime NTP not reachable through proxy, so ~/>synctime
function synctime(){
    sudo date -s "$(curl -sD - google.com | grep ^Date: | cut -d' ' -f3-6)Z"
}
