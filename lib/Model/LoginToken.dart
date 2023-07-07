import 'package:recipebox/Model/LogInModel.dart';

class LoginToken{
    String? token;
    LogInModel? user;

    LoginToken({
        //   this.id,
        this.token,
        this.user
    });

    factory LoginToken.fromJson(Map<String, dynamic> json) {
        return LoginToken(
            //id: json['id'],
            token: json['token'],
            user : LogInModel.fromJson(json['user'])
        );
    }

    Map<String, dynamic> toJson() {
        return {
            // 'id': id,
            'token': token,
            'user' : user
        };
    }
//
// @override
// String toString() {
//   return 'User(id: $id, name: $name, email: $email)';
// }
}