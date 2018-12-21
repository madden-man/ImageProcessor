# README

By Brendan Forde and Tommy Madden
forde101@mail.chapman.edu
madde120@mail.chapman.edu

This is a project created for the sake of understanding
Programming Languages and related concepts/topics better.
We have created a Ruby on Rails server for the sake of
developing an algorithm blur an image based on the z-depth
of its pixels. The algorithm as originally concieved is complete,
but there are some artifacts that were not accounted for.

ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]

TO DEPLOY MintZBlur:
1. Run command "gem install chunky_png"
2. Navigate to the scripts folder
3. run "ruby main.rb"
4. This will open up the configuration tool
5. it will ask if you want to load the default configuration, enter 'd' for default config
6. Option 8 will write a png file showing the current focal plane, option 3 will let you change the focal plane
7. You may mess around with 5 & 6, but leaving them at default will be ideal for the provided image
8. Option 4 will adjust the intensity of the effect.
9. Option 9 will run the ZBlur algorithm and output a new image, by default named "out.png"
10. Option 0 will exit the program giving you the opportunity to save a new config preset

Tips:
Keep most values between 0 and 255, as the png reader does not support values greater than this
Higher values for filter size take longer to process! O(n^2)
As long as all inputs are nominal, I haven't seen this crash during runtime

Artifacts:
Borders - I suspect this is caused by in kernel crop not working properly, though I haven't been able the find the source if the issue
Edges -  not sure what the source of this is
Pixel noise - I think the z-depth pass has some noise from the image compression which is causing irregular filter application across certain gradients 

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

