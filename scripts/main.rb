require_relative 'ZBlur'
def main()
  puts "Welcome to the Mint ZBlur config!"
  puts "Would you like to load a custom configuration or the default one? [c/d]"
  input = gets.chomp
  if input == "c"
    puts "What is the name of the config you'd like to load?"
    settings = loadSettings(gets.chomp)
  elsif input == "d"
    settings = loadSettings("DefaultSettings.txt")
    puts "Loaded Default Settings"
  else
    puts "Invalid input, loading default settings"
  end
  imageFilename = settings[0].to_s.chomp
  depthImageFilename = settings[1].to_s.chomp
  focalDistance = settings[2].to_i
  filterSize = settings[3].to_f
  depthThreshold = settings[4].to_f
  falloffDist = settings[5].to_f
  outFilename = settings[6].to_s.chomp
  option = 0
  input = ""

  while option != -1
    printOptions()
    input = gets.chomp
    option = input.to_i
    puts ""
    case option
    when 1
      puts "What file would you like to read from? (RGB)"
      puts "Currently: #{imageFilename}"
      imageFilename = gets.chomp
    when 2
      puts "What file would you like to read from? (Z)"
      puts "Currently: #{depthImageFilename}"
      depthImageFilename = gets.chomp
    when 3
      puts "Option 8 - Display Focal Plane can help to set this value"
      puts "Currently: #{focalDistance}"
      puts "What is the focal depth? (What distance should be in focus?)"

      focalDistance = gets.chomp.to_i
    when 4
      puts "How large is the filter at max distance from the focal plane?\n(Larger values take longer to compute)"
      puts "Currently: #{filterSize}"
      filterSize = gets.chomp.to_f
    when 5
      puts "How deep until a neighboring pixel's influence begins to drop off?"
      puts "Currently: #{depthThreshold}"
      depthThreshold = gets.chomp.to_f
    when 6
      puts "How deep until a pixel's influence has fallen off completely?"
      puts "Currently: #{falloffDist}"
      falloffDist = gets.chomp.to_f
    when 7
      puts "What should the name of the output image be? (Remember to include the .png file extension!)"
      puts "Currently: #{outFilename}"
      outFilename = gets.chomp
    when 8
      puts "Writing focal plane setup to 'FocalPlaneSetup.png'"
      puts "Red is closer than focal plane, Green is the focal plane, and Blue is further than the focal plane."
      focalPlaneSetup(imageFilename, depthImageFilename, focalDistance)
    when 9
      runZBlur(imageFilename,depthImageFilename,focalDistance,filterSize,depthThreshold,falloffDist,outFilename)
    when 0
      puts "Would you like to save the current configuration? [y/n]"
      input = gets.chomp
      if input == "y"
        puts "What would you like to call this configuration?"
        input = gets.chomp
        File.open(input,"w+") do |line|
          line.puts imageFilename.to_s.chomp
          line.puts depthImageFilename.to_s.chomp
          line.puts focalDistance.to_s + "\n"
          line.puts filterSize.to_s + "\n"
          line.puts depthThreshold.to_s + "\n"
          line.puts falloffDist.to_s + "\n"
          line.puts outFilename.to_s.chomp
        end
        option = -1
      elsif input == "n"
        option = -1
      else
        puts "Please enter 'y' or 'n' to save config and exit"
        option = 0
      end
    when 11
      puts "What would you like to call this configuration?"
      input = gets.chomp
      File.open(input,"w+") do |line|
        line.puts imageFilename.to_s
        line.puts depthImageFilename.to_s
        line.puts focalDistance.to_s + "\n"
        line.puts filterSize.to_s + "\n"
        line.puts depthThreshold.to_s + "\n"
        line.puts falloffDist.to_s + "\n"
        line.puts outFilename.to_s
      end
      puts "Configuration saved as #{input}"
    when 12
      puts "Image Filename: #{imageFilename}"
      puts "Depth Image Filename: #{depthImageFilename}"
      puts "Focal Distance: #{focalDistance}"
      puts "Filter Size: #{filterSize}"
      puts "Depth Threshold: #{depthThreshold}"
      puts "Falloff Distance: #{falloffDist}"
      puts "Out Filename: #{outFilename}\n"
    end
  end
end
def printOptions()
  puts "\nPlease select an option below:"
  puts "0) Exit"
  puts "1) Image Filename\n2) Depth Image Filename\n3) Focal Distance"
  puts "4) Filter Size\n5) Depth Threshold\n6) Falloff Distance\n7) Out Filename"
  puts "8) Display Focal Plane\n9) Run Mint ZBlur w/ this Config"
  puts "11) Save Configuration\n12) Display Configuration Settings"
end
def loadSettings(settingsFilename)
  settings = []
  File.open(settingsFilename).each do |line|
    settings << line
  end
  return settings
end
def saveSettings(settingsFilename = "UserSettings.txt")
  File.open(settingsFilename,"w+") do |line|
    line.puts imageFilename.chomp.to_s +"\n"
    line.puts depthImageFilename.chomp.to_s +"\n"
    line.puts focalDistance.to_s +"\n"
    line.puts filterSize.to_s +"\n"
    line.puts depthThreshold.to_s +"\n"
    line.puts falloffDist.to_s +"\n"
    line.puts outFilename.chomp.to_s
  end
end

main() #runs the program itself
