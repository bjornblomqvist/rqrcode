module RQRCode
  module Export
    module Blocks
      def as_blocks(options={})
        blocks = StringIO.new
        self.modules.each_index do |c|
          self.modules.each_index do |r|
            blocks << ( self.is_dark(c,r) ? '██' : '  ' )
          end

          blocks << "\n"
        end

        blocks.string
      end
    end
  end
end

RQRCode::QRCode.send :include, RQRCode::Export::Blocks
