# frozen_string_literal: true

# Create seeds data for env:development
module DevelopmentSeeds
  require 'factory_bot_rails'

  FactoryBot.definition_file_paths = [Rails.root.join('spec', 'factories')]
  FactoryBot.reload

  @table_names = %w[settings articles tags comments]

  module_function

  def create
    @table_names.each do |table_name|
      path = Rails.root.join 'db/seeds', Rails.env, "#{table_name}.rb"
      if File.exist?(path)
        puts "Creating #{table_name}..."
        require path
      end
    end
  end
end

unless Setting.find_by id: 1
  Setting.create! site_title: 'Sample App',
                  anable_main_cover: false,
                  anable_recent_comments: false,
                  anable_recent_popular: false,
                  recent_popular_span: 7
end

DevelopmentSeeds.create if Rails.env.development?
