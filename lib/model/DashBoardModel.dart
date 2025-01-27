class DashBoardModel {
  bool? status;
  int? todayCalls;
  int? pendingCalls;
  int? leadCount;
  int? followupCount;
  PhoneNumbers? phoneNumbers;

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
    phoneNumbers = json['phone_numbers'] != null
        ? new PhoneNumbers.fromJson(json['phone_numbers'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['today_calls'] = this.todayCalls;
    data['pending_calls'] = this.pendingCalls;
    data['lead_count'] = this.leadCount;
    data['followup_count'] = this.followupCount;
    if (this.phoneNumbers != null) {
      data['phone_numbers'] = this.phoneNumbers!.toJson();
    }
    return data;
  }
}

class PhoneNumbers {
  int? currentPage;
  List<MobileNumbers>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  PhoneNumbers(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  PhoneNumbers.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <MobileNumbers>[];
      json['data'].forEach((v) {
        data!.add(new MobileNumbers.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class MobileNumbers {
  int? id;
  String? number;
  int? staffId;
  String? dateAdded;
  String? callStatus;
  String? calledStatus;
  String? name;
  String? followUpDate;
  String? remarks;
  String? dealStatus;
  int? dealAmount;
  int? totalCalls;
  String? lastCalledDate;
  int? leadStageId;
  String? dealClosureDate;
  int? callDuration;
  String? latestUpdate;

  MobileNumbers(
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
        this.latestUpdate});

  MobileNumbers.fromJson(Map<String, dynamic> json) {
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
    latestUpdate = json['latest_update'];
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
    data['latest_update'] = this.latestUpdate;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
