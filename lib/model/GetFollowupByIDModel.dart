class GetFollowupByIDModel {
  int? id;
  int? staffId;
  int? leadId;
  String? name;
  String? phone;
  String? date;
  String? time;
  int? typeOfFollowUp;
  String? status;
  String? remarks;
  String? createdAt;
  String? updatedAt;

  GetFollowupByIDModel(
      {this.id,
        this.staffId,
        this.leadId,
        this.name,
        this.phone,
        this.date,
        this.time,
        this.typeOfFollowUp,
        this.status,
        this.remarks,
        this.createdAt,
        this.updatedAt});

  GetFollowupByIDModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    staffId = json['staff_id'];
    leadId = json['lead_id'];
    name = json['name'];
    phone = json['phone'];
    date = json['date'];
    time = json['time'];
    typeOfFollowUp = json['type_of_follow_up'];
    status = json['status'];
    remarks = json['remarks'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['staff_id'] = this.staffId;
    data['lead_id'] = this.leadId;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['date'] = this.date;
    data['time'] = this.time;
    data['type_of_follow_up'] = this.typeOfFollowUp;
    data['status'] = this.status;
    data['remarks'] = this.remarks;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
