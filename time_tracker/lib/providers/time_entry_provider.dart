import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import '../models/time_entry.dart';
import '../models/project.dart';
import '../models/task.dart';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage storage = LocalStorage('time_tracker');
  List<Project> _projects = [];
  List<Task> _tasks = [];
  List<TimeEntry> _entries = [];

  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;
  List<TimeEntry> get entries => _entries;

  Future<void> loadData() async {
    await storage.ready;
    _projects = (json.decode(storage.getItem('projects') ?? '[]') as List)
        .map((e) => Project.fromJson(e))
        .toList();
    _tasks = (json.decode(storage.getItem('tasks') ?? '[]') as List)
        .map((e) => Task.fromJson(e))
        .toList();
    _entries = (json.decode(storage.getItem('entries') ?? '[]') as List)
        .map((e) => TimeEntry.fromJson(e))
        .toList();
    notifyListeners();
  }

  void saveData() {
    storage.setItem('projects', json.encode(_projects));
    storage.setItem('tasks', json.encode(_tasks));
    storage.setItem('entries', json.encode(_entries));
  }

  void addProject(Project project) {
    _projects.add(project);
    saveData();
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    saveData();
    notifyListeners();
  }

  void addEntry(TimeEntry entry) {
    _entries.add(entry);
    saveData();
    notifyListeners();
  }

  void deleteProject(String id) {
    _projects.removeWhere((p) => p.id == id);
    saveData();
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    saveData();
    notifyListeners();
  }

  void deleteEntry(String id) {
    _entries.removeWhere((e) => e.id == id);
    saveData();
    notifyListeners();
  }
}
