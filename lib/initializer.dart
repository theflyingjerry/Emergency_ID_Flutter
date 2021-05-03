import 'dart:io';
import 'package:emergency_contacts/contactClass.dart';
import 'package:emergency_contacts/personalClass.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class JSONReader {
  List contactList = [];
  String fileName = 'emergencyDataJSON';
  String stringJSON;
  Map<String, dynamic> jsonData = {};
  Map<String, dynamic> newData;
  File filePath;
  bool fileExists;
  JSONReader({this.newData});

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/$fileName');
  }

  void writeJSON(Map jsonInput) async {
    filePath = await localFile;
    stringJSON = jsonEncode(jsonInput);
    filePath.writeAsString(stringJSON);
  }

  Future<bool> isItThere() async {
    filePath = await localFile;
    fileExists = await filePath.exists();
    return fileExists;
  }

  Future<Map> readJSON() async {
    filePath = await localFile;
    fileExists = await filePath.exists();

    if (fileExists == true) {
      try {
        stringJSON = await filePath.readAsString();
        jsonData = jsonDecode(stringJSON);
      } catch (e) {
        print('Issue reading file: $e');
      }
    }

    return jsonData;
  }

  Map dataChanger(Map json) {
    PersonalClass instance1 = PersonalClass(
        name: json['PersonalClass'][0],
        dateOfBirth: json['PersonalClass'][1],
        allergies: json['PersonalClass'][2],
        medicalIssues: json['PersonalClass'][3],
        phoneNumber: json['PersonalClass'][4],
        email: json['PersonalClass'][5]);
    for (int i = 0; i < json['ContactList'].length; i = i + 2) {
      contactList.add(ContactInformation(
          nameFirstLast: json['ContactList'][i],
          phoneNumber: json['ContactList'][i + 1]));
    }
    return {
      'PersonalClass': instance1,
      'ContactList': contactList,
      'MapData': json['MapData']
    };
  }
}
