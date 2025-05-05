class LeadsModel {
  final bool status;
  final LeadData data;

  LeadsModel({required this.status, required this.data});

  factory LeadsModel.fromJson(Map<String, dynamic> json) {
    return LeadsModel(
      status: json['status'] as bool,
      data: LeadData.fromJson(json['data'] as Map<String, dynamic>),
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
    this.firstPageUrl,
    required this.from,
    required this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory LeadData.fromJson(Map<String, dynamic> json) {
    return LeadData(
      currentPage: json['current_page'] as int,
      data: (json['data'] as List<dynamic>)
          .map((x) => Lead.fromJson(x as Map<String, dynamic>))
          .toList(),
      firstPageUrl: json['first_page_url'] as String?,
      from: json['from'] as int,
      lastPage: json['last_page'] as int,
      lastPageUrl: json['last_page_url'] as String?,
      links: (json['links'] as List<dynamic>)
          .map((x) => Link.fromJson(x as Map<String, dynamic>))
          .toList(),
      nextPageUrl: json['next_page_url'] as String?,
      path: json['path'] as String?,
      perPage: json['per_page'] as int,
      prevPageUrl: json['prev_page_url'] as String?,
      to: json['to'] as int,
      total: json['total'] as int,
    );
  }
}

class Lead {
  final int id;
  final String number; // Changed to String to handle phone numbers
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
  final int? callDuration; // Made nullable to handle null values
  final String? latestUpdate; // Made nullable to handle null values
  final int activeStatus;
  final String? companyId; // Made nullable to handle null values
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
    this.followUpDate,
    this.serviceType,
    this.stageType,
    this.industryType,
    this.remarks,
    required this.dealStatus,
    this.dealAmount,
    required this.totalCalls,
    this.lastCalledDate,
    required this.leadStageId,
    this.dealClosureDate,
    this.callDuration,
    this.latestUpdate,
    required this.activeStatus,
    this.companyId,
    required this.leadStage,
    required this.leadType,
    this.leadSource,
    this.leadIndustry,
    this.email,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    required this.stageName,
    this.latestFollowupDetail,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'] as int,
      number: json['number'].toString(), // Convert to String to handle large numbers
      staffId: json['staff_id'] as int,
      dateAdded: json['date_added'] as String,
      callStatus: json['call_status'] as String,
      calledStatus: json['called_status'] as String,
      name: json['name'] as String,
      followUpDate: json['follow_up_date'] as String?,
      serviceType: json['service_type'] as int?,
      stageType: json['stage_type'] as int?,
      industryType: json['industry_type'] as int?,
      remarks: json['remarks'] as String?,
      dealStatus: json['deal_status'] as String,
      dealAmount: json['deal_amount'],
      totalCalls: json['total_calls'] as int,
      lastCalledDate: json['last_called_date'] as String?,
      leadStageId: json['lead_stage_id'] as int,
      dealClosureDate: json['deal_closure_date'] as String?,
      callDuration: json['call_duration'] as int?,
      latestUpdate: json['latest_update'] as String?,
      activeStatus: json['active_status'] as int,
      companyId: json['company_id'] as String?,
      leadStage: json['lead_stage'] as String,
      leadType: json['lead_type'] as String,
      leadSource: json['lead_source'] as String?,
      leadIndustry: json['lead_industry'] as String?,
      email: json['email'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      description: json['description'] as String?,
      stageName: StageName.fromJson(json['stage_name'] as Map<String, dynamic>),
      latestFollowupDetail: json['latest_followup_detail'] != null
          ? LatestFollowupDetail.fromJson(
          json['latest_followup_detail'] as Map<String, dynamic>)
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
      id: json['id'] as int,
      stageName: json['stage_name'] as String,
      createdAt: json['created_at'] as String,
      createdBy: json['created_by'] as int,
    );
  }
}

class LatestFollowupDetail {
  final int id;
  final int leadId;
  final String phone; // Changed to String to handle phone numbers
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
      id: json['id'] as int,
      leadId: json['lead_id'] as int,
      phone: json['phone'].toString(), // Convert to String to handle large numbers
      staffId: json['staff_id'] as int,
      followupDate: json['followup_date'] as String,
      name: json['name'] as String,
      remarks: json['remarks'] as String?,
      status: json['status'] as int,
    );
  }
}

class Link {
  final String? url;
  final String label;
  final bool active;

  Link({
    this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json['url'] as String?,
      label: json['label'] as String,
      active: json['active'] as bool,
    );
  }
}