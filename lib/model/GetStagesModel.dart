class GetStagesModel {
  bool? status;
  String? message;
  List<Stages>? stages;

  GetStagesModel({this.status, this.message, this.stages});

  GetStagesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      stages = <Stages>[];
      json['data'].forEach((v) {
        stages!.add(new Stages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.stages != null) {
      data['data'] = this.stages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stages {
  int? id;
  String? companyId;
  String? type;
  String? createdAt;
  String? updatedAt;

  Stages({this.id, this.companyId, this.type, this.createdAt, this.updatedAt});

  Stages.fromJson(Map<String, dynamic> json) {
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
