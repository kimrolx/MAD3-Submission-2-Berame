import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/post_model.dart';
import '../../../routing/routes.dart';
import '../post_details_screen.dart';

class SummaryCard extends StatelessWidget {
  final Post post;
  final Function onDelete;
  const SummaryCard({super.key, required this.post, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          GlobalRouter.I.router.push(PostDetailsScreen.path, extra: post);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        post.title,
                        maxLines: 3,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => onDelete(),
                      icon: const Icon(CupertinoIcons.delete),
                    ),
                  ],
                ),
                Text(
                  "Post Id: ${post.id}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  post.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
