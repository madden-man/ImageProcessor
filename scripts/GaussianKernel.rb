require 'chunky_png'
init = 2
#r = Math.sqrt((init**2-1)/12.0)
r = Math.sqrt((init**2-1)/12)/2
if r==0
  r=init
end

rs = (r * 6 -1).ceil #significant radius
kernelDim = rs*2 + 1
puts kernelDim
val = 0
weightSum = 0
kernel = Array.new(kernelDim) {Array.new(kernelDim,0)}
for i in (0 ... kernelDim)
  for j in (0 ... kernelDim)
    dist = (i-rs)*(i-rs)+(j-rs)*(j-rs)
    weight = Math.exp( (-dist / (2*r*r)) / (3.14159 *2*r*r))
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
png.save("Kernel.png", :fast_rgba)
