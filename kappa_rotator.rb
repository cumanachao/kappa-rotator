require 'mini_magick'

fps = ARGV[0].to_i
inputKappa = ARGV[1]
kappaName = inputKappa.split('.').first

for i in 0..fps
  kappa = MiniMagick::Image.open("#{inputKappa}")

  kappa.combine_options do |kappaToRotate|
    kappaToRotate.distort('SRT', "#{i*6}")
    kappaToRotate.background('transparent')
    kappaToRotate.virtual_pixel('transparent')
  end

  kappa.write ("#{i}.png")
end

MiniMagick::Tool::Convert.new do |convert|

  convert.dispose('previous')

  for i in 0..fps
    convert.delay('5')
    convert.page('+0+0', "#{i}.png")
  end

  convert.page('+0+0', '1.png') # Trucazo

  convert.loop('0')

  convert << "rolling_#{kappaName}.gif"
end
