class UserModel {
  String sId;
  String firstName;
  String lastName;
  String email;
  String phone;
  String password;
  String token;
  String isDeleted;
  String createdAt;
  String updatedAt;
  String iV;
  String profilePhoto;

  UserModel(
      {required this.sId,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone,
      required this.password,
      required this.token,
      required this.isDeleted,
      required this.createdAt,
      required this.updatedAt,
      required this.iV,
      required this.profilePhoto});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        sId: json['_id'].toString() ?? "",
        firstName: json['firstName'].toString() ?? "",
        lastName: json['lastName'].toString() ?? "",
        email: json['email'].toString() ?? "",
        phone: json['phone'].toString() ?? "",
        password: json['password'].toString() ?? "",
        token: json['token'].toString() ?? "",
        isDeleted: json['isDeleted'].toString() ?? "",
        createdAt: json['createdAt'].toString() ?? "",
        updatedAt: json['updatedAt'].toString() ?? "",
        iV: json['__v'].toString() ?? "",
        profilePhoto: json['profilePhoto'].toString() ?? "");
  }
}
