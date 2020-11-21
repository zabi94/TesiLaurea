import 'dart:convert';

class UploadJob {

  static final JsonEncoder _jenc = JsonEncoder();

  String _imageFilePath;
  List<String> _tags;
  String _description;
  double _latitude;
  double _longitude;
  int _uploadId;

  UploadJob(this._uploadId, this._imageFilePath, this._tags, this._description, this._latitude, this._longitude);

  String getAsJson() {
    Map<String, dynamic> jsonRoot = {
      
      "imagePath": _imageFilePath,
      "tags": _tags,
      "description": _description,
      "latitude": _latitude,
      "longitude": _longitude,
      "uploadId": _uploadId
      
    };
    return _jenc.convert(jsonRoot);
  }



}