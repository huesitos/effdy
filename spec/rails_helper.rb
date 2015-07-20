ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'database_cleaner'


#### Monkey Patch for Database Cleaner
#### It seems that the Mongo ruby driver depricated the remove_all method.
#### TODO: Get me out of here.
module Mongo
  class Collection
    class View
      def remove_all
        remove(0)
      end
    end
  end
end


RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    DatabaseCleaner[:mongoid].strategy = :truncation
    DatabaseCleaner[:mongoid].clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner[:mongoid].start
  end

  config.after(:each) do
    DatabaseCleaner[:mongoid].clean
  end

end
