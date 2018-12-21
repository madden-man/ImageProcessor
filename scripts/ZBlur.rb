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
def runZBlur(imageName, depthImageName, focalDepth, filterSize, depthThreshold, falloffDist,outFilename = "out.png")
  original=ChunkyPNG::Image.from_file(imageName)
  originalZ=ChunkyPNG::Image.from_file(depthImageName)
  #set the radius
  focusDist = focalDepth
  filterSize = filterSize #the maximum radius
  threshold = depthThreshold.to_f
  falloffDist = falloffDist.to_f
  # Copy original image into a new frame buffer
  frameBuffer01=original
  totalPixels = (original.width*original.height).to_f
  processedPixels = 0
  update = 0
  for x in (0 ... original.width)
    for y in (0 ... original.height)
      radius = ((focusDist - ChunkyPNG::Color.g(originalZ[x,y])).abs / 255.0)
      radius *= filterSize
      radius += 0.1
      filterKernel = makeFilterKernel(radius)
      depthKernel = makeDepthKernel(originalZ,x,y,radius,threshold,falloffDist)
      #writeKernelToImage(depthKernel, "DepthKernel") #debug
      finalKernel = composeKernels(filterKernel, depthKernel)
      #writeKernelToImage(finalKernel, "FinalKernel") #debug
      frameBuffer01.set_pixel(x,y,convolvePixel(frameBuffer01, x, y, finalKernel))
      #progress Report
      processedPixels+=1
      update += 1
      #display progress every 100 pixels
      if update%100 == 1
        percent = ((processedPixels/totalPixels).round(4))*100
        puts "#{percent}%"
      end
    end
  end
  frameBuffer01.save(outFilename, :fast_rgba)
  puts "Complete"
end

def focalPlaneSetup(imageName, depthImageName, focalDepth)
  original=ChunkyPNG::Image.from_file(imageName)
  originalZ=ChunkyPNG::Image.from_file(depthImageName)
  frameBuffer01=original
  for x in (0 ... original.width)
    for y in (0 ... original.height)
      r = ChunkyPNG::Color.r(original[x,y])
      g = ChunkyPNG::Color.g(original[x,y])
      b = ChunkyPNG::Color.b(original[x,y])
      if ChunkyPNG::Color.g(originalZ[x,y]) == focalDepth
        r *= 0.2
        g *= 1
        b *= 0.2
      elsif ChunkyPNG::Color.g(originalZ[x,y]) < focalDepth
        r *= 1
        g *= 0.2
        b *= 0.2
      else
        r *=0.2
        g *= 0.2
        b *= 1
      end
      r = r.round
      g = g.round
      b = b.round
      frameBuffer01.set_pixel(x,y,ChunkyPNG::Color.rgba(r,g,b,255))
    end
  end
  frameBuffer01.save("FocalPlaneSetup.png", :fast_rgba)
end

#runZBlur("345_beauty.png","345_z.png",180,8,3,12)
