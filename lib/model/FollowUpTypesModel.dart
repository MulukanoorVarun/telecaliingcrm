class FollowUpTypesModel {
  bool? status;
  String? message;
  List<FollowUpTypes>? followuptypes;

  FollowUpTypesModel({this.status, this.message, this.followuptypes});

  FollowUpTypesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      followuptypes = <FollowUpTypes>[];
      json['data'].forEach((v) {
        followuptypes!.add(new FollowUpTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.followuptypes != null) {
      data['data'] = this.followuptypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FollowUpTypes {
  int? id;
  int? adminId;
  String? type;
  String? createdAt;
  String? updatedAt;

  FollowUpTypes({this.id, this.adminId, this.type, this.createdAt, this.updatedAt});

  FollowUpTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adminId = json['admin_id'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['admin_id'] = this.adminId;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
