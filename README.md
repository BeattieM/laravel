THIS REPOSITORY IS NO LONGER MAINTAINED. PLEASE GO TO https://github.com/501st-alpha1/laravel-chef FOR THE MOST UP-TO-DATE CODE
===

Description
===========
The Chef Laravel cookbook installs and configures Laravel 4 according to the instructions at http://laravel.com.  
It includes: 
* [Jefferey Way's Laravel 4 Generators](https://github.com/JeffreyWay/Laravel-4-Generators)
* [Frozennodes's Laravel Admin](https://github.com/FrozenNode/Laravel-Administrator)

Platform
========
* Debian, Ubuntu

Cookbooks
=========
* MySQL
* PHP
* Apache2
* Composer

Attributes
==========
`node ['laravel']['db']['host']` - Host for the Laravel MySQL database  
  :default => "localhost"

`node ['laravel']['db']['user']` - Laravel will connect to MySQL using this user  
  :default => "root"

`node ['laravel']['db']['pass']` - Password for the Laravel MySQL user  
  :default => "MySQL::server_root_password"

`node ['laravel']['db']['name']` - Laravel will connect to this MySQL database  
  :default => "laraveldb"

`node ['laravel']['project_root']` - Laravel project root directory  
  :default => "/srv"

`node ['laravel']['project_name']` - Laravel project name  
  :default => "user defined requirement"

Recipes
=======
## Laravel
This will install Laravel 4, create your project, create the associated database, and setup your apache VitrualHost.
This will also install Jefferey Way's Laravel 4 Generators. For more information please view this project on GitHub.

## Admin
This will install FrozenNode's Laravel Admin. For more information please view this project on GitHub. 

Usage
=====
To install Laravel add the "laravel" recipe to your run list.
To install the admin module add the "laravel::admin" recipe to your run list.
After installation in a development environment add `dev.{your_project_name}.com` to your hosts file.

License and Author
==================
Author: Michael Beattie (https://github.com/BeattieM - beattiem@knights.ucf.edu)

Licensed under the [MIT license](http://opensource.org/licenses/MIT).

Acknowledgements
================
* Jefferey Way's Laravel 4 Generators is the property of [Jefferey Way](https://github.com/JeffreyWay)
* FrozenNodes's Laravel Admin is the property of [FrozenNode](https://github.com/FrozenNode)
