import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';

class AddTodoScreen extends StatefulWidget {
  final String? todoId;

  const AddTodoScreen({super.key, this.todoId});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TodoPriority _selectedPriority = TodoPriority.medium;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    if (widget.todoId != null) {
      _isEditMode = true;
      _loadTodoData();
    }
  }

  void _loadTodoData() {
    final provider = context.read<TodoProvider>();
    final todo = provider.getTodoById(widget.todoId!);
    if (todo != null) {
      _titleController.text = todo.title;
      _descriptionController.text = todo.description;
      _selectedPriority = todo.priority;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTodo() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<TodoProvider>();

    if (_isEditMode) {
      final todo = provider.getTodoById(widget.todoId!)!;
      todo.title = _titleController.text.trim();
      todo.description = _descriptionController.text.trim();
      todo.priority = _selectedPriority;
      await provider.updateTodo(todo);
    } else {
      final todo = Todo(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        createdAt: DateTime.now(),
        priority: _selectedPriority,
      );
      await provider.addTodo(todo);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: ResponsiveHelper.getResponsivePadding(context),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleField(),
                        const SizedBox(height: 24),
                        _buildDescriptionField(),
                        const SizedBox(height: 32),
                        _buildPrioritySelector(),
                        const SizedBox(height: 40),
                        _buildSaveButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.paperMedium,
              side: BorderSide(
                color: AppColors.sketchBorder,
                width: 2,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            _isEditMode ? 'Edit Task' : 'New Task',
            style: GoogleFonts.indieFlower(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 28),
              fontWeight: FontWeight.bold,
              color: AppColors.inkDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task Title',
          style: GoogleFonts.indieFlower(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 20),
            fontWeight: FontWeight.bold,
            color: AppColors.inkDark,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _titleController,
          style: GoogleFonts.indieFlower(
            fontSize: 18,
            color: AppColors.inkDark,
          ),
          decoration: InputDecoration(
            hintText: 'What needs to be done?',
            hintStyle: GoogleFonts.indieFlower(
              color: AppColors.textSecondary,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a task title';
            }
            return null;
          },
          textCapitalization: TextCapitalization.sentences,
          maxLength: 100,
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Details (optional)',
          style: GoogleFonts.indieFlower(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 20),
            fontWeight: FontWeight.bold,
            color: AppColors.inkDark,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: const InputDecoration(
            hintText: 'Add more details...',
          ),
          maxLines: 5,
          maxLength: 500,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: GoogleFonts.indieFlower(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 20),
            fontWeight: FontWeight.bold,
            color: AppColors.inkDark,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: TodoPriority.values.map((priority) {
            final isSelected = _selectedPriority == priority;
            final bgColor = _getPriorityColor(priority);

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPriority = priority;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: bgColor.withValues(alpha: isSelected ? 1.0 : 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.sketchBorder,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: bgColor.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          priority.emoji,
                          style: TextStyle(
                            fontSize: isSelected ? 28 : 24,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          priority.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color: AppColors.inkDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _saveTodo,
        icon: Icon(_isEditMode ? Icons.check : Icons.add),
        label: Text(_isEditMode ? 'Update Task' : 'Add Task'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
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
