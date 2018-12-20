require 'chunky_png'

def blurPixel(x,y,radius, original)
  colors = []
  for i in (0-radius ... radius)
    if x+i>=0 && x+i<original.width #check for bounds
      for j in (0-radius ... radius)
        if y+j>=0 && y+j<original.height #check for bounds
          colors.push(original[x+i,y+j])
        end
      end
    end
  end
  finalRed = 0
  finalGreen = 0
  finalBlue = 0
  #puts colors
  for i in (0...colors.size())
    finalRed += ChunkyPNG::Color.r(colors[i])
    finalGreen += ChunkyPNG::Color.g(colors[i])
    finalBlue += ChunkyPNG::Color.b(colors[i])
  end
  finalRed/=colors.length()
  finalGreen/=colors.length()
  finalBlue/=colors.length()
  finalPixel = ChunkyPNG::Color.rgba(finalRed,finalGreen,finalBlue,255)
#  puts ChunkyPNG::Color.r(finalPixel)
#  puts ChunkyPNG::Color.g(finalPixel)
#  puts ChunkyPNG::Color.b(finalPixel)
  return finalPixel
end

original=ChunkyPNG::Image.from_file("Source.png")
#set the radius and number of iterations
radius = 3
iterations = 2
# Copy original image into a new frame buffer
frameBuffer01=original

frameBuffer02 = ChunkyPNG::Image.new(original.width, original.height)
for i in (0 ... iterations)
  for x in (0 ... original.width)
    for y in (0 ... original.height)
      frameBuffer02.set_pixel(x,y,blurPixel(x,y, radius, frameBuffer01))

    end
  end
  frameBuffer01 = frameBuffer02
end
#for i in (0...colors.size())
#  puts ChunkyPNG::Color.r(colors[i])
#  puts ChunkyPNG::Color.g(colors[i])
#  puts ChunkyPNG::Color.b(colors[i])
#end
frameBuffer02.save("out.png", :fast_rgba)

# puts ChunkyPNG::Color.r(frameBuffer01[0,10])

# frameBuffer01
