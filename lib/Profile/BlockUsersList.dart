import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/Login/LoginModel.dart';
import 'package:untitled2/Profile/BlockListModel.dart';
import 'package:untitled2/Profile/BlockUsersListViewModel.dart';

class BlockUsersList extends StatefulWidget {
  const BlockUsersList({super.key});

  @override
  _BlockUsersListState createState() => _BlockUsersListState();
}

class _BlockUsersListState extends State<BlockUsersList> {
  List<BlockListModel> blockedUsers = [];
  bool isLoading = true;
  BlockUsersListViewModel? viewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = BlockUsersListViewModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUsers();
    });
  }

  void getUsers() {
    setState(() {
      isLoading:
      true;
    });
    viewModel?.getBlockedUsers((msg, List<BlockListModel>? items) {
      debugPrint("$msg $items");
      int page = viewModel?.page ?? 1;

      if (items != null) {
        if (page <= 1) {
          setState(() {
            isLoading = false;
            blockedUsers = items!;
          });
        } else {
          setState(() {
            isLoading = false;
            blockedUsers.addAll(items!);
          });
        }
      } else {
        // make loader false
        debugPrint("make loader false");
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("isLoading ==> $isLoading");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocked Users'),
      ),
      body: Stack(children: [
        ListView.builder(
          itemCount: blockedUsers.length,
          itemBuilder: (context, index) {
            return _buildUserListItem(blockedUsers[index], index);
          },
        ),
        if (isLoading && blockedUsers.isEmpty)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              // Semi-transparent background
              child: const Center(
                child: CircularProgressIndicator(), // Loader widget
              ),
            ),
          ),
        if (!isLoading && blockedUsers.isEmpty)
          const Center(
            child: Text("No user found"), // Loader widget
          )
      ]),
    );
  }

  Widget _buildUserListItem(BlockListModel user, int index) {
    void blockDialog() {
      viewModel?.blockDialog(user.blockTo.id, index, context, (isSuccess) {
        List<BlockListModel> users = blockedUsers;
        if (isSuccess) {
          setState(() {
            isLoading = false;
            blockedUsers.removeAt(index);
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }, () {
        // start loader
        setState(() {
          isLoading = true;
        });
      });
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3,vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.blockTo.photo),
          radius: 30, // Adjust the radius as needed
        ),
        title: Text(user.blockTo.name),
        trailing: ElevatedButton(
          onPressed: blockDialog,
          child: const Text('Unblock'),
        ),
      ),
    );
  }
}
