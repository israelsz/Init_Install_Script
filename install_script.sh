read -p " ¿Instalar docker|portainer|mongodb|mongodb compass? (y/n) " dockerflag
read -p " ¿Instalar vscode? (y/n) " vscodeflag
read -p " ¿Instalar golang? (y/n) " goflag
read -p " ¿Instalar nodejs? (y/n) " nodeflag
read -p " ¿Instalar gitkraken (y/n) " krakenflag
read -p " ¿Instalar zsh + plugins? (y/n) " zhsflag

echo "Actualizando Repos"
sudo apt update

if [ $dockerflag = "y" ] || [ $dockerflag = "s" ] || [ $dockerflag = "yes" ]
then
    echo "Instalando docker y docker compose"
    sudo apt-get update
    sudo apt-get -y install \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
        software-properties-common \
        apt-transport-https

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu jammy stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update
    sudo apt -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # Añadir al usuario docker al grupo de root
    sudo groupadd docker
    sudo usermod -aG docker $USER

    echo "Instalando portainer"
    sudo docker volume create portainer_data
    sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

    echo "Instalando mongodb v3.6 via docker"
    sudo docker run --name mongodb -d -p 27017:27017 mongo:3.6

    echo "Instalando mongodb compass"
    wget https://downloads.mongodb.com/compass/mongodb-compass_1.35.0_amd64.deb
    sudo dpkg -i mongodb-compass_1.35.0_amd64.deb
    sudo apt --fix-broken install

    sudo rm mongodb-compass_1.35.0_amd64.deb

fi

if [ $vscodeflag = "y" ] || [ $vscodeflag = "s" ] || [ $vscodeflag = "yes" ]
then
    echo "Instalando VScode"
    sudo apt update
    sudo apt install apt-transport-https
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install code
    sudo apt --fix-broken install

fi


if [ $goflag = "y" ] || [ $goflag = "s" ] || [ $goflag = "yes" ]
then
    echo "Instalando golang"
    wget https://go.dev/dl/go1.20.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.20.linux-amd64.tar.gz
    #Se escribe al path
    echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee -a  /etc/profile
    sudo rm go1.20.linux-amd64.tar.gz
fi

if [ $nodeflag = "y" ] || [ $nodeflag = "s" ] || [ $nodeflag = "yes" ]
then
    echo "Instalando nodejs"
    sudo apt install software-properties-common apt-transport-https ca-certificates gnupg2 curl build-essential
    curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt update
    sudo apt -y install nodejs
fi


if [ $krakenflag = "y" ] || [ $krakenflag= "s" ] || [ $krakenflag = "yes" ]
then
    wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
    sudo dpkg -i gitkraken-amd64.deb
    sudo apt --fix-broken install
    sudo rm gitkraken-amd64.deb
fi

if [ $zhsflag = "y" ] || [ $zhsflag = "s" ] || [ $zhsflag = "yes" ]
then
    echo "Instalando zsh"
    sudo apt -y install zsh
    #Cambiar shell por defecto
    sudo chsh -s $(which zsh)
    #Crear archivo zshrc vacio
    touch ~/.zshrc
    # Instalar oh my zsh
    sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
    # Copiar plantilla en zshrc
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
    # Plugin de syntax highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    # Plugin de autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    # Activar plugins
    sudo sed -i -e 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions sudo)/g' ~/.zshrc
    #Instalar powerlevel10k
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    # Activar powerlevel10k
    sudo sed -i -e 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k/powerlevel10k"/g' ~/.zshrc
fi

