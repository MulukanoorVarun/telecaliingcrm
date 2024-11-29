class UserDetailsModel {
  int? id;
  String? username;
  String? email;
  int? roleId;
  String? createdAt;
  int? adminId;
  String? expiryDate;
  String? status;
  Null? photo;
  Null? whatsappapikey;

  UserDetailsModel(
      {this.id,
        this.username,
        this.email,
        this.roleId,
        this.createdAt,
        this.adminId,
        this.expiryDate,
        this.status,
        this.photo,
        this.whatsappapikey});

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    roleId = json['role_id'];
    createdAt = json['created_at'];
    adminId = json['admin_id'];
    expiryDate = json['expiry_date'];
    status = json['status'];
    photo = json['photo'];
    whatsappapikey = json['whatsappapikey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['role_id'] = this.roleId;
    data['created_at'] = this.createdAt;
    data['admin_id'] = this.adminId;
    data['expiry_date'] = this.expiryDate;
    data['status'] = this.status;
    data['photo'] = this.photo;
    data['whatsappapikey'] = this.whatsappapikey;
    return data;
  }
}
