class HarborCargo {
  const HarborCargo({
    required this.isActive,
    this.link,
    this.key,
  });

  final bool isActive;
  final String? link;
  final String? key;

  factory HarborCargo.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const HarborCargo(isActive: false);
    }
    return HarborCargo(
      isActive: _asBool(json['is_active']) || _asBool(json['isActive']),
      link: json['link'] as String?,
      key: json['key'] as String?,
    );
  }
}

class HarborDispatch {
  const HarborDispatch({
    this.responseCode,
    this.message,
    this.status,
    this.data,
  });

  final int? responseCode;
  final String? message;
  final bool? status;
  final HarborCargo? data;

  bool get isActive {
    if (data != null) return data!.isActive;
    return status == true;
  }

  factory HarborDispatch.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? cargo;
    final raw = json['data'];
    if (raw is Map<String, dynamic>) {
      cargo = raw;
    } else if (raw is Map) {
      cargo = Map<String, dynamic>.from(raw);
    }
    return HarborDispatch(
      responseCode: json['ResponseCode'] as int? ?? json['responseCode'] as int?,
      message: json['Message'] as String? ?? json['message'] as String?,
      status: json.containsKey('status') ? _asBool(json['status']) : null,
      data: cargo == null ? null : HarborCargo.fromJson(cargo),
    );
  }
}

bool _asBool(Object? value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final lower = value.toLowerCase();
    return lower == 'true' || lower == '1' || lower == 'yes';
  }
  return false;
}
