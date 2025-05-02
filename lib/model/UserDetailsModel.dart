class UserDetailsModel {
  int? id;
  String? name; // Changed from username to name to match JSON
  String? email;
  String? phone; // Added to match JSON
  String? emailVerifiedAt; // Added to match JSON
  String? otp; // Added to match JSON
  String? expTime; // Changed from expiryDate to expTime to match JSON
  String? expToken; // Added to match JSON
  String? role; // Changed from roleId (int) to role (String) to match JSON
  String? companyId; // Changed from adminId to companyId and made String? to match JSON
  String? profileImage; // Changed from photo to profileImage to match JSON
  int? activeStatus; // Changed from status (String) to activeStatus (int) to match JSON
  String? createdAt;
  String? updatedAt; // Added to match JSON
  String? address; // Added to match JSON
  String? pincode; // Added to match JSON
  String? state; // Added to match JSON
  String? city; // Added to match JSON
  String? country; // Added to match JSON
  String? photo; // Added to match JSON (though null in this response)
  String? whatsappapikey;

  UserDetailsModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.emailVerifiedAt,
    this.otp,
    this.expTime,
    this.expToken,
    this.role,
    this.companyId,
    this.profileImage,
    this.activeStatus,
    this.createdAt,
    this.updatedAt,
    this.address,
    this.pincode,
    this.state,
    this.city,
    this.country,
    this.photo,
    this.whatsappapikey,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      otp: json['otp'] as String?,
      expTime: json['expTime'] as String?,
      expToken: json['expToken'] as String?,
      role: json['role'] as String?,
      companyId: json['company_id'] as String?,
      profileImage: json['profile_image'] as String?,
      activeStatus: json['active_status'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      address: json['address'] as String?,
      pincode: json['pincode'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      photo: json['photo'] as String?,
      whatsappapikey: json['whatsappapikey'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'email_verified_at': emailVerifiedAt,
      'otp': otp,
      'expTime': expTime,
      'expToken': expToken,
      'role': role,
      'company_id': companyId,
      'profile_image': profileImage,
      'active_status': activeStatus,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'address': address,
      'pincode': pincode,
      'state': state,
      'city': city,
      'country': country,
      'photo': photo,
      'whatsappapikey': whatsappapikey,
    };
  }
}