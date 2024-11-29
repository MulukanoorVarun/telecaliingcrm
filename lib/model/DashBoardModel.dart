class DashBoardModel {
  bool? status;
  int? todayCalls;
  int? pendingCalls;
  int? leadCount;
  int? followupCount;
  List<PhoneNumbers>? phoneNumbers;

  DashBoardModel(
      {this.status,
        this.todayCalls,
        this.pendingCalls,
        this.leadCount,
        this.followupCount,
        this.phoneNumbers});

  DashBoardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    todayCalls = json['today_calls'];
    pendingCalls = json['pending_calls'];
    leadCount = json['lead_count'];
    followupCount = json['followup_count'];
    if (json['phone_numbers'] != null) {
      phoneNumbers = <PhoneNumbers>[];
      json['phone_numbers'].forEach((v) {
        phoneNumbers!.add(new PhoneNumbers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['today_calls'] = this.todayCalls;
    data['pending_calls'] = this.pendingCalls;
    data['lead_count'] = this.leadCount;
    data['followup_count'] = this.followupCount;
    if (this.phoneNumbers != null) {
      data['phone_numbers'] =
          this.phoneNumbers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PhoneNumbers {
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
  Null? leadStageId;
  Null? dealClosureDate;
  int? callDuration;

  PhoneNumbers(
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
        this.callDuration});

  PhoneNumbers.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
