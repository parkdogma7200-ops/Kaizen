import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

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
            Text("Good Morning,", style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
            Text("Samiul & Yeasin", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
            if (appState.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Error: ${appState.errorMessage}",
                  style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              )
            else if (appState.totalCount == 0 && appState.progress == 0)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Connecting to Firestore... (Ensure API is enabled)",
                  style: TextStyle(color: Colors.orange.shade700, fontSize: 12),
                ),
              ),
            const SizedBox(height: 32),
            _buildProgressCard(appState, accentColor),
            const SizedBox(height: 32),
            Text("Top Priorities", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 16),
            ...appState.priorities.map((task) => _buildTaskTile(context, task, appState, accentColor)),
            if (appState.priorities.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(child: Text("No high priorities right now.", style: TextStyle(color: Colors.grey.shade500))),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(AppState appState, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: accentColor.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Daily Progress", style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 8),
                Text("${(appState.progress * 100).toInt()}%", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 70, height: 70,
                child: CircularProgressIndicator(
                    value: appState.progress,
                    strokeWidth: 8,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(Colors.white)
                ),
              ),
              Text("${appState.completedCount}/${appState.totalCount}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTaskTile(BuildContext context, Task task, AppState appState, Color accentColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => appState.toggleTaskCompletion(task.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.transparent : Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked, color: task.isCompleted ? Colors.green : accentColor),
            const SizedBox(width: 16),
            Expanded(
                child: Text(
                    task.title,
                    style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black87,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null
                    )
                )
            ),
          ],
        ),
      ),
    );
  }
}