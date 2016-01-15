require 'find'
require 'parallel'
require_relative 'image_helpers'

namespace :db do
  desc 'Importes images.'
  task :import_images => :environment do

    Find.find(IMAGE_FOLDER) do |path|
      if path =~ /r_000_64x64.png$/
        Image.create!(path: path.gsub(IMAGE_FOLDER, ''))
      end
    end
  end

  desc 'Tasks all gray only images as such'
  task :tag_default_material_images => :environment do
    Parallel.each(Image.all, progress: 'Tagging', :in_threads => 0) do |image|
      # If first is solid gray and others some shade of gray, then we tag it as default only.
      if with_default_material_only?(IMAGE_FOLDER + image.albedo_path)
        ActiveRecord::Base.connection_pool.with_connection do
          image.tag_list << 'Default material only'
          image.save!
        end
      end
    end
    puts "Tagged #{Image.tagged_with('Default material only').count} of #{Image.count}"
  end

  desc 'Dumps names of all images tagged as ok to files'
  task :export_images => :environment do
    size = 64
    File.open('ok_shaded_images.txt', 'w') do |f_shaded|
      File.open('ok_albedo_images.txt', 'w') do |f_albedo|
        File.open('ok_depth_images.txt', 'w') do |f_depth|
          File.open('ok_normal_images.txt', 'w') do |f_normal|
            File.open('ok_sketch_images.txt', 'w') do |f_sketch|             
              Image.tagged_with('Ok').order(:path).find_each do |img|
                f_shaded.puts(IMAGE_FOLDER + img.shaded_path(size))
                f_albedo.puts(IMAGE_FOLDER + img.albedo_path(size))
                f_depth.puts(IMAGE_FOLDER + img.depth_path(size))
                f_normal.puts(IMAGE_FOLDER + img.normal_path(size))
                f_sketch.puts(SKETCH_FOLDER + img.sketch_path(size))            
              end
            end
          end
        end
      end
    end
  end
end
