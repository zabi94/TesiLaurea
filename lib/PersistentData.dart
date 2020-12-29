import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tesi_simone_zanin_140833/upload_service/UploadJob.dart';

class DatabaseInterface with ChangeNotifier {

  static DatabaseInterface _instance;

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

  static DatabaseInterface get instance {
    if (_instance == null) {
      _instance = DatabaseInterface();
    }
    return _instance;
  }

  Future<PictureRecord> addPicture(String _file, String description, List<String> tags, double latitude, double longitude) async {
    PictureRecord record = PictureRecord(_file, description, jsonEncode(tags), latitude, longitude);
    return _db.then((db) => db.insert("pictures", record.toMap()))
        .then((_) {notifyListeners();})
        .then((value) => record);
  }

  Future<List<PictureRecord>> getPendingUploads() async {
    return _db.then((db) => db.query("pictures", where: "ifnull(uploadedTo, '') = ''", ))
        .then((maps) => List.generate(maps.length, (i) => PictureRecord.fromDb(maps[i])));
  }

  Future<List<PictureRecord>> getCompletedUploads() async {
    return _db.then((db) => db.query("pictures", orderBy: "-rowid", where: "ifnull(uploadedTo, '') != ''"))
        .then((maps) => List.generate(maps.length, (i) => PictureRecord.fromDb(maps[i])));
  }

  Future<PictureRecord> getByPath(String path) {
    return _db.then((db) => db.query("pictures", limit: 1, where: "fileRef = ?", whereArgs: [path])
        .then((maps) => List.generate(maps.length, (i) => PictureRecord.fromDb(maps[i])))
        .then((list) => list.isEmpty ? Future.error("Not found") : Future.value(list[0]))
    );
  }

  Future<List<PictureRecord>> getAllPictures() async {
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

  Future<bool> complete(UploadJob j, String destination) {
    return _db.then(
            (db) => db.update(
              "pictures",
              {"uploadedTo": destination},
              where: "fileRef = ?",
              whereArgs: [j.file]
            ).then((rows) {
              print("Updated $rows rows");
              return rows > 0;
            })
    ).whenComplete(() => notifyListeners()).whenComplete(() => print("Updated entry ${j.file}"));
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

  List<Widget> getChipTags() {
    var tags = jsonDecode(getJsonTags());
    var result = <Widget>[];
    for (int i = 0; i < tags.length; i++) {
      String s = tags[i].toString();
      result.add(Chip(label: Text(s)));
    }
    return result;
  }

  Text getTextDescription() {
    if (_description.isNotEmpty) return Text(_description);
    return Text("Nessuna descrizione", style: TextStyle(fontStyle: FontStyle.italic),);
  }

  double getLatitude() {
    return _lat;
  }

  double getLongitude() {
    return _lon;
  }

}