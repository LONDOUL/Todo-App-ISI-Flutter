import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:todo_app/models/categories.dart';
import 'package:todo_app/common/commons.dart';
import 'package:todo_app/models/task.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

List<Categories> categories = Categories.values;

class NewTaskScreen extends StatefulWidget {
  final VoidCallback updateHome;
  const NewTaskScreen({super.key, required this.updateHome});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController titleFieldController = TextEditingController();
  Categories selectedCategory = categories.first;
  bool isLoading = false;

  _saveTask(Task task, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    var saveTaskUrl = Uri.http(backendBaseUrl, '/tasks');
    var saveResponse = await http.post(saveTaskUrl,
        body: convert.jsonEncode(task.toJson()),
        headers: {'Content-Type': 'application/json'});
    setState(() {
      isLoading = false;
      _showSaveTaskResult(context, saveResponse);
    });
    print("--------------- Response Code: ${saveResponse.statusCode}");
    print("--------------- Response Body: ${saveResponse.body}");

    widget.updateHome();
  }

  void _showSaveTaskResult2(BuildContext context, Response updateResponse) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(updateResponse.statusCode == 200 ? "Succès" : "Erreur"),
        content: Text(updateResponse.statusCode == 200
            ? "La tâche a été créée avec succès!"
            : "Erreur de création. Veuillez réassayer plutard."),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              _formKey.currentState!.reset();
            },
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showSaveTaskResult(BuildContext context, Response updateResponse) {
    titleFieldController.clear();

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Row(
          children: [
            Icon(
              updateResponse.statusCode == 200
                  ? Icons.check_circle_rounded // Icône de succès
                  : Icons.error_rounded, // Icône d'erreur
              color: updateResponse.statusCode == 200
                  ? Colors.green // Couleur de succès
                  : Colors.red, // Couleur d'erreur
            ),
            const SizedBox(width: 10), // Espacement entre l'icône et le texte
            Text(
              updateResponse.statusCode == 200 ? "Succès" : "Erreur",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          updateResponse.statusCode == 200
              ? "La tâche a été créée avec succès!"
              : "Erreur de création. Veuillez réessayer plus tard.",
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              //_formKey.currentState!.reset();
              if (updateResponse.statusCode == 200) {
                Navigator.pop(
                    context); // Revenir à la page précédente (page d'accueil)
              }
            },
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 67, 91, 214),
        elevation: 4.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: primaryBackground,
              size: 25.0,
            )),
        centerTitle: true,
        title: const Text(
          "Ajouter une nouvelle tâche",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingValue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 100.0,
              ),
              //Champs "title"
              TextFormField(
                controller: titleFieldController,
                decoration: const InputDecoration(
                    hintText: 'Saisir le titre',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)))),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez remplir le champ de saisie';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              //Champs Select "Catégorie"
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(width: 1.0, color: Colors.black),
                ),
                child: DropdownButton<Categories>(
                  isExpanded: true,
                  value: selectedCategory,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  underline: Container(
                    height: 2,
                    color: Colors.transparent,
                  ),
                  onChanged: (Categories? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  items: categories
                      .map<DropdownMenuItem<Categories>>((Categories value) {
                    return DropdownMenuItem<Categories>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Construction de l'objet task à envoyer au serveur
                      Task newTask = Task(
                          title: titleFieldController.value.text,
                          isDone: false,
                          category: selectedCategory);

                      // Appel de la mèthode qui envoit la requête
                      _saveTask(newTask, context);
                    }
                  },
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white.withOpacity(.1),
                        )
                      : const Text('Valider'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
