import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_entry_provider.dart';
import '../screens/add_time_entry_screen.dart';
import '../screens/manage_projects_tasks.dart';
import '../models/project.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeEntryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Tracking"),
        backgroundColor: Colors.deepPurple,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "All Entries"),
            Tab(text: "Grouped by Projects"),
          ],
          indicatorColor: Colors.amber,
        ),
      ),

      // ✅ Drawer matches your screenshot exactly
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF4E9A8C), // Greenish-teal header
              child: const SafeArea(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Menu",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text("Projects"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManageProjectsTasks()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text("Tasks"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManageProjectsTasks()),
                );
              },
            ),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllEntriesTab(provider),
          _buildGroupedByProjectsTab(provider),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTimeEntryScreen()),
          );
        },
      ),
    );
  }

  Widget _buildAllEntriesTab(TimeEntryProvider provider) {
    if (provider.entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.hourglass_empty, size: 64, color: Colors.grey),
            SizedBox(height: 20),
            Text("No time entries yet!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Tap the + button to add your first entry.", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: provider.entries.length,
      itemBuilder: (context, index) {
        final entry = provider.entries[index];
        final projectName = provider.projects
            .firstWhere((p) => p.id == entry.projectId, orElse: () => Project(id: '', name: 'Unknown Project'))
            .name;
        final task = provider.tasks
            .firstWhere((t) => t.id == entry.taskId, orElse: () => Task(id: '', name: 'Unknown Task'))
            .name;

        return ListTile(
          title: Text("$projectName → $task"),
          subtitle: Text("${DateFormat.yMMMd().format(entry.date)} — ${entry.note}"),
          trailing: Text("${entry.hours} hrs"),
          onLongPress: () => provider.deleteEntry(entry.id),
        );
      },
    );
  }

  Widget _buildGroupedByProjectsTab(TimeEntryProvider provider) {
    final grouped = <String, double>{};

    for (var entry in provider.entries) {
      final projectName = provider.projects
          .firstWhere((p) => p.id == entry.projectId, orElse: () => Project(id: '', name: 'Unknown Project'))
          .name;
      grouped[projectName] = (grouped[projectName] ?? 0) + entry.hours;
    }

    if (grouped.isEmpty) {
      return const Center(
        child: Text("No data to group yet.", style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView(
      children: grouped.entries.map((e) {
        return ListTile(
          title: Text(e.key),
          trailing: Text("${e.value.toStringAsFixed(1)} hrs"),
        );
      }).toList(),
    );
  }
}
