require 'chunky_png'
require_relative 'DiscKernel'
def convolvePixel(image, x, y, kernel)
  kDim = kernel.length() #7
  radius = (kDim/2).floor #3
  width = image.width
  height = image.height
  colR = 0.0
  colG = 0.0
  colB = 0.0
  #puts kDim
  for i in (0-radius ... (radius+1))
    if x+i>=0 && x+i<width #check for bounds
      for j in (0-radius ... (radius+1))
        if y+j>=0 && y+j<height #check for bounds
          colR += ChunkyPNG::Color.r(image[x+i,y+j]) * kernel[i][j]
          colG += ChunkyPNG::Color.g(image[x+i,y+j]) * kernel[i][j]
          colB += ChunkyPNG::Color.b(image[x+i,y+j]) * kernel[i][j]
        end
      end
    end
  end
  finalCol = ChunkyPNG::Color.rgba(colR.round,colG.round,colB.round,255)
  return finalCol
end

original=ChunkyPNG::Image.from_file("Source.png")
#set the radius
radius = 3
# Copy original image into a new frame buffer
frameBuffer01=original

kernel = generateKernel(radius)

#puts "Made Kernel"
#custom filter shape
#kernel = [[0,0.0,0],[0.0,1.0,0.0],[0.0,0.0,0.0]]
#frameBuffer02 = ChunkyPNG::Image.new(original.width, original.height)
totalPixels = (original.width*original.height).to_f
processedPixels = 0
update = 0
for x in (0 ... original.width)
  for y in (0 ... original.height)
    frameBuffer01.set_pixel(x,y,convolvePixel(frameBuffer01, x, y, kernel))
    processedPixels+=1
    update += 1
    #display progress every 100 pixels
    if update%100 == 1
      percent = ((processedPixels/totalPixels).round(4))*100
      puts "#{percent}%"
    end
  end
end
puts "Complete"
#  frameBuffer01 = frameBuffer02

#for i in (0...colors.size())
#  puts ChunkyPNG::Color.r(colors[i])
#  puts ChunkyPNG::Color.g(colors[i])
#  puts ChunkyPNG::Color.b(colors[i])
#end
frameBuffer01.save("out04.png", :fast_rgba)

# puts ChunkyPNG::Color.r(frameBuffer01[0,10])

# frameBuffer01
