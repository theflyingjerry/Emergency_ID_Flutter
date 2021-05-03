import 'package:flutter/material.dart';
import 'package:emergency_contacts/personalClass.dart';
import 'package:emergency_contacts/contactClass.dart';
import 'package:emergency_contacts/initializer.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() => runApp(MaterialApp(home: MaxCard()));

class MaxCard extends StatefulWidget {
  @override
  _MaxCardState createState() => _MaxCardState();
}

class _MaxCardState extends State<MaxCard> {
  Map data = {};
  Map dataToPush = {};
  List emergencyDataList = [];
  JSONReader initializer = JSONReader();

  double heightDeterminer(int index, int length) {
    if (index == (length - 1)) {
      return 0.0;
    } else {
      return 15.0;
    }
  }

  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    PersonalClass selfInstance = data['PersonalClass'];
    List contactList = data['ContactList'];
    Map dataToPush = data['MapData'];
    selfInstance.checkIfBlank();
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Emergency Contact ID Card'),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
        elevation: 0,
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) async {
          if (details.delta.dx < -8) {
            dynamic result = await Navigator.pushNamed(context, '/settings',
                arguments: dataToPush);
            if (result['edited'] == true) {
              setState(() {
                selfInstance = result['PC'];
                contactList = result['CL'];
                dataToPush = result['MapData'];
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
                'MapData': dataToPush,
              };
              initializer.writeJSON(dataWrite);
              Phoenix.rebirth(context);
            }
          }
        },
        child: Scrollbar(
          isAlwaysShown: true,
          controller: _scrollController2,
          child: ListView(controller: _scrollController2, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(selfInstance.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.amberAccent[200],
                                letterSpacing: 1.0,
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Divider(height: 40.0, color: Colors.grey[800]),
                    Text('PERSONAL INFO',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.grey[200],
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0)),
                    SizedBox(height: 15.0),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 250),
                      child: Scrollbar(
                        isAlwaysShown: false,
                        controller: _scrollController,
                        child: ListView(
                          controller: _scrollController,
                          shrinkWrap: true,
                          children: [
                            Text('Medical Issues:',
                                style: TextStyle(
                                    color: Colors.grey, letterSpacing: 2.0)),
                            SizedBox(height: 10.0),
                            Text(selfInstance.medicalIssues,
                                style: TextStyle(
                                    color: Colors.amberAccent[200],
                                    letterSpacing: 2.0,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 15.0),
                            Text('Allergies:',
                                style: TextStyle(
                                    color: Colors.grey, letterSpacing: 2.0)),
                            SizedBox(height: 10.0),
                            Text(selfInstance.allergies,
                                style: TextStyle(
                                    color: Colors.amberAccent[200],
                                    letterSpacing: 2.0,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 15.0),
                            Text('DATE OF BIRTH:',
                                style: TextStyle(
                                    color: Colors.grey, letterSpacing: 2.0)),
                            SizedBox(height: 10.0),
                            Text(selfInstance.dateOfBirth,
                                style: TextStyle(
                                    color: Colors.amberAccent[200],
                                    letterSpacing: 2.0,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 15.0),
                            Text('PHONE NUMBER:',
                                style: TextStyle(
                                    color: Colors.grey, letterSpacing: 2.0)),
                            SizedBox(height: 10.0),
                            Text(selfInstance.formatPhoneNumber(),
                                style: TextStyle(
                                    color: Colors.amberAccent[200],
                                    letterSpacing: 2.0,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 15.0),
                            TextButton(
                              onPressed: () {
                                selfInstance.emailMe(selfInstance.email);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.email,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(width: 10),
                                  Text(selfInstance.email,
                                      style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 18.0,
                                          letterSpacing: 1.0)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: 20.0, color: Colors.grey[800]),
                    Text('EMERGENCY INFO',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.grey[200],
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0)),
                    SizedBox(height: 25.0),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 245),
                      child: ListView.builder(
                          shrinkWrap: false,
                          itemCount: contactList.length,
                          itemBuilder: (context, index) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('CONTACT NAME:',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          letterSpacing: 2.0)),
                                  SizedBox(height: 5.0),
                                  Text(contactList[index].nameFirstLast,
                                      style: TextStyle(
                                          color: Colors.amberAccent[200],
                                          letterSpacing: 2.0,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 15.0),
                                  Text('CONTACT PHONE NUMBER:',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          letterSpacing: 2.0)),
                                  SizedBox(height: 5.0),
                                  TextButton(
                                    onPressed: () {
                                      contactList[index].callMe();
                                    },
                                    onLongPress: () {
                                      contactList[index].textMe(selfInstance
                                          .name
                                          .split(' ')
                                          .join('%20'));
                                    },
                                    child: Text(
                                        contactList[index].formatPhoneNumber(),
                                        style: TextStyle(
                                            color: Colors.amberAccent[200],
                                            letterSpacing: 2.0,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(
                                      height: heightDeterminer(
                                          index, contactList.length)),
                                ]);
                          }),
                    ),
                  ]),
            ),
          ]),
        ),
      ),
    );
  }
}
