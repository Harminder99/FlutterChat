import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Chatting/ChattingScreenModel.dart';
import '../Home/HomeScreenModel.dart';
import '../NetworkApi/HeaderService.dart';

class DatabaseHelper {
  static Future<Database> getDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'chat_base.db'),
      onCreate: (db, version) {
        db.execute('''CREATE TABLE users(
          id TEXT PRIMARY KEY,
          loginId TEXT, 
          name TEXT, 
          email TEXT, 
          photo TEXT, 
          message TEXT, 
          date TEXT, 
          count INTEGER)''');
        db.execute('''CREATE TABLE chats(
          messageId TEXT PRIMARY KEY, 
          loginId TEXT,
          isSender INTEGER, 
          message TEXT, 
          date TEXT, 
          status TEXT, 
          receiverId TEXT,
          FOREIGN KEY (receiverId) REFERENCES users (id))''');
      },
      version: 1,
    );
  }

// Add a User
  Future<void> addUser(HomeScreenModel user) async {
    debugPrint("DATABASE INIT");
    final db = await getDatabase();
    await db.insert(
      'users',
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Remove a User
  Future<void> removeUser(String id) async {
    final db = await getDatabase();
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

// Remove Users by multiple IDs
  Future<void> removeUsers(Set<String> ids) async {
    final db = await getDatabase();
    String idsInString = ids.map((id) => "'$id'").join(', ');
    await db.rawDelete('DELETE FROM users WHERE id IN ($idsInString)');
  }

// Select all Users, newest dates first
  Future<List<HomeScreenModel>> getUsers() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps =
        await db.query('users', orderBy: 'date DESC');
    debugPrint("$maps");
    return List.generate(maps.length, (i) {
      return HomeScreenModel.fromJson(maps[i]);
    });
  }

  Future<List<HomeScreenModel>> getUsersByLoginId() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('users',
        where: 'loginId = ?', // Add where clause
        whereArgs: [Global.userId], // Pass loginId as argument
        orderBy: 'date DESC');
    debugPrint("$maps");
    return List.generate(maps.length, (i) {
      return HomeScreenModel.fromJson(maps[i]);
    });
  }

// Update User
  Future<void> updateUser(HomeScreenModel user) async {
    final db = await getDatabase();
    await db.update(
      'users',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  /// ********************Chat Operation******************************
// Add a Chat message
  Future<void> addChatMessage(ChattingScreenModel chat) async {
    final db = await getDatabase();
    final json = chat.toDatabaseJson();
    debugPrint("json ==> $json");
    addUser(HomeScreenModel.updateModelFromChatModel(chat,0));
    await db.insert('chats', json);
  }

// Remove a Chat message
  Future<void> removeChatMessage(String messageId) async {
    final db = await getDatabase();
    await db.delete('chats', where: 'messageId = ?', whereArgs: [messageId]);
  }

// Remove Chat messages by multiple message IDs
  Future<void> removeChatMessages(Set<String> messageIds) async {
    final db = await getDatabase();
    String idsInString = messageIds.map((id) => "'$id'").join(', ');
    await db.rawDelete('DELETE FROM chats WHERE messageId IN ($idsInString)');
  }

  // Remove all messages
  Future<void> removeAllMessages(String receiverId) async {
    final db = await getDatabase();
    await db.delete(
      'chats',
      where: 'receiverId = ? AND loginId = ?',
      whereArgs: [receiverId, Global.userId],
    );
  }

// Select all Chat messages, newest dates first, with pagination
  Future<List<ChattingScreenModel>> getChatMessages(int offset, String receiverId) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'chats',
      where: 'receiverId = ? AND loginId = ?',
      whereArgs: [receiverId, Global.userId],
      orderBy: 'date ASC',
      limit: 10,
      offset: offset,
    );
    debugPrint("Chat generate==> ${maps.length}");
    return List.generate(maps.length, (i) {
      return ChattingScreenModel.fromDatabaseJson(maps[i]);
    });
  }

// Update a Chat message
  Future<void> updateChatMessage(ChattingScreenModel chat) async {
    final db = await getDatabase();
    final json = chat.toDatabaseJson();
    await db.update(
      'chats',
      json,
      where: 'messageId = ?',
      whereArgs: [chat.messageId],
    );
  }
}
