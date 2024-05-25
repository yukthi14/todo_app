import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import '../model/task_model.dart';

class TaskForm extends StatefulWidget {
  final Task? task;

  TaskForm({this.task});

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _deadline;
  late Duration _expectedDuration;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _description = widget.task!.description;
      _deadline = widget.task!.deadline;
      _expectedDuration = widget.task!.expectedDuration;
      _isCompleted = widget.task!.isCompleted;
    } else {
      _title = '';
      _description = '';
      _deadline = DateTime.now();
      _expectedDuration = const Duration(hours: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDeadline =
        DateFormat('dd-MM-yyyy \nh:mm a').format(_deadline);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.white),
          backgroundColor: AppColors.appBarColor,
          title: Text(
            widget.task == null ? Strings.newTaskText : Strings.editTaskText,
            style: const TextStyle(
                fontSize: 20,
                color: AppColors.white,
                fontWeight: FontWeight.w500),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                maxLines: null,
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: Strings.titleText,
                  labelStyle: const TextStyle(color: AppColors.appBarColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.appBarColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 12.0,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Strings.enterTitle;
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 20),
              TextFormField(
                maxLines: null,
                initialValue: _description,
                decoration: InputDecoration(
                  labelText: Strings.descriptionText,
                  labelStyle: const TextStyle(color: AppColors.appBarColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.appBarColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 12.0,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Strings.enterDescription;
                  }
                  return null;
                },
                onSaved: (value) => _description = value!,
              ),
              ListTile(
                title: Text(
                  'Deadline: ${formattedDeadline.toString()}',
                  style: const TextStyle(color: AppColors.appBarColor),
                ),
                trailing: const Icon(
                  Icons.calendar_today,
                  color: AppColors.black,
                ),
                onTap: _selectDeadline,
              ),
              ListTile(
                title: Text(
                  'Expected Duration: ${_expectedDuration.inHours} hours',
                  style: const TextStyle(color: AppColors.appBarColor),
                ),
                trailing: const Icon(
                  Icons.timer,
                  color: AppColors.black,
                ),
                onTap: _selectDuration,
              ),
              SwitchListTile(
                activeColor: AppColors.appBarColor,
                title: const Text(
                  Strings.completedText,
                  style: TextStyle(color: AppColors.appBarColor),
                ),
                value: _isCompleted,
                onChanged: (bool value) {
                  setState(() {
                    _isCompleted = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text(
                  widget.task == null
                      ? Strings.addTaskText
                      : Strings.updateTaskText,
                  style: const TextStyle(color: AppColors.appBarColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDeadline() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_deadline),
      );

      if (pickedTime != null) {
        setState(() {
          _deadline = DateTime(pickedDate.year, pickedDate.month,
              pickedDate.day, pickedTime.hour, pickedTime.minute);
        });
      }
    }
  }

  void _selectDuration() async {
    final Duration? picked = await showDurationPicker(
      context: context,
      initialDuration: _expectedDuration,
    );
    if (picked != null && picked != _expectedDuration) {
      setState(() {
        _expectedDuration = picked;
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final task = Task(
        id: widget.task?.id ?? DateTime.now().toString(),
        title: _title,
        description: _description,
        deadline: _deadline,
        expectedDuration: _expectedDuration,
        isCompleted: _isCompleted,
      );

      Navigator.of(context).pop(task);
    }
  }
}

Future<Duration?> showDurationPicker({
  required BuildContext context,
  required Duration initialDuration,
}) async {
  Duration selectedDuration = initialDuration;
  return showDialog<Duration>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Select Duration'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Hours: ${selectedDuration.inHours}'),
          Slider(
            value: selectedDuration.inHours.toDouble(),
            min: 0,
            max: 24,
            divisions: 24,
            label: selectedDuration.inHours.toString(),
            onChanged: (value) {
              selectedDuration = Duration(hours: value.toInt());
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () => Navigator.of(context).pop(selectedDuration),
        ),
      ],
    ),
  );
}
