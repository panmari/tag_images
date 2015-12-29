require 'find'

namespace :db do
  desc 'Importes images.'
  task :import_images => :environment do
    folder = '/home/mazzzy/Downloads/images'

    Find.find(folder) do |path|
      if path =~ /r_000_64x64.png$/
        Image.create!(path: path.gsub('/home/mazzzy/Downloads/images/', ''))
      end
    end
  end

  desc 'Create initial tags'
  task :import_tags => :environment do
    ['Ok', 'Two parts', 'Default material only', 'Strange normals'].each do |t|
      ActsAsTaggableOn::Tag.create!(name: t)
    end
  end
end
