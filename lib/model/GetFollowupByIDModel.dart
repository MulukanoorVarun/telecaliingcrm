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

  GetFollowupByIDModel({
    this.id,
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
    this.updatedAt,
  });

  GetFollowupByIDModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    staffId = json['staff_id'] as int?;
    leadId = json['lead_id'] as int?;
    name = json['name'] as String?;
    phone = json['phone'] as String?;
    date = json['date'] as String?;
    time = json['time'] as String?;
    typeOfFollowUp = json['type_of_follow_up'] as int?;
    status = json['status'] as String?;
    remarks = json['remarks'] as String?;
    createdAt = json['created_at'] as String?;
    updatedAt = json['updated_at'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['staff_id'] = staffId;
    data['lead_id'] = leadId;
    data['name'] = name;
    data['phone'] = phone;
    data['date'] = date;
    data['time'] = time;
    data['type_of_follow_up'] = typeOfFollowUp;
    data['status'] = status;
    data['remarks'] = remarks;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}