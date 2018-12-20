# README

This is a project created for the sake of understanding
Programming Languages and related concepts/topics better.
We have created a Ruby on Rails server for the sake of
developing an algorithm blur an image based on the z-depth
of its pixels. Currently it is still in development.

ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]

TO DEPLOY:

1. Make sure you have Ruby running on your computer, with Rails configured.
2. Run command "gem install chunky_png"
3. Clone this repository
4. Run command "rails server"
5. Navigate to "http://localhost:3000" and find our project (undeveloped for the most part!)

COMMON PROBLEMS:

For Mac Users using RVM, we had an issue with a Pending Migration Error. If this happens, run this command:

rake db:reset RAILS_ENV=development

It should reset the database and set your environment to development so that the schema is not changed.
