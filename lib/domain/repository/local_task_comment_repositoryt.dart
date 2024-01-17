import 'dart:async';
import 'dart:ffi';

import 'package:task_list/data/hive_local_storage/comment_hive_local_storage.dart';
import 'package:task_list/domain/models/hive_models/comments_model.dart';
import 'package:task_list/domain/models/hive_models/task.dart';

class LocalCommentRepository {
  final _commentBox = CommentHiveLocalStorage().refreshBox();
  late StreamController<List<Comment>> _commentsController;
  final Task task;

  LocalCommentRepository({required this.task}) {
    _commentsController = StreamController<List<Comment>>.broadcast();
    _loadTasks();
  }

  Stream<List<Comment>> get commentsStream => _commentsController.stream;

  void _loadTasks() {
    _updateComments(); // TODO

    _commentBox.watch().listen((event) {
      _updateComments(); //TODO
    });
  }

  List<Comment> getListComments() {
    return _commentBox.values.where((element) => task.comments.contains(element)).toList();
  }

  Future<void> saveComment(Comment comment) async {
    await CommentHiveLocalStorage().addComment(task, comment);
  }

  void _updateComments() {
    List<Comment> listComment = _commentBox.values
        .where((comment) => task.comments.contains(comment))
        .toList();

    _commentsController.add(listComment);
  }

  void dispose() {
    _commentsController.close();
  }
}
