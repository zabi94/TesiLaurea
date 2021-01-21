class SqlQueries {
  static const String create_table_pictures = "CREATE TABLE pictures ("
      "  picture_id INTEGER PRIMARY KEY,"
      "  fileRef TEXT NOT NULL,"
      "  uploadedTo TEXT,"
      "  description TEXT,"
      "  tags TEXT NOT NULL,"
      "  latitude REAL NOT NULL,"
      "  longitude REAL NOT NULL"
      ");";

  static const String create_table_uploads = "CREATE TABLE uploads ("
      "  upload_id INTEGER PRIMARY KEY,"
      "  picture_id INTEGER NOT NULL REFERENCES pictures(picture_id),"
      "  filePath TEXT NOT NULL,"
      "  statusCode INTEGER NOT NULL,"
      "  server TEXT NOT NULL,"
      "  user TEXT NOT NULL,"
      "  result TEXT NOT NULL,"
      "  time TEXT NOT NULL"
      ");";

}