class LogInModel {
  int? id;
  String? FirstName;
  String? LastName;
  String? Username;
  String? Password;
  int? UserType;

  LogInModel(
      {
        this.id,
        this.FirstName,
        this.LastName,
        required this.Username,
        required this.Password,
        this.UserType});

  factory LogInModel.fromJson(Map<String, dynamic> json) {
    return LogInModel(
      id: json['id'],
      FirstName: json['FirstName'],
      LastName: json['LastName'],
      Username: json['Username'],
      Password: json['Password'],
      UserType: json['UserType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'FirstName': FirstName,
      'LastName': LastName,
      'Username': Username,
      'Password': Password,
      'UserType': UserType,
    };
  }
//
// @override
// String toString() {
//   return 'User(id: $id, name: $name, email: $email)';
// }
}
