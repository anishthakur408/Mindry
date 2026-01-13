import 'package:hive_flutter/hive_flutter.dart';
import '../models/todo.dart';

class TodoDatabaseService {
  static const String _boxName = 'todos';

  static Future<void> init() async {
    // Register adapter if not already registered
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TodoAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(TodoPriorityAdapter());
    }
    await Hive.openBox<Todo>(_boxName);
  }

  static Box<Todo> _getBox() {
    return Hive.box<Todo>(_boxName);
  }

  // Create
  static Future<void> addTodo(Todo todo) async {
    final box = _getBox();
    await box.put(todo.id, todo);
  }

  // Read all
  static List<Todo> getAllTodos() {
    final box = _getBox();
    return box.values.toList();
  }

  // Read by id
  static Todo? getTodoById(String id) {
    final box = _getBox();
    return box.get(id);
  }

  // Update
  static Future<void> updateTodo(Todo todo) async {
    final box = _getBox();
    await box.put(todo.id, todo);
  }

  // Delete
  static Future<void> deleteTodo(String id) async {
    final box = _getBox();
    await box.delete(id);
  }

  // Get pending todos
  static List<Todo> getPendingTodos() {
    return getAllTodos().where((todo) => !todo.isCompleted).toList();
  }

  // Get completed todos
  static List<Todo> getCompletedTodos() {
    return getAllTodos().where((todo) => todo.isCompleted).toList();
  }

  // Clear all
  static Future<void> clearAll() async {
    final box = _getBox();
    await box.clear();
  }

  // Get count by status
  static int getPendingCount() {
    return getPendingTodos().length;
  }

  static int getCompletedCount() {
    return getCompletedTodos().length;
  }
}
