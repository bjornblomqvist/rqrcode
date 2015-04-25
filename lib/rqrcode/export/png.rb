require 'chunky_png'

# This class creates PNG files.
# Code from: https://github.com/DCarper/rqrcode
module RQRCode
  module Export
    module PNG

      # Render the PNG from the Qrcode.
      #
      # Options:
      # fill                    - Background ChunkyPNG::Color, defaults to 'white'
      # color                   - Foreground ChunkyPNG::Color, defaults to 'black'
      # size/resize_exactly_to  - Total size of PNG, in pixels
      # border_modules          - Width of white border around the data portion of the code
      # file                    - Filepath of output PNG
      #
      def as_png(options = {})

        default_img_options = {
          :fill => 'white',
          :color => 'black',
          :size => 120,
          :border_modules => 4,
          :file => false
        }

        options = default_img_options.merge(options) # reverse_merge

        fill   = ChunkyPNG::Color(options[:fill])
        color  = ChunkyPNG::Color(options[:color])
        output_file = options[:file]

        total_image_size = options[:resize_exactly_to] || options[:size]
        border_modules = options[:border_modules]

        module_px_size = (total_image_size.to_f / (self.module_count + 2 * border_modules).to_f).floor.to_i

        img_size = module_px_size * self.module_count

        remaining = total_image_size - img_size
        border_px = (remaining / 2.0).floor.to_i

        png = ChunkyPNG::Image.new(total_image_size, total_image_size, fill)

        self.modules.each_index do |x|
          self.modules.each_index do |y|
            if self.dark?(x, y)
              (0...module_px_size).each do |i|
                (0...module_px_size).each do |j|
                  png[(y * module_px_size) + border_px + j , (x * module_px_size) + border_px + i] = color
                end
              end
            end
          end
        end

        if output_file
          png.save(output_file,{ :color_mode => ChunkyPNG::COLOR_GRAYSCALE, :bit_depth =>1})
        end
        png
      end

    end
  end
end

RQRCode::QRCode.send :include, RQRCode::Export::PNG
