import 'package:flutter/material.dart';
import 'package:emergency_contacts/personalClass.dart';
import 'package:emergency_contacts/contactClass.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Map data = {};
  int i = 2;
  PersonalClass selfInstance;
  List contactList = [];
  List phones = [2, 7, 9, 11, 13];
  Map keys = {};
  Map controllers = {};
  bool isEdited = false;

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    List titleList = data.keys.toList();
    generateKeys();
    List keysList = keys.values.toList();
    List controllerList = controllers.values.toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text('Enter Information'),
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            simplifyData();
            Navigator.pop(context, {
              'PC': selfInstance,
              'CL': contactList,
              'edited': isEdited,
              'MapData': data
            });
          },
        ),
      ),
      body: Padding(
          padding: EdgeInsets.fromLTRB(6, 12, 6, 0),
          child: ListView.builder(
              itemCount: titleList.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) async {
                        if (details.delta.dx < -8 && index > 9) {
                          setState(() {
                            data.remove(titleList[index]);
                            if (index % 2 == 0) {
                              data.remove(titleList[index + 1]);
                            } else {
                              data.remove(titleList[index - 1]);
                            }
                          });
                        }
                      },
                      child: Card(
                        color: Colors.grey[200],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                titleList[index],
                                style: TextStyle(
                                    letterSpacing: 1.5,
                                    fontSize: 18,
                                    color: Colors.grey[900]),
                                textAlign: TextAlign.left,
                              ),
                              Form(
                                key: keysList[index],
                                child: Container(
                                  width: 300,
                                  child: TextFormField(
                                      style: TextStyle(color: Colors.grey[850]),
                                      decoration: InputDecoration(
                                          hintText: data[titleList[index]]),
                                      controller: controllerList[index],
                                      validator: (text) {
                                        String toSendString = text.trim();
                                        if (toSendString == null ||
                                            toSendString.isEmpty) {
                                          return 'Text is empty';
                                        }
                                        if (phones.contains(index) &&
                                            toSendString.length < 10) {
                                          return 'Enter a 10 digit phone number';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      onFieldSubmitted: (String value) {
                                        if (keysList[index]
                                            .currentState
                                            .validate()) {
                                          setState(() {
                                            data[titleList[index]] = value;
                                            isEdited = true;
                                          });
                                        }
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
              })),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[850],
        child: Icon(Icons.add),
        onPressed: () {
          if (i < 4) {
            setState(() {
              i = i + 1;
              data['Emergency Contact $i Name'] = 'N/A';
              data['Emergency Contact $i - Phone Number\neg. 8779703921'] =
                  'N/A';
            });
          }
        },
      ),
    );
  }

  void simplifyData() {
    selfInstance = PersonalClass(
        name: data['Name'],
        dateOfBirth: data['Date of birth'],
        phoneNumber: data['Phone number\neg. 8779703921'],
        email: data['Email address'],
        medicalIssues: data['Medical issues\nIf multiple seperate with comma'],
        allergies: data['Allergies\nIf multiple seperate with comma']);
    List keysList = data.keys.toList();
    int length = keysList.length;
    for (int j = (length - (2 * i)); j < length; j = j + 2) {
      if (data[keysList[(j)]] != 'N/A') {
        contactList.add(ContactInformation(
            nameFirstLast: data[keysList[(j)]],
            phoneNumber: data[keysList[(j + 1)]]));
      }
    }

    if (contactList.isEmpty) {
      contactList.add(ContactInformation(
          nameFirstLast: 'Police Emergency', phoneNumber: '911'));
    }
  }

  void generateKeys() {
    for (int k = 0; k < data.length; k++) {
      keys['keys$k'] = GlobalKey<FormState>();

      controllers['keys$k'] = TextEditingController();
    }
  }
}
