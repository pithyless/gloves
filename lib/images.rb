require 'chunky_png'

class ScanMonocle
  def to_gray_monocle_chunky
    img = ChunkyPNG::Image.from_file(@filename)
    for y in 0...img.height do
      for x in 0...img.width do
        img[x, y] = color_to_gray(img[x,y])
      end
    end
    # fname = 'tmp_png/gray.png'
    # img.save(fname)
    @image_datastream = img.to_datastream.to_blob
  end

  private

  def color_to_gray(col)
    # TODO: ignores alpha; is this OK?
    (r,g,b) = ChunkyPNG::Color.to_truecolor_bytes(col)
    gray = (0.3*r + 0.59*g + 0.11*b).to_i
    # TODO: clasp!
    ChunkyPNG::Color.rgba(gray, gray, gray, 255)
  end
end


  # def to_gray_monocle
  #   # image = @image.deep_copy
  #   image.modify_each_pixel_rgb do |col|
  #     throw "#{gray} :: #{col.pretty}" if col.alpha == 0
  #   end
  #   GrayMonocle.new(image)
  # end
