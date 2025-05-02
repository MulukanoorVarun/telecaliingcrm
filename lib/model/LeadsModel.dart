class LeadsModel {
  final bool status;
  final LeadData data;

  LeadsModel({required this.status, required this.data});

  factory LeadsModel.fromJson(Map<String, dynamic> json) {
    return LeadsModel(
      status: json['status'],
      data: LeadData.fromJson(json['data']),
    );
  }
}

class LeadData {
  final int currentPage;
  final List<Lead> data;
  final String? firstPageUrl;
  final int from;
  final int lastPage;
  final String? lastPageUrl;
  final List<Link> links;
  final String? nextPageUrl;
  final String? path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  LeadData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory LeadData.fromJson(Map<String, dynamic> json) {
    return LeadData(
      currentPage: json['current_page'],
      data: List<Lead>.from(json['data'].map((x) => Lead.fromJson(x))),
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: List<Link>.from(json['links'].map((x) => Link.fromJson(x))),
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }
}

class Lead {
  final int id;
  final int number;
  final int staffId;
  final String dateAdded;
  final String callStatus;
  final String calledStatus;
  final String name;
  final String? followUpDate;
  final int? serviceType;
  final int? stageType;
  final int? industryType;
  final String? remarks;
  final String dealStatus;
  final dynamic dealAmount;
  final int totalCalls;
  final String? lastCalledDate;
  final int leadStageId;
  final String? dealClosureDate;
  final int? callDuration;
  final String latestUpdate;
  final int activeStatus;
  final String companyId;
  final String leadStage;
  final String leadType;
  final String? leadSource;
  final String? leadIndustry;
  final String? email;
  final String createdAt;
  final String updatedAt;
  final String? description;
  final StageName stageName;
  final LatestFollowupDetail? latestFollowupDetail;

  Lead({
    required this.id,
    required this.number,
    required this.staffId,
    required this.dateAdded,
    required this.callStatus,
    required this.calledStatus,
    required this.name,
    required this.followUpDate,
    required this.serviceType,
    required this.stageType,
    required this.industryType,
    required this.remarks,
    required this.dealStatus,
    required this.dealAmount,
    required this.totalCalls,
    required this.lastCalledDate,
    required this.leadStageId,
    required this.dealClosureDate,
    required this.callDuration,
    required this.latestUpdate,
    required this.activeStatus,
    required this.companyId,
    required this.leadStage,
    required this.leadType,
    required this.leadSource,
    required this.leadIndustry,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
    required this.stageName,
    required this.latestFollowupDetail,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'],
      number: json['number'],
      staffId: json['staff_id'],
      dateAdded: json['date_added'],
      callStatus: json['call_status'],
      calledStatus: json['called_status'],
      name: json['name'],
      followUpDate: json['follow_up_date'],
      serviceType: json['service_type'],
      stageType: json['stage_type'],
      industryType: json['industry_type'],
      remarks: json['remarks'],
      dealStatus: json['deal_status'],
      dealAmount: json['deal_amount'],
      totalCalls: json['total_calls'],
      lastCalledDate: json['last_called_date'],
      leadStageId: json['lead_stage_id'],
      dealClosureDate: json['deal_closure_date'],
      callDuration: json['call_duration'],
      latestUpdate: json['latest_update'],
      activeStatus: json['active_status'],
      companyId: json['company_id'],
      leadStage: json['lead_stage'],
      leadType: json['lead_type'],
      leadSource: json['lead_source'],
      leadIndustry: json['lead_industry'],
      email: json['email'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      description: json['description'],
      stageName: StageName.fromJson(json['stage_name']),
      latestFollowupDetail: json['latest_followup_detail'] != null
          ? LatestFollowupDetail.fromJson(json['latest_followup_detail'])
          : null,
    );
  }
}

class StageName {
  final int id;
  final String stageName;
  final String createdAt;
  final int createdBy;

  StageName({
    required this.id,
    required this.stageName,
    required this.createdAt,
    required this.createdBy,
  });

  factory StageName.fromJson(Map<String, dynamic> json) {
    return StageName(
      id: json['id'],
      stageName: json['stage_name'],
      createdAt: json['created_at'],
      createdBy: json['created_by'],
    );
  }
}

class LatestFollowupDetail {
  final int id;
  final int leadId;
  final int phone;
  final int staffId;
  final String followupDate;
  final String name;
  final String? remarks;
  final int status;

  LatestFollowupDetail({
    required this.id,
    required this.leadId,
    required this.phone,
    required this.staffId,
    required this.followupDate,
    required this.name,
    this.remarks,
    required this.status,
  });

  factory LatestFollowupDetail.fromJson(Map<String, dynamic> json) {
    return LatestFollowupDetail(
      id: json['id'],
      leadId: json['lead_id'],
      phone: json['phone'],
      staffId: json['staff_id'],
      followupDate: json['followup_date'],
      name: json['name'],
      remarks: json['remarks'],
      status: json['status'],
    );
  }
}

class Link {
  final String? url;
  final String label;
  final bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }
}
