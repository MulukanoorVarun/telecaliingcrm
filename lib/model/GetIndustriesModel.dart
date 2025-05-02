class GetIndustriesModel {
  bool? status;
  String? message;
  List<Industires>? industires;

  GetIndustriesModel({this.status, this.message, this.industires});

  GetIndustriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      industires = <Industires>[];
      json['data'].forEach((v) {
        industires!.add(new Industires.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.industires != null) {
      data['data'] = this.industires!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Industires {
  int? id;
  String? companyId;
  String? type;
  String? createdAt;
  String? updatedAt;

  Industires({this.id, this.companyId, this.type, this.createdAt, this.updatedAt});

  Industires.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
