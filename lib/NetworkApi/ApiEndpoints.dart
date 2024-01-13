abstract class ApiEndpoints {
  // Static fields for endpoints
  static const String socketUrl = 'http://127.0.0.1:3000';
  static const String baseUrl = 'http://127.0.0.1:3000/api/v1';
  static const String loginEndpoint = '/users/login';
  static const String signUpEndpoint = '/users/signup';
  static const String usersEndpoint = '/users';
  static const String blockOperationEndpoint = '/users/block';

/* Socket End Points*/

  static const String receiveMessage = 'receiveMessage';
  static const String sendMessage = 'sendMessage';
  static const String success = 'success';
  static const String fail = 'success';
  static const String oneToOneChat = 'one_to_one_chat';
  static const String oneToOneStatus = 'one_to_one_status';
}
