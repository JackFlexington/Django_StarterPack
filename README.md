# GitHub Repository: Django_StarterPack

# Before we start
* This document assumes you have fundamental Linux command line interface understandings
  * [Very great tutorial for learning Linux commands](https://linuxjourney.com/)
* VI Text Editor is my editor of choice due to its portibitilty and how its on nearly all Linux systems.
  * [Hands-on down the best VIM Text Editor book](https://www.amazon.com/Mastering-Vim-Quickly-WTF-time/dp/1983325740)

# Environment Documentation

## Operating System Information
* Acquired image on 02/06/2021
* Ubuntu Desktop 20.04.2 LTS (file name = ```ubuntu-20.04.2-desktop-amd64.iso```)
* Debian-based
* ISO file size: ~2.67-gigs (exact = ```2,877,227,008 bytes```)
* Link: [Download Ubuntu Desktop](https://ubuntu.com/download/desktop)
* Link: [Release Notes](https://wiki.ubuntu.com/FocalFossa/ReleaseNotes)
* Note: If you're using a Virtual Machine via "VMware" or "Virtual Box" or one of the others... remember to mount the .iso image so that you may install the operating system with ease.
* Package Manager Information: [Advanced Package Tool(APT)](https://ubuntu.com/server/docs/package-management)

# Start here (manual installation)

## Booting on the machine
* Enable "[Canonical Livepatch Service](https://ubuntu.com/security/livepatch)".
  * Note: This will require you to make a "Ubuntu One" account.
* A window called "Software Updater" will likely pop-up, prompting the user to update software that currently exists on the system. (i.e. Firefox, Ubuntu base, Libre Office suite, etc...)
  * When prompted, restart the machine.
* Open "Terminal" -> ```sudo su root``` -> ```apt update && apt upgrade```
  * Most likely nothing will occur due to the prior steps "Software Updater"... however, the system may prompt you to remove no longer necessary packages. If prompted type ```apt autoremove```
  * Exit root mode (Ctrl + D) or type "exit".

## System Configuration
### Installing Python3
* Open "Terminal"
```bash
# [As ${USER}]
sudo su root
apt install -y python3     # Install latest python
apt install -y python3-pip # Install latest pip (Python package manager)
python3 --version          # Verify installation worked
exit # or (CTRL + D)
``` 
### Installing Postgres binary && Django
```bash
# [As ${USER}]
pip3 install psycopg2-binary # Install postgres binary
pip3 install Django          # Install latest Django
```
  * If warnings occur regarding $PATH, type ```source ~/.profile``` this'll reload the system files and update the PATH with the recently initialized ```/home/${USER}/.local/bin```.
 
### [Optional] Updating VI text editor
```bash
# [As ${USER}]
sudo su root
apt-get update && apt-get install -y vim
# Note: I'm not sure why, but the base update / upgrade doesn't seem to update the native VI text editor. Performing this step is highly recommended as it drastically improves the usability of VI.
exit # or (CTRL+D)
```

### [Optional] Installing Visual Studio Code
Source: [Install Visual Studio Code](https://linuxize.com/post/how-to-install-visual-studio-code-on-ubuntu-20-04/)
```bash
# [As ${USER}]
# Note, executing these lines individually is preferred.
sudo apt update
sudo apt install -y software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt install code
```
1. Open Visual Studio Code (VS)
2. Open "Extensions" (Ctrl + Shift + X)
3. Search & Install "GitHub Pull Requests and Issues"
4. Navigate to bottom-left of VS screen to sign in, this will open up the browser and request you to sign into GitHub.
  * Note: Didn't require me to install Google Chrome to accept the URI link... But know you may need to Google Chrome should the link not work. (This is required to access GitHub from Visual Studio Code.) 
  ```bash
  # [As ${USER}]
  cd ~
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install ./google-chrome-stable_current_amd64.deb
  sudo apt update && apt upgrade
  ```
  * Search for "Default Applications" and set Google Chrome as default web browser.
  * Now when you navigate through the sign in process on GitHub, accept each one of the pop-ups to ensure that Visual Studio has everything it needs to appropriate as expected.
  * ```sudo apt-get remove -y google-chrome-stable``` for when you're done authenticating Visual Studio Code through Chrome. (Source: [Uninstall Google Chrome](https://askubuntu.com/questions/67047/how-to-uninstall-google-chrome))
5. Whenever you spin up the Django application, you can open the folder within Visual Studio Code and manage the repository through the previously installed extension.
  * Note: The ideal place to open a folder is the same directory used to interact with "manage.py".

### Installing Git
```bash
# [As ${USER}]
sudo apt update      # update module index
sudo apt install -y git # install git
git --verison        # check verison
```

### Configure Git locally
```bash
# [As ${USER}]
git config --global user.name "<YOUR_USERNAME>"
git config --global user.email "<EMAIL>@<DOMAIN.COM>"
```

## Database Configuration
Source: [Installing Postgres](https://www.postgresql.org/download/linux/ubuntu/)
### Configure postgres to receive live updates via "Livepatch service".
```bash
# [As ${USER}]
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql
```
### Add authentication / configuring database to run for postgres
Link: [source](https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-20-04-quickstart)
```bash
# [As ${USER}]
# Create superuser
sudo su root             # Login as "root"
su postgres              # Login as "postgres"
createuser --interactive # Create user 
  # Role = dbadmin
  # Yes to superuser
createdb dbadmin
# Exit "postgres" user
# [As root]
adduser dbadmin
# password = "secureDBpassword"
```
### Verify postgres database
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
\q # Quits back to ${USER}
```
If you've been successful so far, pat yourself on the back. System is officially configured to handle a Django project!

## Initializing the Django project
### Initialize project directories
```bash
# [As ${USER}]
cd ~                    # Navigate to home directory
sudo mkdir django       # Make folder
sudo chown $USER django # Give $USER ownership over django folder

cd django/
django-admin startproject Django_StarterPack # Give a name to the overall application
# Note: Directory will look like /Django_StarterPack/Django_StarterPack/
```
### Configure project
```bash
# [As ${USER}]
cd Django_StaterPack                         # Navigate to freshly created application folder
vi Django_StarterPack/settings.py
  # Modify ALLOWED_HOSTS = ["*"] # WARNING: NOT IDEAL FOR PRODUCTION ENVIRONMENT
  # Add "postgreSQL" to the list of DATABASES = {}
  # Modify "TIME_ZONE" to your native time. (See link: "List of database time zones")
```
Link: [List of database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)
### Initialize application directories 
```bash
# [As ${USER}]
# This will initialize the appropriate files / folders
# for storing the actual web application
python3 manage.py startapp main_app

vi Django_StarterPack/settings.py
  # Add "main_app" to the list inside of INSTALLED_APPS = []
```

### Configure postgres
```bash
# [As ${USER}]
# Triple check that postgres password is setup correctly
sudo su postgres
psql
ALTER USER dbadmin WITH PASSWORD 'secureDBpassword';
\q
exit # Or (CTRL+D)
python3 manage.py createsuperuser # Create a super user to interact with Django
  # username = dbadmin | email = | password = secureDBpassword
  # Just used the same profile that manages the database, to manage the Django framework
python3 manage.py makemigrations
python3 manage.py migrate

# Test configuration by running the Django server
python3 manage.py runserver 0.0.0.0:8000
```
If you're able to navigate to "127.0.0.1:8000" in any web browser then you've successfully configured this machine to run Django.

### Configure Django url file (Django_StarterPack)
```bash
# [As ${USER}]
vi Django_StarterPack/urls.py
  # Add url for "main_app" and redirect "" -> "main_app"
  # Enable serving of static files (CSS, JS, HTML, IMAGES, GIFS, etc...)
```
#### url.py example
```bash
# Libraries
from django.contrib import admin
from django.urls import path, include
from django.views.generic import RedirectView

# Default URL
urlpatterns = [
    path('admin/', admin.site.urls),
]

# Custom URL
urlpatterns += [
    path('main_app/', include('main_app.urls')),
    path('', RedirectView.as_view(url='main_app/', permanent=True)),
]

# Serving static files
from django.conf import settings
from django.conf.urls.static import static

# Location of "static/" folder
urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
```

### Configure Django application files (main_app)
```bash
cd main_app/
vi urls.py
  # Add path for index
  # (See example below)
  
#### urls.py
# Libraries
from django.urls import path
from . import views

# Custom URL schema
urlpatterns = [
    path('', views.index, name='index'),
]
#### END urls.py EXAMPLE
  
vi views.py
  # Add index view
  # (See example below)

#### views.py
from django.shortcuts import render, HttpResponseRedirect
from django.http import HttpRequest, HttpResponse

# Create your views here.
# Import database Classes # (LEAVE BELOW LINE BLANK UNTIL YOU'VE CREATED DATABASE TABLES) 
from main_app.models import Student # (Example piece).

def index(request):
    """View function for home page of website."""
    
    # Acquire values from Django database and store them into this dictionary.
    context = {}
    
    # Render webpage
    return render(request, 'index.html', context=context)
#### END views.py EXAMPLE

# templates/ folder is where the reusable HTML code sections will reside.
mkdir templates/
vi templates/index.html
  # Just add something here... example "hello world"
  
cd ../ # Navigate back to parent directory
```

## Constructing database tables
```bash
# [As ${USER}]
sudo su root # Sign in as "root" of system
su dbadmin   # Sign in as "database administrator"
psql main    # Log into postgres database that was created earlier

# [POSTGRES EDITOR]
CREATE DATABASE member; # Customer information
CREATE DATABASE products; # Items the store sells
CREATE DATABASE transaction; # Interactions between customer and store
\q

# [As ${USER}]
exit # Or (CTRL+D) # Out of "dbadmin"
exit # Or (CTRL+D) # Out of "root"
```

## Creating the Models
```bash
# [As ${USER}]
vi main_app/models.py
  # See https://developer.mozilla.org/en-US/docs/Learn/Server-side/Django/Models#author_model for example of how to create the models.
  # Note: Will be coming back in the future to provide an example.
```
Link: [Example of Model creation](https://developer.mozilla.org/en-US/docs/Learn/Server-side/Django/Models#author_model)

## Registering databases in Django
```bash
# [As ${USER}]
cd ~/django/Django_StarterPack # Navigate to application directory, if needed.
vi main_app/admin.py # Open admin file to register newly created databases.
  # Add "from .models import Member, Products, Transactions"
  # Add "admin.site.register(Member)"
  # Add "admin.site.register(Products)"
  # Add "admin.site.register(Transactions)"
```

## Finalizing Databases on the server
```bash
# [As ${USER}]
python3 manage.py makemigrations          # Make database model changes
python3 manage.py migrate                 # Commit changes
python3 manage.py runserver 0.0.0.0:8000  # Start server
```

## Pat yourself on the back, we've officially gotten the Django server spun up
Now, we're going to be skipping the creation of the actual web application in order to explain how to create an AWS instance to house this Django project!

# Basic Troubleshooting
* Had an issue where "127.0.0.1:8000/admin" wouldn't allow me to log in. Re ran the following to resolve.
  ```bash
  python3 manage.py createsuperuser # Create a super user to interact with Django
  # username = dbadmin | email = | password = secureDBpassword
  ```
* Had an issue where the database tables weren't being generated when using ```python3 manage.py makemigrations``` However, discovered that sometimes you need to explicitly target the django "INSTALLED_APP".
  ```
  # Specifically I mean to do the following
  python3 manage.py makemigrations main_app # As described above
  python3 manage.py migrate main_app
  ```
  Source: [StackOverflow Posting](https://stackoverflow.com/questions/39265898/programmingerror-error-during-template-rendering) && also error output from Django Application
  
# General Tips
* Need to close your SSH connection / Terminal for any reason? See "[screen](http://www.gnu.org/software/screen/)" from GNU software... (Use case below)
   ```bash
   # Log into Terminal
   screen # Activates the screen package (if downloaded)
   cd ${DJANGO_DIRECTORY} # Change to directory that houses the "manage.py" file
   python3 manage.py runserver 0.0.0.0:8000 # Run the server as normal
   # Press both (ctrl + a) keys
   # Press "d" to disconnect from "screen"
   # Now we're back in the old Terminal that we know and love
   # If you'd like to reconnect to the most recently opened "screen", type the below
   screen -r # Connects to screen again
   ```
   Source: [StackOverflow](https://stackoverflow.com/questions/10656147/how-do-i-keep-my-django-server-running-even-after-i-close-my-ssh-session)

# Sources / Reference material:
* [Overall guide for Django initialization](https://developer.mozilla.org/en-US/docs/Learn/Server-side/Django/Tutorial_local_library_website)
* [PostgreSQL database configuration](https://docs.djangoproject.com/en/2.0/ref/settings/#databases)
* [Configure postgreSQL on system](https://www.cyberciti.biz/faq/howto-add-postgresql-user-account/)
* [Installing Visual Studio to Linux System](https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions)
* [Learn about C++ GNU compiler](https://www.tutorialspoint.com/How-to-Install-Cplusplus-Compiler-on-Linux)
* [Installation C++ GNU compiler guide](https://gcc.gnu.org/install/)
* [Git config username / email](https://linuxize.com/post/how-to-configure-git-username-and-email/)
