import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import 'utils/rest_localstorage_util.dart';
import 'components/post_add_dialog.dart';
import 'components/post_summary_card.dart';

class RestDemoScreen extends StatefulWidget {
  static const String route = "/";
  static const String path = "/restdemo";
  static const String name = "Rest Demo Screen";
  const RestDemoScreen({super.key});

  @override
  State<RestDemoScreen> createState() => _RestDemoScreenState();
}

class _RestDemoScreenState extends State<RestDemoScreen> {
  PostController controller = PostController();

  @override
  void initState() {
    super.initState();
    controller.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
        actions: [
          IconButton(
              onPressed: () {
                controller.getPosts();
                print("Getting posts...");
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Center(
                child: Text(
                  'REST DEMO',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Add Post'),
              onTap: () {
                showNewPostFunction(context);
              },
            ),
            ListTile(
              title: const Text('Clear Local Storage'),
              onTap: () async {
                await LocalStorage.clearPosts();
                print("Local storage cleared successfully.");
                controller.getPosts();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            if (controller.error != null) {
              return Center(child: Text(controller.error.toString()));
            }

            if (!controller.working) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: controller.postList.map((Post post) {
                    return SummaryCard(
                      post: post,
                      onDelete: () {
                        controller.deletePost(post.id);
                      },
                    );
                  }).toList(),
                ),
              );
            }

            return const Center(
              child: SpinKitChasingDots(
                size: 54,
                color: Colors.black87,
              ),
            );
          },
        ),
      ),
    );
  }

  void showNewPostFunction(BuildContext context) async {
    bool? postAdded = await AddPostDialog.show(context, controller: controller);
    if (postAdded == true) {
      Navigator.of(context).pop();
      controller.getPosts();
    }
  }
}

class PostController with ChangeNotifier {
  Map<String, dynamic> posts = {};
  bool working = true;
  Object? error;

  List<Post> get postList => posts.values.whereType<Post>().toList();

  clear() {
    error = null;
    posts = {};
    notifyListeners();
  }

  void deletePost(int postId) {
    posts.remove(postId.toString());
    notifyListeners();

    LocalStorage.deletePost(postId);
  }

  Future<Post> makePost(
      {required String title,
      required String body,
      required int userId}) async {
    try {
      working = true;
      notifyListeners();

      http.Response res = await HttpService.get(
          url: "https://jsonplaceholder.typicode.com/posts");

      int maxApiId = 0;
      if (res.statusCode == 200) {
        List<dynamic> apiPosts = jsonDecode(res.body);
        maxApiId = apiPosts.map<int>((p) => p['id']).reduce(max);
      } else {
        throw Exception(
            "Failed to fetch posts: ${res.statusCode} | ${res.body}");
      }

      List<Post> currentPosts = await LocalStorage.readPosts();
      int maxLocalId = currentPosts.isEmpty
          ? 0
          : currentPosts.map<int>((p) => p.id).reduce(max);

      int newId = max(maxApiId, maxLocalId) + 1;

      Post newPost = Post(id: newId, title: title, body: body, userId: userId);

      currentPosts.add(newPost);

      await LocalStorage.writePosts(currentPosts);

      posts[newId.toString()] = newPost;
      notifyListeners();

      return newPost;
    } catch (e) {
      error = e;
      notifyListeners();
      return Future.error(e);
    } finally {
      working = false;
      notifyListeners();
    }
  }

  Future<void> getPosts() async {
    try {
      working = true;
      notifyListeners();

      http.Response res = await HttpService.get(
          url: "https://jsonplaceholder.typicode.com/posts");

      if (res.statusCode == 200) {
        List<dynamic> apiResult = jsonDecode(res.body);
        List<Post> fetchedPosts =
            apiResult.map((e) => Post.fromJson(e)).toList();
        print("Posts fetched from API: ${fetchedPosts.length}");

        List<Post> storedPosts = await LocalStorage.readPosts();
        print("Posts read from local storage: ${storedPosts.length}");

        Map<String, Post> updatedPosts = {};

        for (Post p in fetchedPosts) {
          updatedPosts[p.id.toString()] = p;
        }

        for (Post p in storedPosts) {
          updatedPosts.putIfAbsent(p.id.toString(), () => p);
        }

        print("Number of posts after merge: ${updatedPosts.length}");
        posts = updatedPosts;
        notifyListeners();
      } else {
        throw Exception(
            "Failed to fetch posts: ${res.statusCode} | ${res.body}");
      }
    } catch (e, st) {
      error = e;
      print(e);
      print(st);
      notifyListeners();
    } finally {
      working = false;
      notifyListeners();
    }
  }
}

class UserController with ChangeNotifier {
  Map<String, dynamic> users = {};
  bool working = true;
  Object? error;

  List<User> get userList => users.values.whereType<User>().toList();

  getUsers() async {
    try {
      working = true;
      List result = [];
      http.Response res = await HttpService.get(
          url: "https://jsonplaceholder.typicode.com/users");
      if (res.statusCode != 200 && res.statusCode != 201) {
        throw Exception("${res.statusCode} | ${res.body}");
      }
      result = jsonDecode(res.body);

      List<User> tmpUser = result.map((e) => User.fromJson(e)).toList();
      users = {for (User u in tmpUser) "${u.id}": u};
      working = false;
      notifyListeners();
    } catch (e, st) {
      print(e);
      print(st);
      error = e;
      working = false;
      notifyListeners();
    }
  }

  clear() {
    users = {};
    notifyListeners();
  }
}

class HttpService {
  static Future<http.Response> get(
      {required String url, Map<String, dynamic>? headers}) async {
    Uri uri = Uri.parse(url);
    return http.get(uri, headers: {
      'Content-Type': 'application/json',
      if (headers != null) ...headers
    });
  }

  static Future<http.Response> post(
      {required String url,
      required Map<dynamic, dynamic> body,
      Map<String, dynamic>? headers}) async {
    Uri uri = Uri.parse(url);
    return http.post(uri, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
      if (headers != null) ...headers
    });
  }
}
