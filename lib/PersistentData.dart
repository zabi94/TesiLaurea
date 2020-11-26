import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseInterface with ChangeNotifier {

  Future<Database> _db;
  bool ready = false;

  DatabaseInterface() {
    _db = getDatabasesPath()
        .then((path) => join(path, "imagetagger_galleryData.db"))
        .then((dbFilePath) => openDatabase(dbFilePath,
          version: 1,
          singleInstance: true,
          onCreate: (db, version) {
            db.execute("CREATE TABLE pictures ("
                "  picture_id INTEGER PRIMARY KEY,"
                "  fileRef TEXT NOT NULL,"
                "  uploadedTo TEXT,"
                "  description TEXT,"
                "  tags TEXT NOT NULL,"
                "  latitude REAL NOT NULL,"
                "  longitude REAL NOT NULL"
                ");"
            );
          },
        ));
  }

  Future<Null> addPicture(String _file, String description, List<String> tags, double latitude, double longitude) async {
    PictureRecord record = PictureRecord(_file, description, jsonEncode(tags), latitude, longitude);
    return _db.then((db) => db.insert("pictures", record.toMap()))
        .then((_) {notifyListeners();});
  }

  Future<List<PictureRecord>> getPendingUploads() async {
    return _db.then((db) => db.query("pictures", where: "uploadedTo == ''", ))
        .then((maps) => List.generate(maps.length, (i) => PictureRecord.fromDb(maps[i])));
  }

  Future<List<PictureRecord>> getCompletedUploads() async {

    return _db.then((db) => db.query("pictures", orderBy: "-rowid"))
        .then((maps) => List.generate(maps.length, (i) => PictureRecord.fromDb(maps[i])));
  }

  Future<Null> deletePicture(String file) {
    File f = File(file);

    return f.delete()
      .then((_) {
        _db.then((db) => db.delete("pictures", where: "fileRef = ?", whereArgs: [file]))
        .then((rows) {
          if (rows != 1) {
            throw "Tried to delete one file, but $rows rows were removed from the db";
          }
          notifyListeners();
        });
      });
  }

}

class PictureRecord {

  final int rowid;
  final String _filePath, uploadedTo, _description, _tagsJson;
  final double _lat, _lon;

  PictureRecord(this._filePath, this._description, this._tagsJson, this._lat, this._lon, {this.rowid = -1, this.uploadedTo = ""});

  Map<String, dynamic> toMap() {
    return {
      "fileRef": _filePath,
      "description": _description,
      "tags": _tagsJson,
      "latitude": _lat,
      "longitude": _lon
    };
  }

  static PictureRecord fromDb(Map<String, dynamic> map) {
    return PictureRecord(map['fileRef'], map['description'], map['tags'], map['latitude'], map['longitude'], rowid: map['rowid'], uploadedTo: map['uploadedTo']);
  }

  String getFilePath() {
    return _filePath;
  }

  String getJsonTags() {
    return _tagsJson;
  }

  String getDescription() {
    return _description;
  }

}