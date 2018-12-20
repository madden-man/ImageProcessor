def composeKernels(filterKernel, weightedKernel)
  kDim = filterKernel.length()
  outKernel = Array.new(kDim) {Array.new(kDim,0)}
  weightSum = 0
  for i in (0 ... kDim)
    for j in (0 ... kDim)
      weight = filterKernel[i][j]*weightedKernel[i][j]
      outKernel[i][j] = weight
      weightSum += weight
    end
  end
  for i in (0 ... kDim)
    for j in (0 ... kDim)
      outKernel[i][j] /= weightSum
    end
  end
  return outKernel
end
