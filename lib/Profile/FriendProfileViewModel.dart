import 'package:flutter/cupertino.dart';

import '../Chatting/ReceiverProfile.dart';
import '../NetworkApi/ApiEndpoints.dart';
import '../NetworkApi/ApiResponse.dart';
import '../NetworkApi/ApiService.dart';
import '../NetworkApi/HeaderService.dart';
import 'BlockModel.dart';

class FriendProfileViewModel {
  ReceiverProfile? _receiverProfile;
  ApiService? _apiService;

  FriendProfileViewModel() {
    _apiService = ApiService(HeaderService());
  }

  ApiService get apiService {
    _apiService ??= ApiService(HeaderService());
    return _apiService!;
  }

  void setReceiverProfile(ReceiverProfile profile) {
    _receiverProfile = profile;
  }

  void blockUser(bool isBlock,Function(String? message, bool isSuccess) onComplete) async {
    ApiResponse<BlockModel>? response = await _apiService?.post<BlockModel>(
      ApiEndpoints.blockOperationEndpoint,
      {
        "isBlock": !isBlock,
        'blockTo': _receiverProfile?.id,
      },
      (json) {
        debugPrint("json ==> $json");
        return BlockModel.fromJson(json);
      },
    );
    if (response != null && response!.isSuccess) {
      // Handle success scenario

      onComplete(response.data?.message, true);
    } else {
      // Handle error scenario
      ApiError? error = response?.error;
      debugPrint("Error: ${error?.message ?? "Something went wrong!"}");
      // Handle the error message as needed
      onComplete(error?.message ?? "Something went wrong!", false);
    }
  }
}
