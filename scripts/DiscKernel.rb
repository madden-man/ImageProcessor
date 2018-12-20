require 'chunky_png'
#generates a disc-type kernel of radius r
def generateKernel(radius, writeKernel=false)
  r = radius

  kernelDim = (r.ceil*2 + 1).ceil
  center = r.ceil
  #puts kernelDim
  weightSum = 0
  filterKernel = Array.new(kernelDim) {Array.new(kernelDim,0)}
  for i in (0 ... kernelDim)
    for j in (0 ... kernelDim)
      dist = Math.sqrt((i-(center))**2+(j-(center))**2)
      if dist <= r
        weight = 1.0
      elsif (dist-r < 1.0) && (dist-r > 0.0)
        weight = 1 - (dist - r)
      else
        weight = 0.0
      end
      weightSum += weight
      filterKernel[i][j] = weight
    end
  end
  #puts weightSum
  #Normalize weights to conserve energy
  for i in (0 ... kernelDim)
    for j in (0 ... kernelDim)
      filterKernel[i][j] /= weightSum
    end
  end
  if writeKernel
    png = ChunkyPNG::Image.new(kernelDim,kernelDim,ChunkyPNG::Color.rgba(0,0,0,255))
    for x in (0 ... kernelDim)
      for y in (0 ... kernelDim)
        gs = ((filterKernel[y][x])*255*weightSum).round
        #puts gs
        png.set_pixel(x,y,ChunkyPNG::Color.rgb(gs,gs,gs))

      end
    end
    png.save("Disc.png", :fast_rgba)
  end
  return filterKernel
end

generateKernel(18.5,true)
