import 'package:emergency_contacts/personalClass.dart';
import 'package:emergency_contacts/contactClass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:emergency_contacts/initializer.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  PersonalClass selfInstance;
  List contactList = [];
  List emergencyDataList = [];
  JSONReader initializer = JSONReader();
  void setUpStuff() async {
    await initializer.isItThere();
    if (initializer.fileExists == false) {
      await Future.delayed(Duration(seconds: 1));
      Map data = {
        'Name': 'N/A',
        'Date of birth': 'N/A',
        'Phone number\neg. 8779703921': 'N/A',
        'Allergies\nIf multiple seperate with comma': 'N/A',
        'Medical issues\nIf multiple seperate with comma': 'N/A',
        'Email address': 'N/A',
        'Emergency Contact 1 Name': 'N/A',
        'Emergency Contact 1 - Phone Number\neg. 8779703921': 'N/A',
        'Emergency Contact 2 Name': 'N/A',
        'Emergency Contact 2 - Phone Number\neg. 8779703921': 'N/A'
      };
      dynamic result =
          await Navigator.pushNamed(context, '/settings', arguments: data);
      setState(() {
        selfInstance = result['PC'];
        contactList = result['CL'];
        data = result['MapData'];
      });
      for (ContactInformation entry in contactList) {
        emergencyDataList.add(entry.nameFirstLast);
        emergencyDataList.add(entry.phoneNumber);
      }

      Map<String, dynamic> dataWrite = {
        'PersonalClass': [
          selfInstance.name,
          selfInstance.dateOfBirth,
          selfInstance.allergies,
          selfInstance.medicalIssues,
          selfInstance.phoneNumber,
          selfInstance.email
        ],
        'ContactList': emergencyDataList,
        'MapData': data
      };
      initializer.writeJSON(dataWrite);
    }
    Map dataRead = await initializer.readJSON();
    await Future.delayed(Duration(milliseconds: 5));
    Navigator.pushReplacementNamed(context, '/home',
        arguments: initializer.dataChanger(dataRead));
  }

  @override
  void initState() {
    super.initState();
    setUpStuff();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: (Center(
            child: SpinKitPumpingHeart(
          color: Colors.red,
          size: 50.0,
        ))));
  }
}
