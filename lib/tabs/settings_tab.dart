import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    const accentColor = Color(0xFF98203E);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text("Settings", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 40),

          _buildSectionHeader("PREFERENCES"),
          _buildSwitchTile(
            title: "Dark Mode",
            subtitle: "Reduce eye strain",
            icon: Icons.dark_mode_outlined,
            value: appState.isDarkMode,
            onChanged: appState.toggleTheme,
            accentColor: accentColor,
            textColor: textColor,
          ),
          _buildSwitchTile(
            title: "Smart Reminders",
            subtitle: "Push notifications for tasks",
            icon: Icons.notifications_active_outlined,
            value: appState.smartReminders,
            onChanged: appState.toggleReminders,
            accentColor: accentColor,
            textColor: textColor,
          ),

          const SizedBox(height: 32),
          _buildSectionHeader("DATA"),
          _buildSwitchTile(
            title: "Cloud Sync",
            subtitle: "Sync across devices",
            icon: Icons.cloud_sync_outlined,
            value: appState.cloudSync,
            onChanged: appState.toggleSync,
            accentColor: accentColor,
            textColor: textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey)
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
    required Color accentColor,
    required Color textColor,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
      secondary: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: accentColor, size: 20),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: accentColor,
      activeTrackColor: accentColor.withValues(alpha: 0.5),
    );
  }
}