module FileColumn
  class Railtie < Rails::Railtie
    initializer "file_column.initialization" do |app|
      app.config.before_initialize do 
        ::FileColumn::ClassMethods::DEFAULT_OPTIONS = {
          :root_path => File.join(Rails.root, "public"),
          :web_root => "",
          :mime_extensions => ::FileColumn::ClassMethods::MIME_EXTENSIONS,
          :extensions => ::FileColumn::ClassMethods::EXTENSIONS,
          :fix_file_extensions => true,
          :permissions => 0644,
          # path to the unix "file" executbale for
          # guessing the content-type of files
          :file_exec => "file" 
        }
        
        ActiveRecord::Base.send(:include, FileColumn)
        ActionView::Base.send(:include, FileColumnHelper)
        ActiveRecord::Base.send(:include, FileColumn::Validations)
      end
    end
  end
end
