import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Chatting/ChattingScreenModel.dart';
import '../Home/HomeScreenModel.dart';

class DatabaseHelper {
  static Future<Database> getDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'my_database.db'),
      onCreate: (db, version) {
        db.execute('''CREATE TABLE users(
          id TEXT PRIMARY KEY, 
          username TEXT, 
          email TEXT, 
          photo TEXT, 
          message TEXT, 
          date TEXT, 
          count INTEGER)''');
        db.execute('''CREATE TABLE chats(
          messageId TEXT PRIMARY KEY, 
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
  Future<void> removeUsers(List<String> ids) async {
    final db = await getDatabase();
    String idsInString = ids.map((id) => "'$id'").join(', ');
    await db.rawDelete('DELETE FROM users WHERE id IN ($idsInString)');
  }

// Select all Users, newest dates first
  Future<List<HomeScreenModel>> getUsers() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps =
        await db.query('users', orderBy: 'date DESC');
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
    await db.insert('chats', chat.toJson());
  }

// Remove a Chat message
  Future<void> removeChatMessage(String messageId) async {
    final db = await getDatabase();
    await db.delete('chats', where: 'messageId = ?', whereArgs: [messageId]);
  }

// Remove Chat messages by multiple message IDs
  Future<void> removeChatMessages(List<String> messageIds) async {
    final db = await getDatabase();
    String idsInString = messageIds.map((id) => "'$id'").join(', ');
    await db.rawDelete('DELETE FROM chats WHERE messageId IN ($idsInString)');
  }

// Select all Chat messages, newest dates first, with pagination
  Future<List<ChattingScreenModel>> getChatMessages(int offset) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'chats',
      orderBy: 'date DESC',
      limit: 10,
      offset: offset,
    );
    return List.generate(maps.length, (i) {
      return ChattingScreenModel.fromJson(maps[i]);
    });
  }

// Update a Chat message
  Future<void> updateChatMessage(ChattingScreenModel chat) async {
    final db = await getDatabase();
    await db.update(
      'chats',
      chat.toJson(),
      where: 'messageId = ?',
      whereArgs: [chat.messageId],
    );
  }
}