module VIM
  Dirs = %w[ after autoload doc plugin ruby snippets syntax ftdetect ftplugin colors indent backup ]
end

directory "tmp"
VIM::Dirs.each do |dir|
  directory(dir)
end

def vim_plugin_task(name, repo=nil)
  cwd = File.expand_path("../", __FILE__)
  dir = File.expand_path("tmp/#{name}")
  subdirs = VIM::Dirs

  namespace(name) do
    if repo
      file dir => "tmp" do
        if repo =~ /git$/
          sh "git clone #{repo} #{dir}"

        elsif repo =~ /download_script/
          if filename = `curl --silent --head #{repo} | grep attachment`[/filename=(.+)/,1]
            filename.strip!
            sh "curl #{repo} > tmp/#{filename}"
          else
            raise ArgumentError, 'unable to determine script type'
          end

        elsif repo =~ /(tar|gz|vba|zip)$/
          filename = File.basename(repo)
          sh "curl #{repo} > tmp/#{filename}"

        else
          raise ArgumentError, 'unrecognized source url for plugin'
        end

        case filename
        when /zip$/
          sh "unzip -o tmp/#{filename} -d #{dir}"

        when /tar\.gz$/
          dirname  = File.basename(filename, '.tar.gz')

          sh "tar zxvf tmp/#{filename}"
          sh "mv #{dirname} #{dir}"

        when /vba(\.gz)?$/
          if filename =~ /gz$/
            sh "gunzip -f tmp/#{filename}"
            filename = File.basename(filename, '.gz')
          end

          # TODO: move this into the install task
          mkdir_p dir
          lines = File.readlines("tmp/#{filename}")
          current = lines.shift until current =~ /finish$/ # find finish line

          while current = lines.shift
            # first line is the filename (possibly followed by garbage)
            # some vimballs use win32 style path separators
            path = current[/^(.+?)(\t\[{3}\d)?$/, 1].gsub '\\', '/'

            # then the size of the payload in lines
            current = lines.shift
            num_lines = current[/^(\d+)$/, 1].to_i

            # the data itself
            data = lines.slice!(0, num_lines).join

            # install the data
            Dir.chdir dir do
              mkdir_p File.dirname(path)
              File.open(path, 'w'){ |f| f.write(data) }
            end
          end
        end
      end

      task :pull => dir do
        if repo =~ /git$/
          Dir.chdir dir do
            sh "git pull"
          end
        end
      end

      task :install => [:pull] + subdirs do
        Dir.chdir dir do
          if File.exists?("Rakefile") and `rake -T` =~ /^rake install/
            sh "rake install"
          elsif File.exists?("install.sh")
            sh "sh install.sh"
          else
            subdirs.each do |subdir|
              if File.exists?(subdir)
                sh "cp -RfL #{subdir}/* #{cwd}/#{subdir}/"
              end
            end
          end
        end

        yield if block_given?
      end
    else
      task :install => subdirs do
        yield if block_given?
      end
    end
  end

  desc "Install #{name} plugin"
  task name do
    puts
    puts "*" * 40
    puts "*#{"Installing #{name}".center(38)}*"
    puts "*" * 40
    puts
    Rake::Task["#{name}:install"].invoke
  end
  task :default => name
end

def skip_vim_plugin(name)
  Rake::Task[:default].prerequisites.delete(name)
end

vim_plugin_task "ack.vim",          "git://github.com/mileszs/ack.vim.git"
vim_plugin_task "nerdtree",         "git://github.com/wycats/nerdtree.git"
vim_plugin_task "nerdcommenter",    "git://github.com/ddollar/nerdcommenter.git"
vim_plugin_task "surround",         "git://github.com/tpope/vim-surround.git"
vim_plugin_task "yankring",         "http://www.vim.org/scripts/download_script.php?src_id=13554"
vim_plugin_task "jekyll",           "git://github.com/tedkulp/jekyll.vim.git"
vim_plugin_task "bufexplorer",      "http://www.vim.org/scripts/download_script.php?src_id=14208"
vim_plugin_task "cucumber",         "git://github.com/tpope/vim-cucumber.git"
vim_plugin_task "markdown",         "git://github.com/tpope/vim-markdown.git"
vim_plugin_task "indent_object",    "git://github.com/michaeljsmith/vim-indent-object.git"

vim_plugin_task "command_t",        "http://s3.wincent.com/command-t/releases/command-t-1.2.1.vba" do
  Dir.chdir "ruby/command-t" do
    if File.exists?("/usr/bin/ruby1.8") # prefer 1.8 on *.deb systems
      sh "/usr/bin/ruby1.8 extconf.rb"
    elsif File.exists?("/usr/bin/ruby") # prefer system rubies
      sh "/usr/bin/ruby extconf.rb"
    elsif `rvm > /dev/null 2>&1` && $?.exitstatus == 0
      sh "rvm system ruby extconf.rb"
    end
    sh "make clean && make"
  end
end

vim_plugin_task "desert256" do
  sh "curl http://www.vim.org/scripts/download_script.php?src_id=4055 > colors/desert256.vim"
end

desc "Update the documentation"
task :update_docs do
  puts "Updating VIM Documentation..."
  system "vim -e -s <<-EOF\n:helptags ~/.vim/doc\n:quit\nEOF"
end

desc "link vimrc to ~/.vimrc"
task :link_vimrc do
  %w[ vimrc gvimrc ].each do |file|
    dest = File.expand_path("~/.#{file}")
    unless File.exist?(dest)
      ln_s(File.expand_path("../#{file}", __FILE__), dest)
    end
  end
end

task :clean do
  system "git clean -dfx"
end

desc "Pull the latest"
task :pull do
  system "git pull"
end

task :default => [
  :update_docs,
  :link_vimrc
]

desc "Clear out all build artifacts and rebuild the latest Janus"
task :upgrade => [:clean, :pull, :default]

