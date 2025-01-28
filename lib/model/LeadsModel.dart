class LeadsModel {
  bool? status;
  Data? data;

  LeadsModel({this.status, this.data});

  LeadsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? currentPage;
  List<Leads>? leadslist;
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

  Data(
      {this.currentPage,
        this.leadslist,
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

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      leadslist = <Leads>[];
      json['data'].forEach((v) {
        leadslist!.add(new Leads.fromJson(v));
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
    if (this.leadslist != null) {
      data['data'] = this.leadslist!.map((v) => v.toJson()).toList();
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

class Leads {
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
  String? dealAmount;
  int? totalCalls;
  String? lastCalledDate;
  int? leadStageId;
  String? dealClosureDate;
  int? callDuration;
  String? latestUpdate;
  StageName? stageName;
  LatestFollowupDetail? latestFollowupDetail;

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
        this.latestUpdate,
        this.stageName,
        this.latestFollowupDetail});

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
    latestUpdate = json['latest_update'];
    stageName = json['stage_name'] != null
        ? new StageName.fromJson(json['stage_name'])
        : null;
    latestFollowupDetail = json['latest_followup_detail'] != null
        ? new LatestFollowupDetail.fromJson(json['latest_followup_detail'])
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
    data['latest_update'] = this.latestUpdate;
    if (this.stageName != null) {
      data['stage_name'] = this.stageName!.toJson();
    }
    if (this.latestFollowupDetail != null) {
      data['latest_followup_detail'] = this.latestFollowupDetail!.toJson();
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

class LatestFollowupDetail {
  int? id;
  int? leadId;
  int? phone;
  int? staffId;
  String? followupDate;
  String? name;
  String? remarks; // Changed Null? to String?
  int? status;

  LatestFollowupDetail({
    this.id,
    this.leadId,
    this.phone,
    this.staffId,
    this.followupDate,
    this.name,
    this.remarks,
    this.status,
  });

  LatestFollowupDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leadId = json['lead_id'];
    phone = json['phone'];
    staffId = json['staff_id'];
    followupDate = json['followup_date'];
    name = json['name'];
    remarks = json['remarks'] ?? ''; // Default empty string
    status = json['status'];
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
