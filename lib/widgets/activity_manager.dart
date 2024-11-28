// lib/widgets/activity_manager.dart

import 'package:flutter/material.dart';
import '../models/activity.dart';

class ActivityManager extends StatefulWidget {
  final Activity? activity;
  final Function(Activity) onSave;
  final int dayNumber;

  const ActivityManager({
    super.key,
    this.activity,
    required this.onSave,
    required this.dayNumber,
  });

  @override
  State<ActivityManager> createState() => _ActivityManagerState();
}

class _ActivityManagerState extends State<ActivityManager> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay(
    hour: TimeOfDay.now().hour + 1,
    minute: TimeOfDay.now().minute,
  );

  @override
  void initState() {
    super.initState();
    if (widget.activity != null) {
      _nameController.text = widget.activity!.name;
      _timeController.text = widget.activity!.timeRange;
      _locationController.text = widget.activity!.location ?? '';
      _descriptionController.text = widget.activity!.description ?? '';

      // Parse existing time range if editing
      try {
        final times = widget.activity!.timeRange.split('-');
        _startTime = _parseTimeString(times[0].trim());
        _endTime = _parseTimeString(times[1].trim());
      } catch (e) {
        // Use default times if parsing fails
        _endTime = TimeOfDay(
          hour: _startTime.hour + 1,
          minute: _startTime.minute,
        );
      }
    }
    _updateTimeRangeText();
  }

  TimeOfDay _parseTimeString(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  void _updateTimeRangeText() {
    _timeController.text =
        '${_formatTime(_startTime)}-${_formatTime(_endTime)}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _selectTime(bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFFCE816D),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFCE816D),
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
          // Automatically set end time 1 hour after start time if end time is before start time
          if (_endTime.hour < _startTime.hour ||
              (_endTime.hour == _startTime.hour &&
                  _endTime.minute <= _startTime.minute)) {
            _endTime = TimeOfDay(
              hour: _startTime.hour + 1,
              minute: _startTime.minute,
            );
          }
        } else {
          // Only update end time if it's after start time
          if (picked.hour > _startTime.hour ||
              (picked.hour == _startTime.hour &&
                  picked.minute > _startTime.minute)) {
            _endTime = picked;
          } else {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('End time must be after start time'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
        _updateTimeRangeText();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.activity == null
                  ? 'Add Activity for Day ${widget.dayNumber}'
                  : 'Edit Activity for Day ${widget.dayNumber}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNameField(),
                  const SizedBox(height: 16),
                  _buildTimeField(),
                  const SizedBox(height: 16),
                  _buildLocationField(),
                  const SizedBox(height: 16),
                  _buildDescriptionField(),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCE816D),
                  ),
                  onPressed: _handleSave,
                  child: Text(
                    widget.activity == null ? 'Add' : 'Save',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Activity Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.event),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an activity name';
        }
        return null;
      },
    );
  }

  Widget _buildTimeField() {
    return TextFormField(
      controller: _timeController,
      decoration: InputDecoration(
        labelText: 'Time Range',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.access_time),
        suffixIcon: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () async {
            await _selectTime(true);
            if (mounted) {
              await _selectTime(false);
            }
          },
        ),
      ),
      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a time range';
        }
        return null;
      },
    );
  }

  Widget _buildLocationField() {
    return TextFormField(
      controller: _locationController,
      decoration: const InputDecoration(
        labelText: 'Location (Optional)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.location_on),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description (Optional)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description),
      ),
      maxLines: 3,
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        Activity(
          name: _nameController.text,
          timeRange: _timeController.text,
          imageUrl: widget.activity?.imageUrl ?? 'assets/default.jpg',
          location: _locationController.text.isEmpty
              ? null
              : _locationController.text,
          description: _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
