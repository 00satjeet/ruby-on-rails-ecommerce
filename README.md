# Ruby on Rails Ecommerce
An E-commerce Web Application built using Ruby on Rails framework with MongoDB as database and Bcrypt for the user authentication.

Ruby on Rails (aka Rails) is one of the most popular web application framework in the planet. It is designed to eliminate much of the drudgery of writing typical web applications by providing default settings that eliminate most configuration code (“convention over configuration”) and by providing a rich set of utility functions that make most common tasks simple. With Ruby as its core programming language – it makes it so much easier to write robust web applications that will scale as you need them to and be easy to maintain as you go forward.

This simple e-commerce application demonstrates CRUD operations using mongoDB and a simple implementation of a cookie based user authentication using Bcrypt. I specifically built this application to serve as a default template for building medium to large-scaled e-commerce applications.

## Getting Setup:
1. Download or clone the project from Github
2. Open your terminal then navigate to where you installed mongoDB. In my case it’s located under C:/mongodb/
3. From the root directory of your mongodb installation, go to bin folder then run: mongod.exe to initialize the Mongodb database server
4. Open another terminal then navigate to where you extracted the project files.
5. Run bundle install to install all project dependencies.
6. Finally run: rails server to start the Web Server.
7. Open up your favorite browser then go to http://127.0.0.1:3000

### Possible Installation issues:

1. If you are experiencing problems with SQLite3, follow instructions here: https://github.com/hwding/sqlite3-ruby-win, If still not working, and you are getting errors similar to bellow:
	* `require’: cannot load such file — sqlite3/sqlite3_native (LoadError)
	- Solution 1:
		1. Go to your rails app then open gemfile.lock
		2. Then look for the line “sqlite3” and change its version to the version you have installed in your computer.
		3. Then run bundle install
	- Solution 2:
		1. Go to C:\Ruby23-x64\lib\ruby\gems\2.3.0\specifications
		2. Look for: sqlite3-1.3.7.gemspec file then open it.
		3. Change s.require_paths=[“lib”] to s.require_paths= [“lib/sqlite3_native”]
2. If you’re getting error related to Bcrypt like the one bellow, follow the tutorial I created here: http://carlofontanos.com/setting-up-bcrypt-for-rails-on-windows/ 
	* C:/Ruby23-x64/lib/ruby/gems/2.3.0/gems/activesupport-4.0.0/lib/active_support/depen dencies.rb:228:in `require’: 126: The specified module could not be found. – C :/Ruby23-x64/lib/ruby/gems/2.3.0/gems/bcrypt-ruby-3.1.11-x64-mingw32/lib/bcrypt_ext.so (LoadError)
3. If the problem you are experiencing is not listed above – I suggest you get help on Stackoverflow.

## Current Versions
- Rails: 5.0.0.1
- MongoID: 6.0.0
- Bcrypt 3.1.11

## Pages Included:
- Home
- Login
- Register
- Account
- Add Product
- Edit Product
- Manage Products
- Product List
- Single Product View

## Contribution guidelines
If you are a developer and you would like to contribute to this project, please follow my guidelines bellow:
- ALWAYS start a new branch before making changes to the codes
- Pull requests directly to the master branch will be ignored!
- Use a git client, preferably Source Tree or you can use git commands from your terminal, your choice!
- Many smaller commits are better than one large commit. Edit your file(s), if the edit does not break the code with things like syntax errors, commit. It is easier to reconcile many smaller commits than one large commit.
- When your feature or bug fix is ready, perform a pull request and notify carl.fontanos@gmail.com that your code is ready for review on Github.