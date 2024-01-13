import 'package:flutter/cupertino.dart';

class BlockListModel {
  final String id;
  final BlockUser blockBy;
  final BlockUser blockTo;

  BlockListModel(
      {required this.id, required this.blockBy, required this.blockTo});

  factory BlockListModel.fromJson(Map<String, dynamic> json) {
    // Extracting the 'token' from within the nested 'data' map
    var blockBy = json['blockBy'] as Map<String, dynamic>;
    var blockTo = json['blockTo'] as Map<String, dynamic>;
    debugPrint("blockTo $blockTo");
    debugPrint("blockBy $blockBy");
    return BlockListModel(
        id: json['_id']?.toString() ?? "",
        blockBy: BlockUser.fromJson(blockBy),
        blockTo: BlockUser.fromJson(blockTo));
  }
}

class BlockUser {
  final String id;
  final String name;
  final String email;
  final String photo;

  BlockUser(
      {required this.id,
      required this.name,
      required this.email,
      required this.photo});

  factory BlockUser.fromJson(Map<String, dynamic> json) {
    return BlockUser(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? json['userId']?.toString() ?? "",
      name: json['name']?.toString() ?? "",
      email: json['email']?.toString() ?? "",
      photo: json['photo']?.toString() ?? "",
    );
  }
}
