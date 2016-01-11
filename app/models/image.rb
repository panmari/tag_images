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

  def shaded_path
    full_shaded_path
  end

  def albedo_path
    stem + 'albedo.png0001.png'
  end

  def depth_path
    stem + 'depth.png0001.png'
  end

  def normal_path
    stem + 'normal.png0001.png'
  end

  def sketch_path
    stem.gsub(IMAGE_FOLDER, SKETCH_FOLDER) + 'sketch.png'
  end
end
