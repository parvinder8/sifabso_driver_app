class VerifyDriverResponse {
  VerifyDriverResponse({required this.status, this.token, this.message});
  String status;
  String? token;
  String? message;

  factory VerifyDriverResponse.fromJson(Map<String, dynamic> json) =>
      VerifyDriverResponse(
        status: json['status'],
        token: json['token'],
        message: json['message'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['token'] = token;
    data['message'] = message;
    return data;
  }
}
