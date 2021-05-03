import 'package:url_launcher/url_launcher.dart';

class ContactInformation {
  String nameFirstLast;
  String phoneNumber;
  String phoneNumberDisplay;
  String nameForText;

  ContactInformation({this.nameFirstLast, this.phoneNumber});

  String nameToUri() {
    nameForText = nameFirstLast.split(' ').join('%20');
    return nameForText;
  }

  String formatPhoneNumber() {
    if (phoneNumber.length == 10) {
      phoneNumberDisplay =
          '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)} - ${phoneNumber.substring(6, 10)}';
    } else if (phoneNumber == '911') {
      phoneNumberDisplay = '911';
    } else {
      phoneNumberDisplay = phoneNumber;
    }
    return phoneNumberDisplay;
  }

  callMe() async {
    // Android
    if (phoneNumber != '911') {
      String uri = 'tel:+1$phoneNumber';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    } else {
      if (await canLaunch('tel:911')) {
        await launch('tel:911');
      } else {
        throw 'Could not launch';
      }
    }
  }

  textMe(String string1) async {
    if (phoneNumber != '911') {
      nameToUri();
      String body =
          '$string1%20reached%20out%20to%20you,%20$nameForText,%20as%20an%20emergency%20contact.%20Please%20call%20this%20number.';
      String uri = 'sms:$phoneNumber&body=$body';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }
}
