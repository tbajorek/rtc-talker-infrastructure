#!/usr/bin/env bash

clear
if [ "$EUID" -ne 0 ]
  then echo "Proszę uruchomić skrypt z uprawnieniami administratora."
  exit
fi

cat <<EOF
                        ______ _____ _____   _____     _ _
                        | ___ \_   _/  __ \ |_   _|   | | |
                        | |_/ / | | | /  \/   | | __ _| | | _____ _ __
                        |    /  | | | |       | |/ _\` | | |/ / _ \ '__|
                        | |\ \  | | | \__/\   | | (_| | |   <  __/ |
                        \_| \_| \_/  \____/   \_/\__,_|_|_|\_\___|_|

                                    Instalator aplikacji
                                            v1.0.0
EOF

# instalowanie wymaganego oprogramowania zewnętrznego
function installSoftware()
{
    local  command_name=$1
    command -v $command_name >/dev/null 2>&1 || {
        echo "Instaluję oprogramowanie $command_name...";
        apt-get install --yes $command_name >/dev/null && echo "Program $command_name został poprawnie zainstalowany.";
    }
}

# instalacja Dockera
function installDocker()
{
    command -v docker >/dev/null 2>&1 || {
        echo "Instaluję program Docker...";
        curl -fsSL https://yum.dockerproject.org/gpg | sudo apt-key add - &&
        add-apt-repository \
           "deb https://apt.dockerproject.org/repo/ \
           ubuntu-$(lsb_release -cs) \
           main" &&
        updateAptList &&
        apt-get -y install docker-engine &&
        systemctl start docker &&
        systemctl enable docker &&
        groupadd docker &&
        gpasswd -a ${USER} docker &&
        echo "`docker --version` został poprawnie zainstalowany.";
    }
}

# instalacja docker-compose
function installDockerCompose()
{
    command -v docker-compose >/dev/null 2>&1 || {
        echo "Instaluję narzędzie docker-compose.."
        curl -L "https://github.com/docker/compose/releases/download/1.10.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&
        chmod +x /usr/local/bin/docker-compose &&
        echo "`docker-compose --version` został poprawnie zainstalowany.";
    }
}

# aktualizowanie listy pakietów
function updateAptList()
{
    echo "Aktualizowanie listy pakietów oprogramowania...";
    apt-get update >/dev/null && echo "Lista została zaktualizowana.";
}

# pobieranie danych aplikacji
function gitCloneApp()
{
    echo "Przygotowuję miejsce na dysku"
    rm rtc-talker/* -Rf;
    local base_url="https://github.com/tbajorek/";
    echo "Pobieram aplikację RTC Talker...";
    cd rtc-talker;
    git clone --quiet "$base_url""rtc-talker-widget.git" >/dev/null && cp ../.env ./rtc-talker-widget/ && echo "* Widget" &&
    git clone --quiet "$base_url""rtc-talker-sigserver.git" >/dev/null && cp ../.env ./rtc-talker-sigserver/ && echo "* Serwer sygnalizacji" &&
    git clone --quiet "$base_url""rtc-talker-rest.git" >/dev/null && cp ../.env ./rtc-talker-rest/ && echo "* Serwer REST" &&
    git clone --quiet "$base_url""rtc-talker-panel.git" >/dev/null && cp ../.env ./rtc-talker-panel/ && echo "* Panel obsługi" &&
    echo "Aplikacja RTC Talker została pobrana na dysk";
    cd ../;
    chmod 777 ./rtc-talker/ -Rf
}

# główna część instalatora
read -p "Proszę wpisać własne wartości do pliku env.data, a następnie wcisnąć dowolny klawisz..." -n1 -s
echo "";
echo "";
# - instalacja potrzebnego oprogramowania
updateAptList
installSoftware linux-image-extra-$(uname -r)
installSoftware linux-image-extra-virtual
installSoftware curl
installDocker
installDockerCompose
# - aktualizacja zmiennych środowiskowych
rm .env -f
cp env.data .env
# - pobranie aplikacji
gitCloneApp
# - uruchomienie środowiska
docker-compose up --build