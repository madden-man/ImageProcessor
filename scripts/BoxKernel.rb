require 'chunky_png'
def max(a,b)
  if a>b
    return a
  else
    return b
  end
end

r = 10

kernelDim = (r * 2 + 3).ceil #significant radius
puts kernelDim
val = 0
weightSum = 0
kernel = Array.new(kernelDim) {Array.new(kernelDim,0)}
for i in (0 ... kernelDim)
  for j in (0 ... kernelDim)
    if (i == 0 || i == kernelDim-1) || (j == 0 || j == kernelDim-1)
      weight = 0.0
    else
      weight = 1.0
    end
    weightSum += weight
    kernel[i][j] = weight
  end
end
png = ChunkyPNG::Image.new(kernelDim,kernelDim,ChunkyPNG::Color.rgba(0,0,0,255))
for x in (0 ... kernelDim)
  for y in (0 ... kernelDim)
    gs = ((kernel[y][x])*255).round
    puts gs
    png.set_pixel(x,y,ChunkyPNG::Color.rgb(gs,gs,gs))

  end
end
png.save("BoxKernel5.png", :fast_rgba)
