import 'package:hive_flutter/adapters.dart';
import 'package:task_list/domain/models/task_model.dart';

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final typeId = 1;
  @override
  Task read(BinaryReader reader) {
    // Проверяй данные!
    return Task(
        descriptions: reader.read() as String,
        status: reader.read() as int,
        hours: reader.read() as double,
        temporaryUUID: reader.read() as String,
        comments: reader.read() as List<String>,
        id: reader.read() as int,
        title: reader.read() as String);
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    // Используй каскадную нотацию через ..
    writer.write(obj.id);
    writer.write(obj.title);
    writer.write(obj.descriptions);
    writer.write(obj.comments);
    writer.write(obj.hours);
    writer.write(obj.status);
    writer.write(obj.temporaryUUID);
  }
}
