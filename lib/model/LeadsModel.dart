class LeadsModel {
  bool? status;
  List<Leads>? data;

  LeadsModel({this.status, this.data});

  LeadsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Leads>[];
      json['data'].forEach((v) {
        data!.add(new Leads.fromJson(v));
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

class Leads {
  int? id;
  String? number;
  int? staffId;
  String? dateAdded;
  String? callStatus;
  String? calledStatus;
  String? name;
  Null? followUpDate;
  Null? remarks;
  String? dealStatus;
  Null? dealAmount;
  int? totalCalls;
  Null? lastCalledDate;
  int? leadStageId;
  Null? dealClosureDate;
  int? callDuration;
  int? fId;
  StageName? stageName;

  Leads(
      {this.id,
        this.number,
        this.staffId,
        this.dateAdded,
        this.callStatus,
        this.calledStatus,
        this.name,
        this.followUpDate,
        this.remarks,
        this.dealStatus,
        this.dealAmount,
        this.totalCalls,
        this.lastCalledDate,
        this.leadStageId,
        this.dealClosureDate,
        this.callDuration,
        this.fId,
        this.stageName});

  Leads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    staffId = json['staff_id'];
    dateAdded = json['date_added'];
    callStatus = json['call_status'];
    calledStatus = json['called_status'];
    name = json['name'];
    followUpDate = json['follow_up_date'];
    remarks = json['remarks'];
    dealStatus = json['deal_status'];
    dealAmount = json['deal_amount'];
    totalCalls = json['total_calls'];
    lastCalledDate = json['last_called_date'];
    leadStageId = json['lead_stage_id'];
    dealClosureDate = json['deal_closure_date'];
    callDuration = json['call_duration'];
    fId = json['f_id'];
    stageName = json['stage_name'] != null
        ? new StageName.fromJson(json['stage_name'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['staff_id'] = this.staffId;
    data['date_added'] = this.dateAdded;
    data['call_status'] = this.callStatus;
    data['called_status'] = this.calledStatus;
    data['name'] = this.name;
    data['follow_up_date'] = this.followUpDate;
    data['remarks'] = this.remarks;
    data['deal_status'] = this.dealStatus;
    data['deal_amount'] = this.dealAmount;
    data['total_calls'] = this.totalCalls;
    data['last_called_date'] = this.lastCalledDate;
    data['lead_stage_id'] = this.leadStageId;
    data['deal_closure_date'] = this.dealClosureDate;
    data['call_duration'] = this.callDuration;
    data['f_id'] = this.fId;
    if (this.stageName != null) {
      data['stage_name'] = this.stageName!.toJson();
    }
    return data;
  }
}

class StageName {
  int? id;
  String? stageName;
  String? createdAt;
  int? createdBy;

  StageName({this.id, this.stageName, this.createdAt, this.createdBy});

  StageName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stageName = json['stage_name'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['stage_name'] = this.stageName;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    return data;
  }
}
