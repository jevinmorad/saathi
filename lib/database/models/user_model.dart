import 'package:saathi/database/local/const.dart';

class UserModel {
  String firstName = '';
  String lastName = '';
  String gender = '';
  String mobile = '';
  String email = '';
  String dateOfBirth = '';
  String religion = '';
  String community = '';
  String subCommunity = '';
  String livingIn = '';
  String city = '';
  String state = '';
  String maritalStatus = '';
  String height = '';
  String diet = '';
  String bio = '';
  String hobbies = '';
  String imageUrl = '';
  String isFavourite = '0';

  UserModel._();

  static final UserModel getInstance = UserModel._();

  Map<String, dynamic> toMap() {
    return {
      FNAME: firstName,
      LNAME: lastName,
      DATE_OF_BIRTH: dateOfBirth,
      GENDER: gender,
      RELIGION: religion,
      COMMUNITY: community,
      LIVING_IN: livingIn,
      EMAIL: email,
      MOBILE: mobile,
      SUB_COMMUNITY: subCommunity,
      CITY: city,
      STATE: state,
      MARITAL_STATUS: maritalStatus,
      HEIGHT: height,
      DIET: diet,
      BIO: bio,
      HOBBIES: hobbies,
      IMAGE_URL: imageUrl,
      IS_FAVOURITE: isFavourite,
    };
  }

  void clear() {
    firstName = '';
    lastName = '';
    gender = '';
    mobile = '';
    email = '';
    dateOfBirth = '';
    religion = '';
    community = '';
    subCommunity = '';
    livingIn = '';
    city = '';
    state = '';
    maritalStatus = '';
    height = '';
    diet = '';
    bio = '';
    hobbies = '';
    imageUrl = '';
    isFavourite = '0';
  }
}