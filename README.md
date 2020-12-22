# GitHub Repository: Django_StarterPack

# Start here (manual installation)

# Environment Documentation

## Operating System Information
* Acquired image on 12/20/2020
* Ubuntu Desktop 20.04.1 LTS (file name = ```ubuntu-20.04.1-desktop-amd64.iso```)
* Debian-based
* ISO file size: ~2.6-gigs (exact = ```2,785,017,856 bytes```)
* Link: [Download Ubuntu Desktop](https://ubuntu.com/download/desktop)
* Link: [Release Notes](https://wiki.ubuntu.com/FocalFossa/ReleaseNotes)
* Note: If you're using a Virtual Machine via "VMware" or "Virtual Box" or one of the others... remember to mount the .iso image so that you may install the operating system with ease.
* Package Manager: [Advanced Package Tool(APT)](https://ubuntu.com/server/docs/package-management)

## Booting on the machine
* Enable "[Canonical Livepatch Service](https://ubuntu.com/security/livepatch)".
  * Note: This will require you to make a "Ubuntu One" account.
* A window called "Software Updater" will likely pop-up, prompting the user to update software that currently exists on the system. (i.e. Firefox, Ubuntu base, Libre Office suite, etc...)
  * When prompted, restart the machine.
* Open "Terminal" -> ```sudo su root``` -> ```apt update && upgrade```
  * Most likely nothing will occur due to the prior steps "Software Updater"... however, the system may prompt you to remove no longer necessary packages. If prompted type ```apt autoremove```
  * Exit root mode (Ctrl + D) or type "exit".

## System Configuration
* Open "Terminal" -> ```sudo su root```
```bash
apt install -y python3     # Install latest python
apt install -y python3-pip # Install latest pip (Python package manager)
python3 --version          # Verify installation worked
```  
  * Exit root mode (Ctrl + D) or type "exit".
* [ as user ]
```bash
pip3 install psycopg2-binary # Install postgres binary
pip3 install Django          # Install latest Django
```
  * If warnings occur regarding $PATH, type ```source ~/.profile``` this'll reload the system files and update the PATH with the recently initialized ```/home/${USER}/.local/bin```.

## Database Configuration
Source: [Installing Postgres](https://www.postgresql.org/download/linux/ubuntu/)
* Configure postgres to receive live updates via "Livepatch service".
```bash
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql
```
* Add authentication / configuring database to run for postgres
  * Link: [source](https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-20-04-quickstart)
```bash
# Create superuser
sudo su root             # Login as "root"
su postgres              # Login as "postgres"
createuser --interactive # Create user 
  # Role = dbadmin
  # Yes to superuser
createdb dbadmin
# Exit "postgres" user
adduser dbadmin
```
* Verifying all is good
```bash
# Exit to "${USER}"
sudo -u dbadmin psql
# If this works, continue guide.
# If not, circle back and look for missed steps.

# While at the postgres Command line interface prompt (Example: dbadmin=#)
\conninfo
# \conninfo results in current postgres database connections present on the system.

CREATE DATABASE main;                             # Create database
GRANT ALL PRIVILEGES ON DATABASE main TO dbadmin; # Allow dbadmin to perform all database admin functions.
```
### If you've been successful so far, pat yourself on the back. System is officially configured to handle a Django project!

## Initializing the Django project
```bash
cd ~                    # Navigate to home directory
sudo mkdir django       # Make folder
sudo chown $USER django # Give $USER ownership over django folder

cd django/
django-admin startproject Django_StarterPack # Give a name to the overall application
cd Django_StaterPack                         # Navigate to freshly created application folder
python3 manage.py migrate         # Update Django framework for database models
python3 manage.py createsuperuser # Create a super user to interact with Django
  # username = dbadmin | email = | password = secureDBpassword
  # Just used the same profile that manages the database, to manage the Django framework

# This will initialize the appropriate files / folders
# for storing the actual web application
python3 manage.py startapp main_app

vi Django_StarterPack/settings.py
  # Modify ALLOWED_HOSTS = ["*"] # WARNING: NOT IDEAL FOR PRODUCTION ENVIRONMENT
  # Add "main_app" to the list inside of INSTALLED_APPS = []
  # Add "postgreSQL" to the list of DATABASES = {}
  # Modify "TIME_ZONE" to your native time. (See link: "List of database time zones")
```
Link: [List of database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)
```bash
vi Django_StarterPack/urls.py
  # Add url for "main_app" and redirect "" -> "main_app"
  # Enable serving of static files (CSS, JS, HTML, IMAGES, GIFS, etc...)
  
cd main_app/
vi urls.py
  # Add path for index
  
vi views.py
  # Add index view
  
mkdir templates/
vi templates/index.html
  # Just add something here... example "hello world"
```
```bash
# Triple check that postgres password is setup correctly
sudo su postgres
psql
ALTER USER dbadmin WITH PASSWORD 'secureDBpassword';
\q
exit # Or (CTRL+D)
sudo su dbadmin
python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py runserver 0.0.0.0:8000
```
If you're able to navigate to "127.0.0.1:8000" in any web browser then you've successfully configured this machine to run Django.
