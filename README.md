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

# STOP
If you're curious about how to do this manually, go [here](https://github.com/JackFlexington/Django_StarterPack/tree/main/tutorial).

## Running the installation script
* Copy [install.sh](https://github.com/JackFlexington/Django_StarterPack/blob/main/django_setup_script.sh) into a directory on your Ubuntu server.
  * Or copy and contents into a file using ```vi install.sh```
  * Press ```i``` while in VI to enable "Editing mode"
  * ```Right-click``` your mouse and paste the contents within.
  * To save and exit the file type ```:wq``` (colon, w, q)
* Give it read-write-execute permissions ```chmod 777 install.sh```
* Prior to executing, please ensure you're logged in at the primary user on the account (not root, but the account you'll be using regularly)
* Execute script by typing the following into your CLI (```./install.sh```)
* Script will prompt you some questions, you will need a github account setup.
  * Just answer the questions and the script should handle the rest.

Note:
If you receive something along the lines of "./install.sh: line 4: $'\r': command not found"... Then that means Windows (or some process) has appended "carriage return" to every single line within the script. Linux can't interpret these symbols therefore we'll need to convert the file within the Linux Command Line Terminal. (See [dos2unix](https://stackoverflow.com/questions/5688805/remove-carriage-return-in-bash-script-or-ignore-it-when-using-mv-mkdir) for more details) 

### Preview of installation
![Installation gif](https://github.com/JackFlexington/Django_StarterPack/blob/readme_tweaks/_gifs/install_script.gif)

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
  # Add "postgreSQL" to the list of DATABASES = {} # (See link: "postgreSQL_syntax)
  # Modify "TIME_ZONE" to your native time. # (See link: "List of database time zones")
```
* Link: [postgreSQL syntax](https://github.com/JackFlexington/Django_StarterPack/blob/main/_samples/postgreSQL.py)
* Link: [List of database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

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
* Note: On Windows, follow this guide [Windows Postgresql installation guide](https://medium.com/@9cv9official/creating-a-django-web-application-with-a-postgresql-database-on-windows-c1eea38fe294)
```bash
# [As ${USER}]
# Triple check that postgres password is setup correctly
sudo su postgres
psql
# Remember to use the user/password you selected in the above postgrSQL section
ALTER USER dbadmin WITH PASSWORD 'secureDBpassword';
\q
exit # Or (CTRL+D)

python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py createsuperuser # Create a super user to interact with Django
  # username = dbadmin | email = | password = secureDBpassword
  # Just used the same profile that manages the database, to manage the Django framework

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
Note: Add ```,include``` to the below file.
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
# from main_app.models import Student # (Example piece).

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
```
```py
# admin.py
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
