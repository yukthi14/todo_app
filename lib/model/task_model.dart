import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/notification_service.dart';

class TaskService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Task>> getTasks(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromDocument(doc)).toList();
    });
  }

  Future<void> addTask(Task task, String userId) async {
    DocumentReference docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .add(task.toMap());
    task.id = docRef.id;
    NotificationService().scheduleNotification(task); // Schedule notification
  }

  Future<void> updateTask(Task task, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(task.id)
        .update(task.toMap());
    NotificationService().scheduleNotification(task); // Reschedule notification
  }

  Future<void> deleteTask(String taskId, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .delete();
    NotificationService().cancelNotification(taskId); // Cancel notification
  }
}

class Task {
  String id;
  String title;
  String description;
  DateTime deadline;
  Duration expectedDuration;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.expectedDuration,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'deadline': deadline,
      'expectedDuration': expectedDuration.inMinutes,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      deadline: (data['deadline'] as Timestamp).toDate(),
      expectedDuration: Duration(minutes: data['expectedDuration']),
      isCompleted: data['isCompleted'],
    );
  }
}
