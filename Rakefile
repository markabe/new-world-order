task :test do
  # system "rm -rf tmp/r3-test"
  system "rails tmp/r3-test -m template.rb"
end

task :test_postgres do
  system "rails tmp/pg-test -d postgresql -m template.rb"
end

task :default => :test
