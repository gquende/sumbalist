class ContactModel {
  bool registered;
  String displayName;
  String phoneNumber;
  String username;

  ContactModel(
      {required this.displayName,
      required this.phoneNumber,
      required this.username,
      required this.registered});
}
