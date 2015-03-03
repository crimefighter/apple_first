Sequel.migration do
  change do

    create_table :page_views do
      primary_key :id
      String :url, null: false
      String :referrer, null: true
      String :hash, null: false
      DateTime :created_at, null: false
      Date :creation_date, null: false

      index [:url, :creation_date]
      index [:url, :referrer]
    end

  end
end
