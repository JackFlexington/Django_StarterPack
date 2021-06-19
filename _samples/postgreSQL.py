# Database
# https://docs.djangoproject.com/en/3.2/ref/settings/#databases

##########################################
# DEFAULT METHOD (sqlite)
##########################################
#DATABASES = {
#    'default': {
#        'ENGINE': 'django.db.backends.sqlite3',
#        'NAME': BASE_DIR / 'db.sqlite3',
#    }
#}
##########################################
# POSTGRESQL METHOD
##########################################
DATABASES = {
  'default': {
    'ENGINE': 'django.db.backends.postgresql',
    'NAME': 'main',      # Database name
    'USER': 'JackFlex',  # Database Administrator
    'PASSWORD': 'password123', # Password (Use something stronger)
    'HOST': '127.0.0.1', # Local host address
    'PORT': '5432',      # Port to traffic to/from Django server 
  }
}
##########################################
