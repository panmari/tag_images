class Image < ActiveRecord::Base
  acts_as_taggable

  AVAILABLE_ROTATIONS = ['000', '012', '024', '036', '048', '060', '072', '084', '096', '108', '120', '132', '144',
                         '156', '168', '180', '192', '204', '216', '228', '240', '252', '264', '276', '288', '300',
                         '312', '324', '336', '348']

  def shapenet_identifier
    self.path.split('/')[0]
  end

  def stem(rotation='000')
    self.path.gsub('64x64.png', '').gsub('r_000', "r_#{rotation}")
  end

  def full_shaded_path(rotation='000')
    self.path.gsub('_64x64', '').gsub('r_000', "r_#{rotation}")
  end

  def shaded_path(size=nil, rotation='000')
    stem(rotation)[0..-2] + suffix_from(size)
  end

  def albedo_path(size=nil, rotation='000')
    stem(rotation) + 'albedo.png0001' + suffix_from(size)
  end

  def depth_path(size=nil, rotation='000')
    stem(rotation) + 'depth.png0001' + suffix_from(size)
  end

  def normal_path(size=nil, rotation='000')
    stem(rotation) + 'normal.png0001' + suffix_from(size)
  end

  def sketch_path(size=nil, rotation='000')
    stem(rotation).gsub(IMAGE_FOLDER, SKETCH_FOLDER) + 'sketch' + suffix_from(size)
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
