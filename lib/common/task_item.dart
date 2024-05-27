import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:todo_app/models/categories.dart';
import 'package:todo_app/common/commons.dart';
import 'package:todo_app/models/task.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class TaskItem extends StatefulWidget {
  final Task task;
  final VoidCallback updateHome;

  const TaskItem({super.key, required this.task, required this.updateHome});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool isLoading = false;

  void _closeTask(Task task, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    var taskUpdateUrl = Uri.http(backendBaseUrl, '/tasks/${task.id}');
    Task taskToSend = Task(
        id: task.id,
        title: task.title,
        isDone: !task.isDone,
        category: task.category);
    var updateResponse = await http.put(taskUpdateUrl,
        body: convert.jsonEncode(taskToSend.toJson()),
        headers: {'Content-Type': 'application/json'});
    setState(() {
      isLoading = false;
      _showTaskClosureResult(context, updateResponse);
    });
    // print("--------------- Response Code: ${updateResponse.statusCode}");
    // print("--------------- Response Body: ${updateResponse.body}");
    widget.updateHome();
  }

  void _showTaskClosureConfimation(BuildContext context, Task task) {
    List<Widget> secondActionButton = task.isDone
        ? []
        : [
            CupertinoDialogAction(
              //TODO: Call API for the changing
              isDestructiveAction: true,
              onPressed: () {
                _closeTask(task, context);
                Navigator.pop(context);
              },
              child: const Text('Oui'),
            ),
          ];
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text("Confirmation"),
        content: Text(task.isDone
            ? "Cette tâche est déjà terminée."
            : "Vous êtes sur le point de marquer cette tâche comme terminée. Voulez-vous continuer?"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(task.isDone ? "Fermer" : 'Non'),
          ),
          ...secondActionButton,
        ],
      ),
    );
  }

  void _showTaskClosureResult(BuildContext context, Response updateResponse) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(updateResponse.statusCode == 200 ? "Success" : "Error"),
        content: Text(updateResponse.statusCode == 200
            ? "La tâche a été clôturée avec succès."
            : "Quelque chose ne va pas. Réessayez plus tard"),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 70.0,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: primaryBackground,
      ),
      child: Row(
        children: [
          // Le cercle du checkboox (isDone)
          Container(
            child: isLoading
                ? CircularProgressIndicator(
                    color: Colors.white.withOpacity(.1),
                  )
                : IconButton(
                    onPressed: () =>
                        _showTaskClosureConfimation(context, widget.task),
                    icon: Container(
                      padding: const EdgeInsets.all(2.0),
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.task.category == Categories.Business
                            ? businessIndicator
                            : personalIndicator,
                      ),
                      child: widget.task.isDone
                          ? const Icon(
                              Icons.done_rounded,
                              color: Colors.white,
                              size: 18.0,
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryBackground,
                              ),
                            ),
                    ),
                  ),
          ),
          const SizedBox(width: 10.0),
          Text(
            " ${widget.task.title}",
            style: TextStyle(
              decoration: widget.task.isDone
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              decorationColor: Colors.white,
              color: Colors.white,
              fontSize: 20.0,
            ),
          )
        ],
      ),
    );
  }
}
