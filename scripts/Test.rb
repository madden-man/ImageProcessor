require 'chunky_png'
require_relative 'DepthKernel'
=begin
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
  return finalPixel
end
=end
def writeKernelToImage(kernel) #for debugging
  kDim = kernel.length
  out = ChunkyPNG::Image.new(kDim,kDim)
  for i in (0 .. kDim)
    for j in (o ... kDim)
      val = (kernel[y][x]*255).round
      out.set_pixel(x,y,ChunkyPNG::Color.rgba(val,val,val,255))
    end
  end
  out.save("KernelOut.png", :fast_rgba)
end

original=ChunkyPNG::Image.from_file("345_z.png")
frameBuffer01 = ChunkyPNG::Image.new(101, 101)
kernel = makeDepthKernel(original,100,65,50,3,12.0)
=begin
frameBuffer02 = ChunkyPNG::Image.new(original.width, original.height)
for i in (0 ... iterations)
  for x in (0 ... original.width)
    for y in (0 ... original.height)
      frameBuffer02.set_pixel(x,y,ChunkyPNG::Color.rgba(x,0,y,255))

    end
  end
  frameBuffer01 = frameBuffer02
end
=end
for x in (0 ... 101)
  for y in (0 ... 101)
    val = (kernel[y][x]*255).round
    puts val
    frameBuffer01.set_pixel(x,y,ChunkyPNG::Color.rgba(val,val,val,255))

  end
end
frameBuffer01.save("DepthKernelTest.png", :fast_rgba)

# puts ChunkyPNG::Color.r(frameBuffer01[0,10])

# frameBuffer01
