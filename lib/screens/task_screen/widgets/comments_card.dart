import 'package:flutter/material.dart';
import 'package:task_list/domain/models/comments_model.dart';

class CommentsCard extends StatelessWidget {
  final Comment comment;
  const CommentsCard({required this.comment, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(comment.id),
        subtitle: Text(comment.descriptions, maxLines: 6),
      ),
    );
  }
}
