import 'dart:io';
import 'dart:developer' as dev;
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_list/data/hive_local_storage/importan_fields_hive_ld.dart';
import 'package:task_list/domain/models/hive_models/comments_model.dart';
import 'package:task_list/domain/models/hive_models/fields.dart';
import 'package:task_list/domain/models/hive_models/task.dart';

Future<String> initHivePath() async{

  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);
  print(appDocumentDirectory.path);

  return appDocumentDirectory.path;


}

registerAdapter() async{
  await registerAdapterTask();
  await registerAdapterComment();
  await registerAdapterImportantFieldsAdapter();
}


Future<void> openBox() async {

  await openBox1();
  await openBox2();
  await openBox3();
}


openBox1() async {
  try {
    await Hive.openBox<Task>('taskBox');
  } on HiveError catch (error) {
    dev.log('Ошибка при открытии taskBox: $error');
  }
}

openBox2() async {
  try {
    await Hive.openBox<Comment>('commentBox');
  } on HiveError catch (error) {
    dev.log('Ошибка при открытии commentBox: $error');
  }
}


openBox3() async{
  try{
    await Hive.openBox<ImportantFields>('importantFieldsBox');
  }
  on HiveError catch(error){
    dev.log('Ошибка при открытии ImportantFieldsBox: $error');
  }
}

registerAdapterImportantFieldsAdapter() async{
  try{
    Hive.registerAdapter(ImportantFieldsAdapter());
  }
  on HiveError catch(error){
    dev.log('Ошибка при регистрация ImportantFieldsAdapter: $error');
  }
}

registerAdapterTask() async{
  try{
    Hive.registerAdapter(TaskAdapter());
  }
  on HiveError catch (hiveError){
    dev.log('Ошибка при регистрации TaskAdapter: $hiveError');
  }
}

registerAdapterComment() async {
  try {
    Hive.registerAdapter(CommentAdapter());
  } on HiveError catch (error) {
    dev.log('Ошибка при регистрации CommentAdapter: $error');
  }
}
