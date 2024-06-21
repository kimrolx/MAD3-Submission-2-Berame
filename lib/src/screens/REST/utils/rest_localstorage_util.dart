import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import '../../../models/post_model.dart';

class LocalStorage {
  //* Get the local path for storing data
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  //* Get the file for storing posts
  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/posts.json');
  }

  //* Clear the localstorage by deleting the file.
  static Future<void> clearPosts() async {
    try {
      final file = await _localFile;
      await file.delete();
    } catch (e) {
      print("Error clearing local storage: $e");
    }
  }

  //* Write data to the file
  static Future<File> writePosts(List<Post> posts) async {
    final file = await _localFile;
    String json = jsonEncode(posts.map((post) => post.toJson()).toList());
    return file.writeAsString(json);
  }

  //* Read posts from file
  static Future<List<Post>> readPosts() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      List<dynamic> jsonData = jsonDecode(contents);
      return jsonData.map<Post>((data) => Post.fromJson(data)).toList();
    } catch (e) {
      return [];
    }
  }

  //* Delete post
  static Future<void> deletePost(int postId) async {
    try {
      List<Post> posts = await readPosts();
      posts = posts.where((post) => post.id != postId).toList();
      await writePosts(posts);
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }
}
