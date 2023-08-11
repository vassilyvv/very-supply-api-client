import '../base_model.dart';

class User extends BaseModel{
  String? email;
  String? phoneNumber;
  String? firstName;
  String? lastName;
  String? accessToken;
  String? refreshToken;

  bool? isEmailConfirmed;
  String? emailCandidate;
  bool? isPhoneNumberConfirmed;
  String? phoneNumberCandidate;
  bool? isMFAEnabled;

  User.fromJson(json) : super.fromJson(json) {
    email = json['email'];
    phoneNumber = json['phone_number'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    isEmailConfirmed = json['is_email_confirmed'];
    emailCandidate = json['email_candidate'];
    isPhoneNumberConfirmed = json['is_phone_number_confirmed'];
    phoneNumberCandidate = json['phone_number_candidate'];
    isMFAEnabled = json['is_mfa_enabled'];
  }
}
