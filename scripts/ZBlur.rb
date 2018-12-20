require 'chunky_png'
require_relative 'DiscKernel'
require_relative 'ComposeKernels'
require_relative 'DepthKernel'
def writeKernelToImage(kernel, filename = "Kernel") #for debugging
  kDim = kernel.length
  out = ChunkyPNG::Image.new(kDim,kDim)
  for i in (0 ... kDim)
    for j in (0 ... kDim)
      val = ((kernel[j][i])*255).round
      #puts val
      out.set_pixel(i,j,ChunkyPNG::Color.rgba(val,val,val,255))
    end
  end
  filename << ".png"
  out.save(filename, :fast_rgba)
end
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

original=ChunkyPNG::Image.from_file("345_beauty.png")
originalZ=ChunkyPNG::Image.from_file("345_z.png")
#set the radius
focusDepth = ChunkyPNG::Color.g(originalZ[100,65])
filterSize = 24 #the maximum radius
# Copy original image into a new frame buffer
frameBuffer01=original


#puts "Made Kernel"

#frameBuffer02 = ChunkyPNG::Image.new(original.width, original.height)

totalPixels = (original.width*original.height).to_f
processedPixels = 0
update = 0
for x in (0 ... original.width)
  for y in (0 ... original.height)
    radius = ((focusDepth - ChunkyPNG::Color.g(originalZ[x,y])).abs / 255.0) * filterSize
    filterKernel = makeFilterKernel(radius)
    depthKernel = makeDepthKernel(originalZ,x,y,radius,3,12.0)
    #writeKernelToImage(depthKernel, "DepthKernel")
    finalKernel = composeKernels(filterKernel, depthKernel)
    #writeKernelToImage(finalKernel, "FinalKernel")


    frameBuffer01.set_pixel(x,y,convolvePixel(frameBuffer01, x, y, finalKernel))
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

frameBuffer01.save("TestOut24.png", :fast_rgba)
