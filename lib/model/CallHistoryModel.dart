/// ─────────────────────────────────────────────────────────────────────────────
/// call_history_model.dart
/// ─────────────────────────────────────────────────────────────────────────────

class CallHistoryModel {
  final int? currentPage;
  final List<CallHistoryItem>? data;
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

  const CallHistoryModel({
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

  factory CallHistoryModel.fromJson(Map<String, dynamic> json) => CallHistoryModel(
    currentPage: json['current_page'],
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => CallHistoryItem.fromJson(e))
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
    'data': data?.map((e) => e.toJson()).toList(),
    'first_page_url': firstPageUrl,
    'from': from,
    'last_page': lastPage,
    'last_page_url': lastPageUrl,
    'links': links?.map((e) => e.toJson()).toList(),
    'next_page_url': nextPageUrl,
    'path': path,
    'per_page': perPage,
    'prev_page_url': prevPageUrl,
    'to': to,
    'total': total,
  };
}


/// ─────────────────────────────────────────────────────────────────────────────
/// PAGINATED WRAPPER
/// ─────────────────────────────────────────────────────────────────────────────
class CallHistoryPageData {
  final int? currentPage;
  final List<CallHistoryItem>? callHistory;
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

  const CallHistoryPageData({
    this.currentPage,
    this.callHistory,
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

  factory CallHistoryPageData.fromJson(Map<String, dynamic> json) =>
      CallHistoryPageData(
        currentPage: json['current_page'],
        callHistory: (json['data'] as List<dynamic>?)
            ?.map((e) => CallHistoryItem.fromJson(e))
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
    if (callHistory != null)
      'data': callHistory!.map((e) => e.toJson()).toList(),
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
/// SINGLE CALL‑HISTORY ITEM
/// ─────────────────────────────────────────────────────────────────────────────
class CallHistoryItem {
  final int? id;
  final String? number;
  final String? dateAdded;
  final String? callStatus;
  final String? calledStatus;
  final String? callDuration;
  final String? latestUpdate;
  final String? source;

  const CallHistoryItem({
    this.id,
    this.number,
    this.dateAdded,
    this.callStatus,
    this.calledStatus,
    this.callDuration,
    this.latestUpdate,
    this.source,
  });

  factory CallHistoryItem.fromJson(Map<String, dynamic> json) => CallHistoryItem(
    id: json['id'],
    number: json['number'],
    dateAdded: json['date_added'],
    callStatus: json['call_status'],
    calledStatus: json['called_status'],
    callDuration: json['call_duration'],
    latestUpdate: json['latest_update'],
    source: json['source'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'number': number,
    'date_added': dateAdded,
    'call_status': callStatus,
    'called_status': calledStatus,
    'call_duration': callDuration,
    'latest_update': latestUpdate,
    'source': source,
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

