class GetFollowUpModel {
  bool? status;
  Data? data;

  GetFollowUpModel({this.status, this.data});

  GetFollowUpModel.fromJson(Map<String, dynamic> json) {
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
  List<FollowUpModel>? followup_list;
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
        this.followup_list,
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
      followup_list = <FollowUpModel>[];
      json['data'].forEach((v) {
        followup_list!.add(new FollowUpModel.fromJson(v));
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
    if (this.followup_list != null) {
      data['data'] = this.followup_list!.map((v) => v.toJson()).toList();
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
