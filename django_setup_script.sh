# Collect user information
while
  echo -e "Welcome to JackFlex's automated process for configuring Django onto a Ubuntu server";
  echo -e 'If you would spare a moment, please answer the following questions?';
  echo -e '-----------------------------------------------------';
  read -p 'Username for database admin?: ' DB_USERNAME;
  read -p 'Password for database admin?: ' DB_PASSWORD;
  read -p 'Git username?: ' GIT_USERNAME;
  read -p 'Git email?: ' GIT_EMAIL;
  # Forcing this for now.
  #read -p 'Installing Chrome? (y/n): ' CHROME;
  #read -p 'Installing Visual Studio Code? (y/n): ' VISUAL_CODE;
  clear;
  echo -e 'Wonderful! Please confirm the values below';
  echo -e '-----------------------------------------------------';
  echo -e 'Database username = ' ${DB_USERNAME};
  echo -e 'Database password = ' ${DB_PASSWORD};
  echo -e 'Git username = ' ${GIT_USERNAME};
  echo -e 'Git email = ' ${GIT_EMAIL};
  #echo -e 'Install Chrome = ' ${CHROME};
  #echo -e 'Install Visual Studio Code = ' ${VISUAL_CODE};
  echo -e '-----------------------------------------------------';
  read -p 'Is the above information correct? (y/n): ' PROMPT;
  [[ ${PROMPT} != y ]]
do true; done
clear;

# Update system
echo -e '===========================================';
echo -e 'UPDATING SYSTEM INFORMATION'
echo -e '===========================================';
sudo -s << EOF
apt -y update && apt -y upgrade;
apt install -y python3;
apt install -y python3-pip;
apt-get update && apt-get install -y vim
EOF

# Install PostgreSQL binary && Django
echo -e '===========================================';
echo -e 'INSTALLING POSTGRESQL BINARY && DJANGO'
echo -e '===========================================';
pip3 install psycopg2-binary;
pip3 install Django;
source ~/.profile;

# Install Visual Studio Code
echo -e '===========================================';
echo -e 'INSTALL VISUAL STUDIO CODE'
echo -e '===========================================';
sudo -s << EOF
apt -y update;
apt install -y software-properties-common apt-transport-https wget;
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -;
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main";
apt install code;
EOF

# Install Google Chrome
echo -e '===========================================';
echo -e 'INSTALLING GOOGLE CHROME'
echo -e '===========================================';
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb;
sudo -s << EOF
apt install ./google-chrome-stable_current_amd64.deb;
apt -y update && apt -y upgrade;
EOF

# Install Git
echo -e '===========================================';
echo -e 'INSTALLING GIT'
echo -e '===========================================';
sudo -s << EOF
apt -y update;
apt -y install git;
EOF

# Configure Git
git config --global user.name "${GIT_USERNAME}";
git config --global user.email "${GIT_EMAIL}";

# Configure PostgreSQL
echo -e '===========================================';
echo -e 'CONFIGURING POSTGRESQL'
echo -e '===========================================';
sudo -s << EOF
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list';
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -;
apt-get -y update;
apt-get -y install postgresql;
EOF

# Add user to manage the database
echo -e '===========================================';
echo -e 'ADDING USER TO MANAGE THE DATABASE'
echo -e '===========================================';
sudo -s useradd -m -p secureDBpassword dbadmin;
sudo -u postgres createuser ${DB_USERNAME} -sd;  # superuser ; can create databases
sudo -u postgres createdb main;
sudo -u postgres useradd -m -p ${DB_PASSWORD} ${DB_USERNAME};
PSQL_STRING="GRANT ALL PRIVILEGES ON DATABASE main TO ${DB_USERNAME} ; ALTER USER ${DB_USERNAME} WITH PASSWORD '${DB_PASSWORD}' ; ";
echo ${PSQL_STRING} | sudo -u ${DB_USERNAME} psql main;

# Move into Django application directory
cd ~; 
mkdir django;
sudo chown ${USER} django/;
cd django/;

echo -e '===========================================';
echo -e 'Script is finished.';
echo -e 'Rebooting the server now...';
echo -e '===========================================';
sleep 8;
reboot;
