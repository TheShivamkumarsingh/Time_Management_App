import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/time_entry_provider.dart';
import '../models/project.dart';
import '../models/task.dart';

class ManageProjectsTasks extends StatefulWidget {
  const ManageProjectsTasks({super.key});

  @override
  State<ManageProjectsTasks> createState() => _ManageProjectsTasksState();
}

class _ManageProjectsTasksState extends State<ManageProjectsTasks>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _showAddDialog(bool isProject) {
    _controller.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add ${isProject ? 'Project' : 'Task'}"),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: isProject ? "Project Name" : "Task Name",
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                if (_controller.text.trim().isEmpty) return;
                final provider =
                    Provider.of<TimeEntryProvider>(context, listen: false);
                final id = const Uuid().v4();
                if (isProject) {
                  provider.addProject(Project(id: id, name: _controller.text));
                } else {
                  provider.addTask(Task(id: id, name: _controller.text));
                }
                Navigator.pop(context);
              },
              child: const Text("Add")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeEntryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Manage Projects & Tasks"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Projects'),
            Tab(text: 'Tasks'),
          ],
          indicatorColor: Colors.amber,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildListView(
            provider.projects.map((p) => {'id': p.id, 'name': p.name}).toList(),
            (id) => provider.deleteProject(id),
          ),
          _buildListView(
            provider.tasks.map((t) => {'id': t.id, 'name': t.name}).toList(),
            (id) => provider.deleteTask(id),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber.shade700,
        child: const Icon(Icons.add),
        onPressed: () => _showAddDialog(_tabController.index == 0),
      ),
    );
  }

  Widget _buildListView(List<Map<String, String>> items, Function(String) onDelete) {
    return items.isEmpty
        ? const Center(child: Text("No items yet. Tap + to add."))
        : ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, index) {
              final item = items[index];
              return ListTile(
                title: Text(item['name'] ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.brown),
                  onPressed: () => onDelete(item['id']!),
                ),
              );
            },
          );
  }
} 
