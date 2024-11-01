// import 'package:recomendiaa/models/user_model.dart';

abstract class AuthServiceInterface {
  Future<dynamic> signIn(String? email, String? password);

  Future<dynamic> signUp(String? email, String? password);
}
