import 'package:floor/floor.dart';
import '../entities/task.dart';

@dao
abstract class TaskDao {
  @Query('SELECT * FROM Task')
  Future<List<Task>> findAllTasks();

  @Query('SELECT * FROM Task WHERE categoryId = :id')
  Future<List<Task>> findAllTasksFromCategory(int id);

  @insert
  Future<void> insertTask(Task task);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateTask(Task task);

  @delete
  Future<void> deleteTask(Task task);

  @Query('DELETE FROM Task')
  Future<void> deleteAll();
}
