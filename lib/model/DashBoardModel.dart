/// ─────────────────────────────────────────────────────────────────────────────
/// dashboard_model.dart
/// ─────────────────────────────────────────────────────────────────────────────

class DashBoardModel {
  final bool? status;
  final int? todayCalls;
  final int? pendingCalls;
  final int? leadCount;
  final int? followupCount;
  final PhoneNumbers? phoneNumbers;

  const DashBoardModel({
    this.status,
    this.todayCalls,
    this.pendingCalls,
    this.leadCount,
    this.followupCount,
    this.phoneNumbers,
  });

  factory DashBoardModel.fromJson(Map<String, dynamic> json) => DashBoardModel(
    status: json['status'],
    todayCalls: json['today_calls'],
    pendingCalls: json['pending_calls'],
    leadCount: json['lead_count'],
    followupCount: json['followup_count'],
    phoneNumbers: json['phone_numbers'] != null
        ? PhoneNumbers.fromJson(json['phone_numbers'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'today_calls': todayCalls,
    'pending_calls': pendingCalls,
    'lead_count': leadCount,
    'followup_count': followupCount,
    if (phoneNumbers != null) 'phone_numbers': phoneNumbers!.toJson(),
  };
}

/// ─────────────────────────────────────────────────────────────────────────────
/// PAGINATED PHONE‑NUMBER LIST
/// ─────────────────────────────────────────────────────────────────────────────
class PhoneNumbers {
  final int? currentPage;
  final List<MobileNumbers>? data;          // list stays `data`
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

  const PhoneNumbers({
    this.currentPage,
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
    this.total,
  });

  factory PhoneNumbers.fromJson(Map<String, dynamic> json) => PhoneNumbers(
    currentPage: json['current_page'],
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => MobileNumbers.fromJson(e))
        .toList(),
    firstPageUrl: json['first_page_url'],
    from: json['from'],
    lastPage: json['last_page'],
    lastPageUrl: json['last_page_url'],
    links: (json['links'] as List<dynamic>?)
        ?.map((e) => PageLink.fromJson(e))
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
    if (data != null) 'data': data!.map((e) => e.toJson()).toList(),
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
/// SINGLE NUMBER RECORD
/// ─────────────────────────────────────────────────────────────────────────────
class MobileNumbers {
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
  final int? dealAmount;
  final int? totalCalls;
  final String? lastCalledDate;
  final int? leadStageId;
  final String? dealClosureDate;
  final int? callDuration;
  final String? latestUpdate;

  const MobileNumbers({
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
  });

  factory MobileNumbers.fromJson(Map<String, dynamic> json) => MobileNumbers(
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
  };
}

/// ─────────────────────────────────────────────────────────────────────────────
/// PAGE LINK
/// ─────────────────────────────────────────────────────────────────────────────
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
