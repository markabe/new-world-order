NEW WORLD ORDER
===============

Rails 3 [Relevance][rel] Style.  This means the following:

* Rspec 2 for specs, with focused specs configured out of the box
* Cucumber for user level testing
* JQuery/JQuery-UI for javascript - Protoype/Scriptaculous removed
* Factory Girl for test data
* Mocha installed and configured for mocking inside RSpec
* Simple screen.css with a reset at the top

Getting Started
---------------

    rails my-app -m http://github.com/relevance/new-world-order/raw/master/template.rb

To use your database of choice, use the built in `-d` switch to the `rails` command.  New World Order's generated Gemfile will properly respect your database of choice.  For Postgres, we reach into your database.yml and make the username `postgres` (instead of your application name, which the Rails generator does by default).

    rails my-postgres-app -d postgresql -m http://github.com/relevance/new-world-order/raw/master/template.rb

Feedback and Other Items
------------------------
* Check out the TODO list for our ideas
* Use Github [issues][issues] for bugs

[rel]: http://thinkrelevance.com "Relevance home page"
[issues]: http://github.com/relevance/new-world-order/issues