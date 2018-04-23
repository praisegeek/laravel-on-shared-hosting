# Setup Laravel App on cPanel and Shared Hosting environment
This is the missing piece in setting up your laravel app on a shared hosting environment without touching your app configs. Pretty good for auto deployments using git :)

### Setup
Run this script in your user home directory.
Ensure you have deployed your laravel app to your remote server.

### Parameters
- -a Laravel application name 
- -d Web server directory. Default is "public_html"

### Usage
```bash
~/bin/bash ./setup.sh -a LaravelApp
```

