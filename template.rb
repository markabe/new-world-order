run "rm public/index.html"

rake "db:create:all db:migrate"

git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"