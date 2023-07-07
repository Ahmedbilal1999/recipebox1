class RegisterResModel {
  String? message;
  String? statusCode;
  String? error;

  RegisterResModel({this.statusCode, this.error});

  fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    error = json['error'];
  }

  Map<String, dynamic> toJson(decode) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = statusCode;
    data['error'] = error;
    return data;
  }
}