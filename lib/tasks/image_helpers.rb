def with_default_material_only?(path, verbose=false)
  hist = `convert #{path} -colors 256 -depth 8 -format "%c" histogram:info:`
  puts(hist) if verbose
  bins = hist.split("\n").reject {|l| l.include? ('#00000000')} # Remove background bin
  # bins[0] # this is usually background, so white
  bins[0].include? ('#E7E7E7 ') and
      bins[1].include? ('#E7E7E7') and
      bins[2].include? ('#E7E7E7')
end
