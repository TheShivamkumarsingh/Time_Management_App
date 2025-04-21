import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  const AddTimeEntryScreen({super.key});

  @override
  State<AddTimeEntryScreen> createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  String? selectedProjectId;
  String? selectedTaskId;
  DateTime selectedDate = DateTime.now();
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeEntryProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Time Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          DropdownButtonFormField(
            decoration: const InputDecoration(labelText: 'Project'),
            items: provider.projects.map((proj) {
              return DropdownMenuItem(value: proj.id, child: Text(proj.name));
            }).toList(),
            onChanged: (value) => setState(() => selectedProjectId = value),
          ),
          DropdownButtonFormField(
            decoration: const InputDecoration(labelText: 'Task'),
            items: provider.tasks.map((task) {
              return DropdownMenuItem(value: task.id, child: Text(task.name));
            }).toList(),
            onChanged: (value) => setState(() => selectedTaskId = value),
          ),
          const SizedBox(height: 10),
          TextButton(
            child: Text("Pick Date: ${selectedDate.toLocal()}".split(' ')[0]),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2023),
                lastDate: DateTime(2100),
              );
              if (picked != null) setState(() => selectedDate = picked);
            },
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Hours'),
            controller: hoursController,
            keyboardType: TextInputType.number,
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Note'),
            controller: noteController,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (selectedProjectId == null || selectedTaskId == null) return;
              final newEntry = TimeEntry(
                id: const Uuid().v4(),
                projectId: selectedProjectId!,
                taskId: selectedTaskId!,
                date: selectedDate,
                hours: double.tryParse(hoursController.text) ?? 0,
                note: noteController.text,
              );
              provider.addEntry(newEntry);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ]),
      ),
    );
  }
}
