class DriverLoginResponse {
  DriverLoginResponse({
    required this.status,
    this.userId,
    this.type,
    this.message,
  });
  String status;
  String? userId;
  String? type;
  String? message;

  factory DriverLoginResponse.fromJson(Map<String, dynamic> json) =>
      DriverLoginResponse(
        status: json['status'],
        userId: json['user_id'],
        type: json['type'],
        message: json['message'],
      );
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['user_id'] = userId;
    data['type'] = type;
    data['message'] = message;
    return data;
  }
}
