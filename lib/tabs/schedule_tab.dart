import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class ScheduleTab extends StatelessWidget {
  const ScheduleTab({super.key});

  void _showScheduleDialog(BuildContext context, AppState appState, Color accentColor) {
    final titleController = TextEditingController();
    final timeController = TextEditingController(text: "10:00 AM");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Schedule Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(hintText: "Task Name"), autofocus: true),
            const SizedBox(height: 16),
            TextField(controller: timeController, decoration: const InputDecoration(hintText: "Time (e.g., 2:00 PM)")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: accentColor),
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                appState.addScheduledTask(titleController.text, timeController.text);
                Navigator.pop(context);
              }
            },
            child: const Text("Schedule"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    const accentColor = Color(0xFF98203E);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Schedule", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
                IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: accentColor.withValues(alpha: 0.1)),
                  icon: const Icon(Icons.add, color: accentColor),
                  onPressed: () => _showScheduleDialog(context, appState, accentColor),
                ),
              ],
            ),
            if (appState.errorMessage != null)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Firestore Error: ${appState.errorMessage}",
                        style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32),
            ...appState.scheduled.map((task) => _buildScheduleCard(context, task, appState, textColor, accentColor)),
            if (appState.scheduled.isEmpty)
              Center(child: Text("No scheduled tasks yet.", style: TextStyle(color: Colors.grey.shade500))),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard(BuildContext context, Task task, AppState appState, Color textColor, Color accentColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => appState.toggleTaskCompletion(task.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.transparent : Colors.grey.shade200),
          boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked, color: task.isCompleted ? Colors.green : accentColor),
                const SizedBox(width: 16),
                Expanded(
                    child: Text(
                        task.title,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null
                        )
                    )
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(width: 40),
                Icon(Icons.access_time, size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 6),
                Text(task.scheduledTime ?? "Anytime", style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              ],
            )
          ],
        ),
      ),
    );
  }
}