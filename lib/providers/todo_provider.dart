import 'package:flutter/foundation.dart';
import '../models/todo.dart';
import '../services/todo_database_service.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  List<Todo> get pendingTodos =>
      _todos.where((todo) => !todo.isCompleted).toList();

  List<Todo> get completedTodos =>
      _todos.where((todo) => todo.isCompleted).toList();

  int get todoCount => _todos.length;
  int get pendingCount => pendingTodos.length;
  int get completedCount => completedTodos.length;

  // Initialize and load todos from database
  Future<void> loadTodos() async {
    _todos = TodoDatabaseService.getAllTodos();
    // Sort by creation date (newest first)
    _todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  // Add new todo
  Future<void> addTodo(Todo todo) async {
    await TodoDatabaseService.addTodo(todo);
    await loadTodos();
  }

  // Update todo
  Future<void> updateTodo(Todo todo) async {
    await TodoDatabaseService.updateTodo(todo);
    await loadTodos();
  }

  // Delete todo
  Future<void> deleteTodo(String id) async {
    await TodoDatabaseService.deleteTodo(id);
    await loadTodos();
  }

  // Toggle completion status
  Future<void> toggleTodo(String id) async {
    final todo = _todos.firstWhere((t) => t.id == id);
    todo.toggle();
    await TodoDatabaseService.updateTodo(todo);
    await loadTodos();
  }

  // Get todo by id
  Todo? getTodoById(String id) {
    try {
      return _todos.firstWhere((todo) => todo.id == id);
    } catch (e) {
      return null;
    }
  }

  // Sort by priority
  List<Todo> getTodosByPriority() {
    final sortedTodos = List<Todo>.from(_todos);
    sortedTodos.sort((a, b) {
      // First sort by completion status
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      // Then by priority (high to low)
      return b.priority.index.compareTo(a.priority.index);
    });
    return sortedTodos;
  }

  // Clear all todos
  Future<void> clearAll() async {
    await TodoDatabaseService.clearAll();
    await loadTodos();
  }
}
