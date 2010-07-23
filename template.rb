git :init
append_file '.gitignore', "vendor/bundler_gems\nconfig/database.yml\n"
run "cp config/database.yml config/database.example.yml"
git :add => "."
git :commit => "-a -m 'Initial commit'"

%W[Gemfile README doc/README_FOR_APP public/index.html public/images/rails.png].each do |path|
  run "rm #{path}"
end

run "rm -rf test"

file 'README.markdown', <<-EOL
# Welcome to #{app_name}

## Summary

#{app_name} is a .... TODO high level summary of app

## Getting Started

    gem install bundler
    # TODO other setup commands here
    
## Seed Data

Login as ....  # TODO insert typical test accounts for QA / devs to login to app as
EOL

file 'public/stylesheets/screen.css', <<-CODE
/*========================================================
	RESET HERE
========================================================*/
html, body, div, span, applet, object, iframe,
h1, h2, h3, h4, h5, h6, p, blockquote, pre,
a, abbr, acronym, address, big, cite, code,
del, dfn, em, font, img, ins, kbd, q, s, samp,
small, strike, strong, sub, sup, tt, var,
b, u, i, center,
dl, dt, dd, ol, ul, li,
fieldset, form, label, legend,
table, caption, tbody, tfoot, thead, tr, th, td {margin: 0; padding: 0; border: 0; outline: 0; font-size: 100%; vertical-align: baseline; background: transparent;}
body {line-height: 1;}
ol, ul {list-style: none;}
blockquote, q {quotes: none;}
blockquote:before, blockquote:after, q:before, q:after {content: ''; content: none;}
/* remember to define focus styles! */
:focus {outline: 0;}
/* remember to highlight inserts somehow! */
ins {text-decoration: none;}
del {text-decoration: line-through;}
/* tables still need 'cellspacing="0"' in the markup */
table {border-collapse: collapse; border-spacing: 0;}

CODE

# remove Prototype defaults
run "rm public/javascripts/controls.js"
run "rm public/javascripts/dragdrop.js"
run "rm public/javascripts/effects.js"
run "rm public/javascripts/prototype.js"

open("http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js") do |source|
  File.open("public/javascripts/jquery-1.4.2.min.js", 'w') {|f| f.write(source.read) }
end

open("http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.1/jquery-ui.min.js") do |source|
  File.open("public/javascripts/jquery-ui-1.8.1.min.js", 'w') {|f| f.write(source.read) }
end

gsub_file('app/views/layouts/application.html.erb','javascript_include_tag :defaults','javascript_include_tag :all' )

commit_message =<<EOC 
Remove defaults; add preferred JS and CSS:

  - replace Protoype with jquery & jquery-ui minified versions
  - add a simple CSS reset
  - add a README template to help devs get quick started
EOC
git :add => "."
git :commit => "-m '#{commit_message}'"

# Rails default generator uses 'app_name' as the username for postgresql -- that is dumb
# We replace that with 'postgres' which is a more common development configuration
if options[:database] == "postgresql"
  gsub_file 'config/database.yml', "username: #{app_name}", "username: postgres"
  git :commit => "-a -m 'Use postgres user for database.yml'"
end

file 'Gemfile', <<-CODE
source "http://rubygems.org"

gem "rails", "3.0.0.beta4"
CODE

unless options[:skip_activerecord]
  if require_for_database
    gem gem_for_database, :require => require_for_database
  else
    gem gem_for_database
  end
end

append_file 'Gemfile', <<-CODE

group "development" do
  gem "unicorn"
end

group "test" do
  gem "database_cleaner"
  gem "capybara"
  gem "cucumber-rails", :git => "http://github.com/aslakhellesoy/cucumber-rails.git"
  gem "factory_girl_rails", "1.0", :require => nil
  gem "mocha"
  gem "rspec", "~> 2.0.0.beta.17"
  gem "rspec-rails", "~> 2.0.0.beta.17"
  gem "test-unit"  
  gem "wirble"
  gem "hirb"
  gem "awesome_print"
end
CODE

run "bundle install"
git :add => "."
git :commit => "-a -m  'Initial gems setup'"

generate "rspec:install"
gsub_file 'spec/spec_helper.rb', "# config.mock_with :mocha", "config.mock_with :mocha"
gsub_file 'spec/spec_helper.rb', "config.mock_with :rspec", "# config.mock_with :rspec"
rspec_config =<<-CODE
  # Configure RSpec to run focused specs, and also respect the alias 'fit' for focused specs
  config.filter_run :focused => true
  config.run_all_when_everything_filtered = true
  config.alias_example_to :fit, :focused => true
  # Turn color on if we are NOT inside Textmate, Emacs, or VIM
  config.color_enabled = ENV.keys.none? { |k| k.include?("TM_MODE", "EMACS", "VIM") }
CODE

inject_into_file "spec/spec_helper.rb", rspec_config, :after => /Rspec.configure.*$/

git :add => "."
git :commit => "-a -m 'Rspec generated'"

generate "cucumber:skeleton", "--rspec", "--capybara"
git :add => "."
git :commit => "-a -m 'Cucumber generated'"

rake "db:create:all db:migrate"

say "All done!  Thanks for installing using the NEW WORLD ORDER"
