class VaclGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      # m.directory "lib"
      # m.template 'README', "README"
      m.migration_template 'migration:migration.rb', "db/migrate", {
        :assigns => vacl_local_assigns,
        :migration_file_name => "create_vacl"
      }
    end
  end

  private
  def vacl_local_assigns
    returning(assigns = {}) do
      assigns[:class_name] = "Vacl"
  end
end
