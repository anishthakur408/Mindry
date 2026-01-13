import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import 'add_todo_screen.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Paper texture background
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/paper_texture.png'),
          repeat: ImageRepeat.repeat,
          opacity: 0.4,
        ),
        color: AppColors.backgroundColor,
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildTodoList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'To-Do List',
                style: GoogleFonts.indieFlower(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 36),
                  fontWeight: FontWeight.bold,
                  color: AppColors.inkDark,
                ),
              ),
              Consumer<TodoProvider>(
                builder: (context, provider, child) {
                  return Text(
                    '${provider.pendingCount} pending • ${provider.completedCount} completed',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppColors.textSecondary,
                        ),
                  );
                },
              ),
            ],
          ),
          FloatingActionButton(
            heroTag: 'add_todo',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddTodoScreen(),
                ),
              );
            },
            mini: true,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildTodoList(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, child) {
        if (provider.todos.isEmpty) {
          return _buildEmptyState(context);
        }

        final pending = provider.pendingTodos;
        final completed = provider.completedTodos;

        return SingleChildScrollView(
          padding: ResponsiveHelper.getResponsiveHorizontalPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (pending.isNotEmpty) ...[
                _buildSectionHeader(context, 'Pending', pending.length),
                const SizedBox(height: 12),
                ...pending
                    .map((todo) => _buildTodoCard(context, todo, provider)),
                const SizedBox(height: 24),
              ],
              if (completed.isNotEmpty) ...[
                _buildSectionHeader(context, 'Completed', completed.length),
                const SizedBox(height: 12),
                ...completed
                    .map((todo) => _buildTodoCard(context, todo, provider)),
              ],
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.sketchBorder,
                AppColors.sketchBorder.withValues(alpha: 0),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.indieFlower(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 24),
            fontWeight: FontWeight.bold,
            color: AppColors.inkDark,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: title == 'Pending'
                ? AppColors.watercolorYellow
                : AppColors.watercolorGreen,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.sketchBorder,
              width: 1,
            ),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.inkDark,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.sketchBorder.withValues(alpha: 0),
                  AppColors.sketchBorder,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTodoCard(
      BuildContext context, Todo todo, TodoProvider provider) {
    final bgColor = todo.isCompleted
        ? AppColors.watercolorGreen
        : AppColors.watercolorYellow;

    final priorityColor = _getPriorityColor(todo.priority);

    return Dismissible(
      key: Key(todo.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.watercolorPink,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        provider.deleteTodo(todo.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Todo deleted'),
            backgroundColor: AppColors.watercolorPink,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.sketchBorder,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 4,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Checkbox
            GestureDetector(
              onTap: () => provider.toggleTodo(todo.id),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color:
                      todo.isCompleted ? AppColors.inkDark : Colors.transparent,
                  border: Border.all(
                    color: AppColors.sketchBorder,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: todo.isCompleted
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: GoogleFonts.indieFlower(
                      fontSize:
                          ResponsiveHelper.getResponsiveFontSize(context, 18),
                      fontWeight: FontWeight.bold,
                      color: AppColors.inkDark,
                      decoration:
                          todo.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (todo.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      todo.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.inkMedium,
                            decoration: todo.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // Priority badge
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: priorityColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.sketchBorder,
                  width: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '📝',
              style: TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks yet',
              style: GoogleFonts.indieFlower(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 24),
                fontWeight: FontWeight.bold,
                color: AppColors.inkDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to add your first task',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.high:
        return AppColors.watercolorPink;
      case TodoPriority.medium:
        return AppColors.watercolorBlue;
      case TodoPriority.low:
        return AppColors.watercolorPurple;
    }
  }
}
