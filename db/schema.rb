Sequel.migration do
  change do
    create_table(:page_views) do
      primary_key :id, :type=>"int(11)"
      column :url, "varchar(255)", :null=>false
      column :referrer, "varchar(255)"
      column :hash, "varchar(255)", :null=>false
      column :created_at, "datetime", :null=>false
      column :creation_date, "date", :null=>false
      
      index [:url, :creation_date]
      index [:url, :referrer]
    end
    
    create_table(:schema_migrations) do
      column :filename, "varchar(255)", :null=>false
      
      primary_key [:filename]
    end
  end
end
Sequel.migration do
  change do
    self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20150302190145_create_page_views.rb')"
  end
end
