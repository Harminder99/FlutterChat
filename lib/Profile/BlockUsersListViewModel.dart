import 'package:flutter/cupertino.dart';
import 'package:untitled2/Profile/BlockListModel.dart';

import '../Chatting/ReceiverProfile.dart';
import '../NetworkApi/ApiEndpoints.dart';
import '../NetworkApi/ApiResponse.dart';
import '../NetworkApi/ApiService.dart';
import '../NetworkApi/HeaderService.dart';
import '../Utiles/Dialogs.dart';
import 'BlockModel.dart';

class BlockUsersListViewModel {
  ApiService? _apiService;
  final int _page = 1;
  int limit = 20;
  int get page => _page;

  BlockUsersListViewModel() {
    _apiService = ApiService(HeaderService());
  }

  ApiService get apiService {
    _apiService ??= ApiService(HeaderService());
    return _apiService!;
  }

  void _blockUser(String id, int index,
      Function(bool isSuccess, String msg) onComplete) async {
    ApiResponse<BlockModel>? response = await _apiService?.post<BlockModel>(
      ApiEndpoints.blockOperationEndpoint,
      {
        "isBlock": false,
        'blockTo': id,
      },
      (json) {
        return BlockModel.fromJson(json);
      },
    );
    if (response != null && response!.isSuccess) {
      // Handle success scenario

      onComplete(true, response.data?.message ?? "");
    } else {
      // Handle error scenario
      ApiError? error = response?.error;
      debugPrint("Error: ${error?.message ?? "Something went wrong!"}");
      // Handle the error message as needed
      String msg = error?.message ?? "Something went wrong!";

      onComplete(false, msg);
    }
  }

  void getBlockedUsers(Function(String? msg, List<BlockListModel>? items) onComplete) async {
    ApiResponse<List<BlockListModel>>? response =
        await _apiService?.get<List<BlockListModel>>(
      ApiEndpoints.blockOperationEndpoint,
      "?page=$_page&limit=$limit",
      (json) {
        final data = json["data"];
        if (data is List) {
          return data
              .map((item) => BlockListModel.fromJson(item))
              .toList(); // Convert each item individually
        } else {
          debugPrint("Error in format");
          throw const FormatException("Invalid response format");
        }
      },
    );

    if (response != null && response!.isSuccess) {
      // Handle success scenario
      onComplete(null, response.data);
    } else {
      // Handle error scenario
      ApiError? error = response?.error;
      debugPrint("Error: ${error?.message ?? "Something went wrong!"}");
      // Handle the error message as needed
      String msg = error?.message ?? "Something went wrong!";

      onComplete(msg, null);
    }
  }

  void errorDialog(BuildContext context, String msg) {
    Dialogs dialog = Dialogs();
    dialog.showGenericDialog(
        context: context, title: "Alert!", message: msg, actions: null);
  }

  void blockDialog(String id, int index, BuildContext context,
      Function(bool isSuccess) onComplete, Function() onLoading) {
    Dialogs dialog = Dialogs();
    dialog.showGenericDialog(
        context: context,
        title: "Warning!",
        message: "Are you sure, you want to unblock?",
        actions: [
          DialogAction(
              label: "No",
              onPressed: () {
                Navigator.of(context).pop();
              }),
          DialogAction(
              label: "Yes",
              onPressed: () {
                onLoading();
                Navigator.of(context).pop();
                _blockUser(
                  id,
                  index,
                  (isSuccess, msg) {
                    if (isSuccess) {
                      onComplete(true);
                    }
                    errorDialog(context, msg);
                  },
                );
              })
        ]);
  }
}
