# popularable

Add management for ordering your models by a historical popularity value.

## Installation

    gem 'popularable'

    $ bundle install
    $ bundle exec rails g popularable:install
    $ bundle exec rake db:migrate

## Usage

    class Widget < ActiveRecord::Base
      include Popularable::Concern
      
      
    widget.first.bump_popularity!