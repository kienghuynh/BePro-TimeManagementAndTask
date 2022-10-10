class UserModel {
  String? uid;
  String? email;
  String? password;
  String? fullName;
  String? phoneNumber;

  UserModel(
      {this.uid, this.email, this.password, this.fullName, this.phoneNumber});

  // receiving data from cloud
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map["uid"],
      email: map["email"],
      password: map["password"],
      fullName: map["fullName"],
      phoneNumber: map["phoneNumber"],
    );
  }

  // sending data to cloud
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'password': password,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
    };
  }
}
