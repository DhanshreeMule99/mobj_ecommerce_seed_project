// profileModel
class ProfileModel {
  String sId;
  String firstName;
  String lastName;
  String email;
  String phone;
  String? password;
  String token;
  String? isDeleted;
  String? createdAt;
  String? updatedAt;
  String? iV;
  String? address;
  String? city;
  String? bio;
  String profilePhoto;

  ProfileModel(
      {required this.sId,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone,
      this.password,
      required this.token,
      this.isDeleted,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.address,
      this.city,
      this.bio,
      required this.profilePhoto});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
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
        address: json['address'].toString() ?? "",
        city: json['city'].toString() ?? "",
        bio: json['bio'].toString() ?? "",
        profilePhoto: json['profilePhoto'].toString() ?? "");
  }
}
