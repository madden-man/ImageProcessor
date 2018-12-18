def sobel(a)
	gx=[[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]]
	gy=[[-1, -2, -1], [0, 0, 0], [1, 2, 1]]
	
	rows = a.length
	columns = a[0].length
	mag = Array.new(rows)
	for i in 0..rows-1
		mag[i] = Array.new(columns)
	end

	for i in 0..rows-3
		for j in 0..columns-3
			s1 = gx[0][0] + a[i][i] + gx[0][1] + a[i][i + 1] + gx[0][2] + a[i][i + 2]
			s1 += gx[1][0] + a[i + 1][i] + gx[1][1] + a[i + 1][i + 1] + gx[1][2] + a[i + 1][i + 2]
			s1 += gx[2][0] + a[i + 2][i] + gx[2][1] + a[i + 2][i + 1] + gx[2][2] + a[i + 2][i + 2]

			s2 = gy[0][0] + a[i][i] + gy[0][1] + a[i][i + 1] + gy[0][2] + a[i][i + 2]
			s2 += gy[1][0] + a[i + 1][i] + gy[1][1] + a[i + 1][i + 1] + gy[1][2] + a[i + 1][i + 2]
			s2 += gy[2][0] + a[i + 2][i] + gy[2][1] + a[i + 2][i + 1] + gy[2][2] + a[i + 2][i + 2]

			mag[i+1][j+1] = Math.sqrt(s1**2 + s2**2)
		end
	end
	
	threshold = 70
	output_image = max(mag,threshold)

	output_image = Array.new(rows)
	for i in 0..rows-1
		maxForRow = a[i].max
		if (maxForRow > threshold)
			output_image[i] = threshold
		else
			output_image[i] = maxForRow
		end
	end

	for i in 0..rows-1
		if (output_image[i]==round(threshold))
			output_image[i] = 0
		end
	end

	return output_image
end
