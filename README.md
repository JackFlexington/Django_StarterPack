# GitHub Repository: Django_StarterPack

# Before we start
* This document assumes you have fundamental Linux command line interface understandings
  * [Very great tutorial for learning Linux commands](https://linuxjourney.com/)
* VI Text Editor is my editor of choice due to its portibitilty and how its on nearly all Linux systems.
  * [Hands-on down the best VIM Text Editor book](https://www.amazon.com/Mastering-Vim-Quickly-WTF-time/dp/1983325740)

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

# STOP
#### If you're curious about how to do this manually, go [here]().

## Running the installation script
* Copy [install.sh]() into a directory on your Ubuntu server.
  * Or copy and contents into a file using ```vi install.sh```
  * Press ```i``` while in VI to enable "Editing mode"
  * ```Right-click``` your mouse and paste the contents within.
  * To save and exit the file type ```:wq``` (colon, w, q)
* Give it read-write-execute permissions ```chmod 777 install.sh```
* Execute script by typing the following into your CLI (```./install.sh```)
* Script will prompt you some questions, you will need a github account setup.
  * Just answer the questions and the script should handle the rest.
## Initializing the Django project
Okay great, the script installed and configured a number of items for us to get the ball rolling on this web project.

```bash
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
  # Add "main_app" to the list inside of INSTALLED_APPS = []
  # Add "postgreSQL" to the list of DATABASES = {}
  # Modify "TIME_ZONE" to your native time. (See link: "List of database time zones")
  
python3 manage.py migrate         # Update Django framework for database models
python3 manage.py createsuperuser # Create a super user to interact with Django
  # username = dbadmin | email = | password = secureDBpassword
  # Just used the same profile that manages the database, to manage the Django framework
```
Link: [List of database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

### Initialize application directories 
```bash
# [As ${USER}]
# This will initialize the appropriate files / folders
# for storing the actual web application
python3 manage.py startapp main_app
```
### Configure application files
```bash
# [As ${USER}]
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
  
cd ../ # Navigate back to parent directory
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
python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py runserver 0.0.0.0:8000
```
If you're able to navigate to "127.0.0.1:8000" in any web browser then you've successfully configured this machine to run Django.

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
```py
from .models import Member, Products, Transactions
admin.site.register(Member)
admin.site.register(Products)
admin.site.register(Transactions)
```

## Finalizing Databases on the server
```bash
# [As ${USER}]
python3 manage.py makemigrations          # Make database model changes
python3 manage.py migrate                 # Commit changes
python3 manage.py runserver 0.0.0.0:8000  # Start server
```
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

# Sources / Reference material:
* [Overall guide for Django initialization](https://developer.mozilla.org/en-US/docs/Learn/Server-side/Django/Tutorial_local_library_website)
* [PostgreSQL database configuration](https://docs.djangoproject.com/en/2.0/ref/settings/#databases)
* [Configure postgreSQL on system](https://www.cyberciti.biz/faq/howto-add-postgresql-user-account/)
* [Installing Visual Studio to Linux System](https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions)
* [Learn about C++ GNU compiler](https://www.tutorialspoint.com/How-to-Install-Cplusplus-Compiler-on-Linux)
* [Installation C++ GNU compiler guide](https://gcc.gnu.org/install/)
* [Git config username / email](https://linuxize.com/post/how-to-configure-git-username-and-email/)
