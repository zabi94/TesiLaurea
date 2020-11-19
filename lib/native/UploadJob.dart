import 'dart:convert';

class UploadJob {

  static final JsonEncoder _jenc = JsonEncoder();

  String _imageBase64;
  List<String> _tags;
  String _description;
  double _latitude;
  double _longitude;

  UploadJob(this._imageBase64, this._tags, this._description, this._latitude, this._longitude);

  String getAsJson() {
    Map<String, dynamic> jsonRoot = {
      
      "imageBase64": _imageBase64,
      "tags": _tags,
      "description": _description,
      "latitude": _latitude,
      "longitude": _longitude
      
    };
    return _jenc.convert(jsonRoot);
  }



}