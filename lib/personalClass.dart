import 'package:url_launcher/url_launcher.dart';

class PersonalClass {
  String dateOfBirth;
  String name;
  String phoneNumber;
  String phoneNumberDisplay;
  String allergies;
  String medicalIssues;
  String image;
  String email;

  PersonalClass(
      {this.dateOfBirth,
      this.name,
      this.phoneNumber,
      this.allergies,
      this.medicalIssues,
      this.image,
      this.email});

  void emailMe(String emailAdress) async {
    String uri1 =
        'googlegmail:///co?to$emailAdress&subject=Emergency%20Contact';
    String uri2 = 'mailto:$emailAdress?subject=Emergency%20Contact';
    if (await canLaunch(uri1)) {
      await launch(uri1);
    } else if (await canLaunch(uri2)) {
      await launch(uri2);
    } else {
      throw 'Could not launch $uri1';
    }
  }

  void checkIfBlank() {
    List<String> entryFeilds = [
      dateOfBirth,
      name,
      phoneNumber,
      allergies,
      medicalIssues,
      email
    ];
    for (String entry in entryFeilds) {
      if (entry == null) {
        entry = 'enter $entry';
      }
    }
  }

  String formatPhoneNumber() {
    if (phoneNumber != 'N/A') {
      phoneNumberDisplay =
          '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)} - ${phoneNumber.substring(6, 10)}';
    } else {
      phoneNumberDisplay = 'N/A';
    }

    return phoneNumberDisplay;
  }
}
