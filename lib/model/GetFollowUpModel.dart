class GetFollowUpModel {
  bool? status;
  List<FollowUp>? data;

  GetFollowUpModel({this.status, this.data});

  GetFollowUpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <FollowUp>[];
      json['data'].forEach((v) {
        data!.add(new FollowUp.fromJson(v));
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

class FollowUp {
  int? id;
  int? leadId;
  int? staffId;
  String? followupDate;
  String? name;
  String? remarks;
  int? status;

  FollowUp(
      {this.id,
        this.leadId,
        this.staffId,
        this.followupDate,
        this.name,
        this.remarks,
        this.status});

  FollowUp.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leadId = json['lead_id'];
    staffId = json['staff_id'];
    followupDate = json['followup_date'];
    name = json['name'];
    remarks = json['remarks'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lead_id'] = this.leadId;
    data['staff_id'] = this.staffId;
    data['followup_date'] = this.followupDate;
    data['name'] = this.name;
    data['remarks'] = this.remarks;
    data['status'] = this.status;
    return data;
  }
}
