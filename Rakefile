desc "Run template with defaults"
task :test do
  system "rails new tmp/r3-test -m template.rb"
end

task :test_postgres do
  system "rails new tmp/pg-test -d postgresql -m template.rb"
end

task :default => :test
