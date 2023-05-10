class BaseResponse {
  dynamic result;
  dynamic targetUrl;
  bool? success;
  dynamic error;
  bool? unAuthorizedRequest;
  bool? bAbp;
  int? status;
  String? message;

  BaseResponse({
    this.result,
    this.targetUrl,
    this.success,
    this.error,
    this.unAuthorizedRequest,
    this.bAbp,
    this.status,
    this.message,
  });

  BaseResponse.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    targetUrl = json['targetUrl'];
    success = json['success'];
    error = json['error'];
    unAuthorizedRequest = json['unAuthorizedRequest'];
    bAbp = json['__abp'];
    status = json['status'];
    message = json['message'];
  }
}
