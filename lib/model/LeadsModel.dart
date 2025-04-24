
class LeadsModel {
  final bool? status;
  final LeadsPageData? data;

  const LeadsModel({this.status, this.data});

  factory LeadsModel.fromJson(Map<String, dynamic> json) => LeadsModel(
    status: json['status'] as bool?,
    data: json['data'] != null
        ? LeadsPageData.fromJson(json['data'] as Map<String, dynamic>)
        : null,
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    if (data != null) 'data': data!.toJson(),
  };
}


class LeadsPageData {
  final int? currentPage;
  final List<Lead>? leads;              // ← list renamed
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<PageLink>? links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final String? prevPageUrl;
  final int? to;
  final int? total;

  const LeadsPageData({
    this.currentPage,
    this.leads,
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
    this.total,
  });

  factory LeadsPageData.fromJson(Map<String, dynamic> json) => LeadsPageData(
    currentPage: json['current_page'],
    leads: (json['data'] as List<dynamic>?)
        ?.map((e) => Lead.fromJson(e as Map<String, dynamic>))
        .toList(),
    firstPageUrl: json['first_page_url'],
    from: json['from'],
    lastPage: json['last_page'],
    lastPageUrl: json['last_page_url'],
    links: (json['links'] as List<dynamic>?)
        ?.map((e) => PageLink.fromJson(e as Map<String, dynamic>))
        .toList(),
    nextPageUrl: json['next_page_url'],
    path: json['path'],
    perPage: json['per_page'],
    prevPageUrl: json['prev_page_url'],
    to: json['to'],
    total: json['total'],
  );

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    if (leads != null) 'data': leads!.map((e) => e.toJson()).toList(),
    'first_page_url': firstPageUrl,
    'from': from,
    'last_page': lastPage,
    'last_page_url': lastPageUrl,
    if (links != null) 'links': links!.map((e) => e.toJson()).toList(),
    'next_page_url': nextPageUrl,
    'path': path,
    'per_page': perPage,
    'prev_page_url': prevPageUrl,
    'to': to,
    'total': total,
  };
}

/// ─────────────────────────────────────────────────────────────────────────────
/// SINGLE LEAD
/// ─────────────────────────────────────────────────────────────────────────────
class Lead {
  final int? id;
  final String? number;
  final int? staffId;
  final String? dateAdded;
  final String? callStatus;
  final String? calledStatus;
  final String? name;
  final String? followUpDate;
  final String? remarks;
  final String? dealStatus;
  final String? dealAmount;
  final int? totalCalls;
  final String? lastCalledDate;
  final int? leadStageId;
  final String? dealClosureDate;
  final int? callDuration;
  final String? latestUpdate;
  final StageName? stageName;
  final LatestFollowupDetail? latestFollowupDetail;

  const Lead({
    this.id,
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
    this.latestFollowupDetail,
  });

  factory Lead.fromJson(Map<String, dynamic> json) => Lead(
    id: json['id'],
    number: json['number'],
    staffId: json['staff_id'],
    dateAdded: json['date_added'],
    callStatus: json['call_status'],
    calledStatus: json['called_status'],
    name: json['name'],
    followUpDate: json['follow_up_date'],
    remarks: json['remarks'],
    dealStatus: json['deal_status'],
    dealAmount: json['deal_amount'],
    totalCalls: json['total_calls'],
    lastCalledDate: json['last_called_date'],
    leadStageId: json['lead_stage_id'],
    dealClosureDate: json['deal_closure_date'],
    callDuration: json['call_duration'],
    latestUpdate: json['latest_update'],
    stageName: json['stage_name'] != null
        ? StageName.fromJson(json['stage_name'])
        : null,
    latestFollowupDetail: json['latest_followup_detail'] != null
        ? LatestFollowupDetail.fromJson(json['latest_followup_detail'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'number': number,
    'staff_id': staffId,
    'date_added': dateAdded,
    'call_status': callStatus,
    'called_status': calledStatus,
    'name': name,
    'follow_up_date': followUpDate,
    'remarks': remarks,
    'deal_status': dealStatus,
    'deal_amount': dealAmount,
    'total_calls': totalCalls,
    'last_called_date': lastCalledDate,
    'lead_stage_id': leadStageId,
    'deal_closure_date': dealClosureDate,
    'call_duration': callDuration,
    'latest_update': latestUpdate,
    if (stageName != null) 'stage_name': stageName!.toJson(),
    if (latestFollowupDetail != null)
      'latest_followup_detail': latestFollowupDetail!.toJson(),
  };
}

/// ─────────────────────────────────────────────────────────────────────────────
/// NESTED OBJECTS
/// ─────────────────────────────────────────────────────────────────────────────
class StageName {
  final int? id;
  final String? stageName;
  final String? createdAt;
  final int? createdBy;

  const StageName({this.id, this.stageName, this.createdAt, this.createdBy});

  factory StageName.fromJson(Map<String, dynamic> json) => StageName(
    id: json['id'],
    stageName: json['stage_name'],
    createdAt: json['created_at'],
    createdBy: json['created_by'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'stage_name': stageName,
    'created_at': createdAt,
    'created_by': createdBy,
  };
}

class LatestFollowupDetail {
  final int? id;
  final int? leadId;
  final int? phone;
  final int? staffId;
  final String? followupDate;
  final String? name;
  final String? remarks;
  final int? status;

  const LatestFollowupDetail({
    this.id,
    this.leadId,
    this.phone,
    this.staffId,
    this.followupDate,
    this.name,
    this.remarks,
    this.status,
  });

  factory LatestFollowupDetail.fromJson(Map<String, dynamic> json) =>
      LatestFollowupDetail(
        id: json['id'],
        leadId: json['lead_id'],
        phone: json['phone'],
        staffId: json['staff_id'],
        followupDate: json['followup_date'],
        name: json['name'],
        remarks: (json['remarks'] ?? '') as String,
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'lead_id': leadId,
    'phone': phone,
    'staff_id': staffId,
    'followup_date': followupDate,
    'name': name,
    'remarks': remarks,
    'status': status,
  };
}

class PageLink {
  final String? url;
  final String? label;
  final bool? active;

  const PageLink({this.url, this.label, this.active});

  factory PageLink.fromJson(Map<String, dynamic> json) => PageLink(
    url: json['url'],
    label: json['label'],
    active: json['active'],
  );

  Map<String, dynamic> toJson() => {
    'url': url,
    'label': label,
    'active': active,
  };
}
