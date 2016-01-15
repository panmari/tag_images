class Image < ActiveRecord::Base
  acts_as_taggable

  def shapenet_identifier
    self.path.split('/')[0]
  end

  def stem
    self.path.gsub('64x64.png', '')
  end

  def full_shaded_path(rotation='000')
    self.path.gsub('_64x64', '').gsub('r_000', "r_#{rotation}")
  end

  def shaded_path(size=nil)
    stem[0..-2] + suffix_from(size)
  end

  def albedo_path(size=nil)
    stem + 'albedo.png0001' + suffix_from(size)
  end

  def depth_path(size=nil)
    stem + 'depth.png0001' + suffix_from(size)
  end

  def normal_path(size=nil)
    stem + 'normal.png0001' + suffix_from(size)
  end

  def sketch_path(size=nil)
    stem.gsub(IMAGE_FOLDER, SKETCH_FOLDER) + 'sketch' + suffix_from(size)
  end

  private

  def suffix_from(size=nil)
    if size
      "_#{size}x#{size}.png"
    else
      '.png'
    end
  end
end
