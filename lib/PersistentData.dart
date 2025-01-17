import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tesi_simone_zanin_140833/Reference.dart';
import 'package:tesi_simone_zanin_140833/SqlQueries.dart';
import 'package:tesi_simone_zanin_140833/upload_service/UploadJob.dart';

class DatabaseInterface with ChangeNotifier {

  static DatabaseInterface _instance;

  Future<Database> _db;

  DatabaseInterface() {
    _db = getDatabasesPath()
        .then((path) => join(path, "imagetagger_galleryData.db"))
        .then((dbFilePath) => openDatabase(dbFilePath,
          version: 2,
          singleInstance: true,
          onCreate: (db, version) {
            db.execute(SqlQueries.create_table_pictures)
                .then((_) => print("Tabella pictures creata"))
                .then((_) => db.execute(SqlQueries.create_table_uploads))
                .then((_) => print("Tabella uploads creata"))
                .then((_) => print("Creazione DB completata, versione $version"));
          },
          onUpgrade: (db, oldVersion, newVersion) {
            print("Aggiornamento database da v$oldVersion a v$newVersion");

            Future.microtask(() {
              if (oldVersion < 2) {
                db.execute(SqlQueries.create_table_uploads)
                    .then((_) => print("Tabella uploads creata"));
              }
            }).then((_) => print("Update completato"));
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

  Future<PictureRecord> getByPath(String path) async {
    return _db.then((db) => db.query("pictures", limit: 1, where: "fileRef = ?", whereArgs: [path])
        .then((maps) => List.generate(maps.length, (i) => PictureRecord.fromDb(maps[i])))
        .then((list) {
          if (list.isEmpty) {
            throw "Not found";
          } else {
            return Future.value(list[0]);
          }
        })
    );
  }

  Future<PictureRecord> getByPictureId(int id) async {
    return _db.then((db) => db.query("pictures", where: "picture_id = ?", whereArgs: [id]))
        .then((resList) {
          if (resList.length == 0) {
            return Future.error("No picture with id $id");
          }
          return PictureRecord.fromDb(resList[0]);
    });
  }

  Future<List<PictureRecord>> getAllPictures() async {
    return _db.then((db) => db.query("pictures", orderBy: "-rowid"))
        .then((maps) => List.generate(maps.length, (i) => PictureRecord.fromDb(maps[i])));
  }

  Future<Null> deletePicture(String file) async {
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

  Future<bool> complete(UploadJob j, String destination) async {
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

class UploadRecord {
  
  int rowid, upload_id, picture_id, statusCode;
  String server, user, result;
  DateTime time;
  String filePath;

  UploadRecord(this.picture_id, this.server, this.user, this.filePath, {this.rowid = -1, this.upload_id = -1, this.result="Not attempted", this.statusCode = -1, this.time});

  bool isSuccessful() {
    return statusCode > 0 && statusCode ~/ 100 == 2;
  }
  
  Map<String, dynamic> toMap() {

    if (time == null || !(time is DateTime)) return {
      "picture_id": picture_id,
      "statusCode": statusCode,
      "server": server,
      "user": user,
      "result": result,
      "filePath": filePath,
      "time": DateTime(1970).toIso8601String()
    };

    return {
      "picture_id": picture_id,
      "statusCode": statusCode,
      "server": server,
      "user": user,
      "result": result,
      "filePath": filePath,
      "time": time.toIso8601String()
    };
  }

  static UploadRecord fromDb(Map<String, dynamic> map) {
    return UploadRecord(map['picture_id'], map['server'], map['user'], map['filePath'], result: map['result'], rowid: map['rowid'], upload_id: map['upload_id'], time: DateTime.tryParse(map['time']), statusCode: map['statusCode'],);
  }

}


class UploadListWatcher with ChangeNotifier {

  static UploadListWatcher _instance;

  static UploadListWatcher get instance {
    if (_instance == null) {
      _instance = UploadListWatcher();
    }
    return _instance;
  }

  void changed() {
    notifyListeners();
  }

  Future<List<UploadRecord>> getUploads() {
    return DatabaseInterface.instance._db
        .then((db) => db.query("uploads", orderBy: "-rowid"))
        .then((list) => list.map((e) => UploadRecord.fromDb(e)).toList());
  }

  Future<bool> logUploadAttempt(UploadRecord record) {
    return DatabaseInterface.instance._db
        .then((db) => db.insert("uploads", record.toMap()))
        .then((rows) => rows == 1)
        .whenComplete(() => notifyListeners());
  }

}


class PictureRecord {

  final int rowid, picture_id;
  final String _filePath, uploadedTo, _description, _tagsJson;
  final double _lat, _lon;

  PictureRecord(this._filePath, this._description, this._tagsJson, this._lat, this._lon, {this.rowid = -1, this.uploadedTo = "", this.picture_id = -1});

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
    return PictureRecord(map['fileRef'], map['description'], map['tags'], map['latitude'], map['longitude'], rowid: map['rowid'], uploadedTo: map['uploadedTo'], picture_id: map['picture_id']);
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

class SettingsInterface with ChangeNotifier {

  static SettingsInterface _instance;

  static SettingsInterface get instance {
    if (_instance == null) {
      _instance = SettingsInterface();
    }
    return _instance;
  }

  Future<String> getServer() async {
    return SharedPreferences.getInstance().then((prefs) => prefs.getString(Reference.prefs_server));
  }

  Future<String> getUser() async {
    return SharedPreferences.getInstance().then((prefs) => prefs.getString(Reference.prefs_username));
  }

  void changed() {
    notifyListeners();
  }

}