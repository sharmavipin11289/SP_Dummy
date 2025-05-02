class UserDetailModel {
  String? message;
  UserDetail? data;

  UserDetailModel({this.message, this.data});

  UserDetailModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new UserDetail.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserDetail {
  String? id;
  String? name;
  String? email;
  String? profilePicture;
  String? profilePictureUrl;
  String? contactNumber;
  String? dateOfBirth;
  String? gender;
  String? country;

  UserDetail(
      {this.id,
        this.name,
        this.email,
        this.profilePicture,
        this.profilePictureUrl,
        this.contactNumber,
        this.dateOfBirth,
        this.gender,
        this.country});

  UserDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    profilePicture = json['profile_picture'];
    profilePictureUrl = json['profile_picture_url'];
    contactNumber = json['contact_number'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['profile_picture'] = this.profilePicture;
    data['profile_picture_url'] = this.profilePictureUrl;
    data['contact_number'] = this.contactNumber;
    data['date_of_birth'] = this.dateOfBirth;
    data['gender'] = this.gender;
    data['country'] = this.country;
    return data;
  }
}
