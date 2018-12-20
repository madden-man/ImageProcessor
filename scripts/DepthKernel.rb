#This kernen does not require notmalization because it acts as an identty for the filter kernel
require 'chunky_png'
def makeDepthKernel(image, x, y, radius, threshold, falloffDist)
  width = image.width
  height = image.height
  kDim = (radius.ceil*2 + 1).ceil
  radius = radius.ceil
  kernel = Array.new(kDim) {Array.new(kDim,0)}
  z = ChunkyPNG::Color.g(image[x,y])
  for i in (0-radius ... (radius+1))
    if x+i>=0 && x+i<width #check for bounds
      for j in (0-radius ... (radius+1))
        if y+j>=0 && y+j<height #check for bounds
          cz = ChunkyPNG::Color.g(image[x+i,y+j])
          if (cz-z).abs < threshold
            weight = 1.0
          elsif (cz-z).abs - threshold < falloffDist
            weight = 1.0 - (((cz-z).abs - threshold) / falloffDist)
          else
            weight = 0.0
          end
          #puts weight
          kernel[j+radius][i+radius] = weight
        end
      end
    end
  end
  #puts kernel.length
  return kernel
end
