namespace :freeze do
  desc "Freeze third-party gems to 'vendor'. Requires GEMS environment variable to be set or passed on command-line (space-delimited)."
  task :others => :environment do
    if ENV['GEMS'].blank?
      raise "Requires a 'GEMS' environment variable (space-delimited)."
    end
    puts "Freezing #{ENV['GEMS']}..."

    libraries = ENV['GEMS'].split
    require 'rubygems'
    require 'find'
  
    libraries.each do |library|
      begin
        library_gem = Gem.cache.search(library).sort_by { |g| g.version }.last
        puts "Freezing #{library} for #{library_gem.version}..."
  
        # TODO Add dependencies to list of libraries to freeze
        #library_gem.dependencies.each { |g| libraries << g  }
      
        folder_for_library = File.join("vendor", "#{library_gem.name}-#{library_gem.version}")
        system "cd vendor; gem unpack -v '#{library_gem.version}' #{library_gem.name};"
  
        # Copy files recursively to vendor so .svn folders are maintained
        Find.find(folder_for_library) do |original_file|
          destination_file = "./vendor/gems/#{library}/" + original_file.gsub(folder_for_library, '')
        
          if File.directory?(original_file)
            if !File.exist?(destination_file)
              Dir.mkdir destination_file
            end
          else
            File.copy original_file, destination_file
          end
        end
  
        rm_rf folder_for_library
      rescue
        raise "ERROR: Maybe you forgot to install the '#{library}' gem locally?"
      end
    end

  end
end