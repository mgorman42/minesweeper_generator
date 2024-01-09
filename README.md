# README

Test project for generating minesweeper boards

* Ruby version: ruby 3.2.2

* Database: Postgres

* Database initialization
	* rails db:create db:migrate

* How to run the test suite
	* rails test

* Heroku Deployment instructions
	* `heroku apps:create`
	* `heroku addons:create heroku-postgresql:mini`
	* `git push heroku main`
	* `heroku run rake db:migrate`
	* `heroku ps:scale web=1`
	* `heroku open`
