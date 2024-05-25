import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import '../model/task_model.dart';
import '../services/auth_service.dart';
import 'task_form.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final taskService = Provider.of<TaskService>(context);

    return StreamBuilder<User?>(
      stream: authService.currentUserStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Text(
              "pleaseLogIn",
              style: TextStyle(color: AppColors.appBarColor, fontSize: 20),
            ),
          );
        }

        final user = snapshot.data!;
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.appBarColor,
            title: const Text(
              Strings.taskManagerText,
              style: TextStyle(
                  fontSize: 20,
                  color: AppColors.white,
                  fontWeight: FontWeight.w500),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: AppColors.white),
                onPressed: () async {
                  await authService.signOut();
                },
              ),
            ],
          ),
          body: StreamBuilder<List<Task>>(
            stream: taskService.getTasks(user.uid),
            builder: (context, taskSnapshot) {
              if (taskSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!taskSnapshot.hasData || taskSnapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    Strings.noTasks,
                    style:
                        TextStyle(color: AppColors.appBarColor, fontSize: 15),
                  ),
                );
              }

              final tasks = taskSnapshot.data!;

              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];

                  return ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description),
                    trailing: IconButton(
                      icon: Icon(
                        task.isCompleted
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                      ),
                      onPressed: () async {
                        task.isCompleted = !task.isCompleted;
                        await taskService.updateTask(task, user.uid);
                      },
                    ),
                    onTap: () async {
                      final updatedTask = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskForm(task: task)),
                      );

                      if (updatedTask != null) {
                        await taskService.updateTask(updatedTask, user.uid);
                      }
                    },
                    onLongPress: () async {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: AppColors.backgroundColor,
                          title: const Text(
                            Strings.deleteTasks,
                            style: TextStyle(color: AppColors.black),
                          ),
                          content: const Text(
                            Strings.deleteConfirmation,
                            style: TextStyle(color: AppColors.appBarColor),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                Strings.cancelText,
                                style: TextStyle(color: AppColors.black),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await taskService.deleteTask(task.id, user.uid);
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                Strings.deleteTasks,
                                style: TextStyle(color: AppColors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.appBarColor,
            child: const Icon(Icons.add, color: AppColors.backgroundColor),
            onPressed: () async {
              final newTask = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskForm()),
              );

              if (newTask != null) {
                await taskService.addTask(newTask, user.uid);
              }
            },
          ),
        );
      },
    );
  }
}
