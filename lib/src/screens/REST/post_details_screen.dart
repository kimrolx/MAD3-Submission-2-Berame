import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/post_model.dart';

class PostDetailsScreen extends StatefulWidget {
  static const String route = "postdetails";
  static const String path = "/postdetails";
  static const String name = "Post Details Screen";

  final Post post;
  const PostDetailsScreen({super.key, required this.post});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  late Post editablePost;
  late TextEditingController titleController;
  late TextEditingController bodyController;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    editablePost = widget.post;
    titleController = TextEditingController(text: widget.post.title);
    bodyController = TextEditingController(text: widget.post.body);
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "Post ${widget.post.id}",
                maxLines: 3,
                overflow: TextOverflow.visible,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        actions: [
          isEditing
              ? TextButton(
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () => _savePost(context),
                )
              : IconButton(
                  icon: const Icon(CupertinoIcons.pencil),
                  onPressed: () {
                    setState(() {
                      isEditing = true;
                    });
                  },
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              readOnly: !isEditing,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(labelText: "Title"),
              maxLines: null,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bodyController,
              readOnly: !isEditing,
              style: const TextStyle(
                fontSize: 16,
              ),
              decoration: const InputDecoration(labelText: "Body"),
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }

  void _savePost(BuildContext context) {
    setState(() {
      editablePost = editablePost.copyWith(
        title: titleController.text,
        body: bodyController.text,
      );
      isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post updated!')),
    );
  }
}
