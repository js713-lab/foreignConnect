// lib/widgets/todo_list_widget.dart

import 'package:flutter/material.dart';
import '../models/todo_item.dart';

class TodoListWidget extends StatefulWidget {
  final String title;
  final List<TodoItem> items;
  final Function(List<TodoItem>) onUpdateItems;

  const TodoListWidget({
    super.key,
    required this.title,
    required this.items,
    required this.onUpdateItems,
  });

  @override
  State<TodoListWidget> createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  final TextEditingController _newItemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _showAddDialog,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return Dismissible(
                  key: Key('${item.title}_$index'),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => _handleDismiss(index, item),
                  child: CheckboxListTile(
                    title: Text(
                      item.title,
                      style: TextStyle(
                        decoration: item.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: item.isCompleted ? Colors.grey : Colors.black,
                      ),
                    ),
                    value: item.isCompleted,
                    onChanged: (bool? value) {
                      setState(() {
                        widget.items[index].isCompleted = value ?? false;
                        widget.onUpdateItems(widget.items);
                      });
                    },
                    secondary: item.isCompleted
                        ? const Icon(Icons.check_circle,
                            color: Color(0xFFCE816D))
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Item'),
        content: TextField(
          controller: _newItemController,
          decoration: const InputDecoration(
            hintText: 'Enter item title',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (_) => _addNewItem(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCE816D),
            ),
            onPressed: _addNewItem,
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _addNewItem() {
    if (_newItemController.text.isNotEmpty) {
      setState(() {
        widget.items.add(
          TodoItem(title: _newItemController.text),
        );
        widget.onUpdateItems(widget.items);
        _newItemController.clear();
      });
      Navigator.pop(context);
    }
  }

  void _handleDismiss(int index, TodoItem item) {
    setState(() {
      widget.items.removeAt(index);
      widget.onUpdateItems(widget.items);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.title} removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              widget.items.insert(index, item);
              widget.onUpdateItems(widget.items);
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _newItemController.dispose();
    super.dispose();
  }
}
