import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String category;
  final bool isCompleted;
  final bool isPriority;
  final bool isDraft;
  final String? scheduledTime;

  Task({
    required this.id,
    required this.title,
    this.category = 'General',
    this.isCompleted = false,
    this.isPriority = false,
    this.isDraft = true,
    this.scheduledTime,
  });

  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      return Task(id: doc.id, title: 'Error loading task');
    }
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      category: data['category'] ?? 'General',
      isCompleted: data['isCompleted'] ?? false,
      isPriority: data['isPriority'] ?? false,
      isDraft: data['isDraft'] ?? true,
      scheduledTime: data['scheduledTime'],
    );
  }
}

class AppState extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Task> _tasks = [];
  StreamSubscription? _taskSubscription;

  bool isDarkMode = false;
  bool smartReminders = true;
  bool cloudSync = true;
  String? errorMessage;

  AppState() {
    _initDatabaseStream();
  }

  void _initDatabaseStream() {
    _taskSubscription = _db
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .snapshots(includeMetadataChanges: true)
        .listen((snapshot) {
      _tasks = snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
      errorMessage = null;
      notifyListeners();
    }, onError: (error) {
      debugPrint("Firestore Stream Error: $error");
      errorMessage = error.toString();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _taskSubscription?.cancel();
    super.dispose();
  }

  void toggleTheme(bool value) {
    isDarkMode = value;
    notifyListeners();
  }

  void toggleReminders(bool value) {
    smartReminders = value;
    notifyListeners();
  }

  void toggleSync(bool value) {
    cloudSync = value;
    if (!cloudSync) {
      _taskSubscription?.cancel();
      _tasks = []; // Clear tasks to show offline state
    } else {
      _initDatabaseStream();
    }
    notifyListeners();
  }

  List<Task> get drafts => _tasks.where((t) => t.isDraft).toList();
  List<Task> get priorities => _tasks.where((t) => t.isPriority && !t.isCompleted).toList();
  List<Task> get scheduled => _tasks.where((t) => t.scheduledTime != null && !t.isDraft).toList();

  double get progress {
    if (_tasks.isEmpty) return 0.0;
    final completed = _tasks.where((t) => t.isCompleted).length;
    return completed / _tasks.length;
  }

  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get totalCount => _tasks.length;

  Future<void> addTask({
    required String title,
    String category = 'General',
    bool isDraft = true,
    bool isPriority = false,
    String? scheduledTime,
  }) async {
    if (title.trim().isEmpty) return;

    try {
      await _db.collection('tasks').add({
        'title': title.trim(),
        'category': category,
        'isCompleted': false,
        'isPriority': isPriority,
        'isDraft': isDraft,
        'scheduledTime': scheduledTime,
        'createdAt': FieldValue.serverTimestamp(),
      });
      errorMessage = null;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addScheduledTask(String title, String time) async {
    await addTask(title: title, isDraft: false, scheduledTime: time);
  }

  Future<void> toggleTaskCompletion(String id) async {
    final taskIndex = _tasks.indexWhere((t) => t.id == id);
    if (taskIndex == -1) return;

    final currentStatus = _tasks[taskIndex].isCompleted;
    await _db.collection('tasks').doc(id).update({
      'isCompleted': !currentStatus
    });
  }

  Future<void> deleteTask(String id) async {
    await _db.collection('tasks').doc(id).delete();
  }
}