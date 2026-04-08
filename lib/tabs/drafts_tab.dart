import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class DraftsTab extends StatefulWidget {
  const DraftsTab({super.key});

  @override
  State<DraftsTab> createState() => _DraftsTabState();
}

class _DraftsTabState extends State<DraftsTab> {
  final TextEditingController _controller = TextEditingController();

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Draft"),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: "Enter task idea..."),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF98203E)),
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                context.read<AppState>().addTask(title: _controller.text, isDraft: true);
                _controller.clear();
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
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
    final cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFDECEE);
    const accentColor = Color(0xFF98203E);

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Drafts", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
                    if (appState.errorMessage != null)
                      Text(
                        "Sync Error: ${appState.errorMessage}",
                        style: const TextStyle(color: Colors.red, fontSize: 10),
                      ),
                  ],
                ),
                IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: accentColor.withValues(alpha: 0.1)),
                  icon: const Icon(Icons.add, color: accentColor),
                  onPressed: _showAddDialog,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: appState.drafts.length,
              itemBuilder: (context, index) {
                final draft = appState.drafts[index];
                return Dismissible(
                  key: Key(draft.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(color: Colors.red.shade400, borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => appState.deleteTask(draft.id),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(draft.title, style: TextStyle(fontSize: 16, color: textColor))),
                        const Icon(Icons.edit_note, color: accentColor),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}