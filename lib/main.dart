import 'package:flutter/material.dart';
import 'package:emergency_contacts/home.dart';
import 'package:emergency_contacts/loadingSettings.dart';
import 'package:emergency_contacts/loading.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() {
  runApp(
    Phoenix(
      child: MaterialApp(initialRoute: '/', routes: {
        '/': (context) => Loading(),
        '/settings': (context) => Settings(),
        '/home': (context) => MaxCard(),
      }),
    ),
  );
}
