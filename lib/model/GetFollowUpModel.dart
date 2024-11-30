class GetFollowUpModel {
  bool? status;
  List<FollowUpModel>? data;

  GetFollowUpModel({this.status, this.data});

  GetFollowUpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <FollowUpModel>[];
      json['data'].forEach((v) {
        data!.add(new FollowUpModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FollowUpModel {
  int? id;
  int? leadId;
  int? phone;
  int? staffId;
  String? followupDate;
  String? name;
  String? remarks;
  int? status;
  LeadType? leadType;

  FollowUpModel(
      {this.id,
        this.leadId,
        this.phone,
        this.staffId,
        this.followupDate,
        this.name,
        this.remarks,
        this.status,
        this.leadType});

  FollowUpModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leadId = json['lead_id'];
    phone = json['phone'];
    staffId = json['staff_id'];
    followupDate = json['followup_date'];
    name = json['name'];
    remarks = json['remarks'];
    status = json['status'];
    leadType = json['lead_type'] != null
        ? new LeadType.fromJson(json['lead_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lead_id'] = this.leadId;
    data['phone'] = this.phone;
    data['staff_id'] = this.staffId;
    data['followup_date'] = this.followupDate;
    data['name'] = this.name;
    data['remarks'] = this.remarks;
    data['status'] = this.status;
    if (this.leadType != null) {
      data['lead_type'] = this.leadType!.toJson();
    }
    return data;
  }
}

class LeadType {
  int? id;
  int? leadStageId;
  String? number;
  StageName? stageName;

  LeadType({this.id, this.leadStageId, this.number, this.stageName});

  LeadType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leadStageId = json['lead_stage_id'];
    number = json['number'];
    stageName = json['stage_name'] != null
        ? new StageName.fromJson(json['stage_name'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lead_stage_id'] = this.leadStageId;
    data['number'] = this.number;
    if (this.stageName != null) {
      data['stage_name'] = this.stageName!.toJson();
    }
    return data;
  }
}

class StageName {
  int? id;
  String? stageName;

  StageName({this.id, this.stageName});

  StageName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stageName = json['stage_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['stage_name'] = this.stageName;
    return data;
  }
}
