import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:todo_app/common/block_title.dart';
import 'package:todo_app/models/categories.dart';
import 'package:todo_app/common/commons.dart';
import 'package:todo_app/common/slider_item.dart';
import 'package:todo_app/common/task_item.dart';
import "package:http/http.dart" as http;
import 'package:todo_app/models/task.dart';
import 'package:todo_app/screens/new_task_screen.dart';
import 'package:badges/badges.dart' as badges;

const String backendBaseUrl = 'localhost:8080'; // Define your backend URL
var taskListUrl = Uri.http(backendBaseUrl, '/tasks');

class HomeScreen extends StatefulWidget {
  final Duration duration;
  final bool isClosed;
  final AnimationController animationController;
  final Animation<double> scaleAnimation;
  final VoidCallback toggleMenu;

  const HomeScreen({
    super.key,
    required this.duration,
    required this.isClosed,
    required this.animationController,
    required this.scaleAnimation,
    required this.toggleMenu,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];

  // Un écouteur au contrôleur de recherche pour filtrer les tâches à chaque modification du texte
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterTasks);
    _fetchTasks();
  }

  // Nettoyez l'écouteur du contrôleur de recherche
  @override
  void dispose() {
    _searchController.removeListener(_filterTasks);
    _searchController.dispose();
    super.dispose();
  }

  // Réinitialisez lorsque la recherche est annulée
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _filteredTasks = _tasks;
      }
    });
  }

  // Mettez à jour _filteredTasks en fonction de la recherche
  void _filterTasks() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTasks = _tasks
          .where((task) => task.title.toLowerCase().contains(query))
          .toList();
    });
  }

  // Récupérer les tâches au démarrage
  Future<void> _fetchTasks() async {
    try {
      final response = await http.get(taskListUrl);
      if (response.statusCode == 200) {
        List<Task> fetchedTasks = (convert.jsonDecode(response.body) as List)
            .map((data) => Task.fromJson(data))
            .toList();
        setState(() {
          _tasks = fetchedTasks;
          _filteredTasks = fetchedTasks;
        });
      } else {
        // Gérer les erreurs de serveur ici
      }
    } catch (e) {
      // Gérer les erreurs de réseau ici
    }
  }

  void rebuildHomePage() {
    setState(() {});
  }

  int _countIncompleteTasks() {
    return _tasks.where((task) => !task.isDone).length;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedPositioned(
      duration: widget.duration,
      top: 0.0,
      bottom: 0.0,
      left: widget.isClosed ? 0.0 : .7 * screenWidth,
      right: widget.isClosed ? 0.0 : -screenWidth,
      child: ScaleTransition(
        scale: widget.scaleAnimation,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => NewTaskScreen(
                      updateHome: rebuildHomePage,
                    ))),
            backgroundColor: businessIndicator,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 35.0,
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(widget.isClosed ? 0.0 : 50.0)),
              color: secondaryBackground,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                // L'en-tête avec les icônes
                Padding(
                  padding:
                      const EdgeInsets.only(right: paddingValue, left: 25.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: widget.toggleMenu,
                        icon: Icon(Icons.menu_rounded,
                            size: iconSize, color: iconColor),
                      ),
                      Expanded(child: Container()),
                      CircleAvatar(
                        radius: 22.0,
                        backgroundImage: AssetImage(
                          "assets/images/logo.jpeg",
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.search_rounded,
                          size: iconSize,
                          color: iconColor,
                        ),
                        onPressed: _toggleSearch,
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Stack(
                        children: [
                          Icon(Icons.notifications_none_rounded,
                              size: iconSize, color: iconColor),
                          Positioned(
                            right: 5,
                            bottom: 8,
                            child: badges.Badge(
                              badgeContent: Text(
                                _countIncompleteTasks().toString(),
                                style: TextStyle(color: Colors.white),
                              ),

                              //badgeContent: Text(
                              // "8",
                              // style: TextStyle(color: Colors.white),
                              //s),
                              badgeStyle: badges.BadgeStyle(
                                badgeColor: Colors.red,
                                padding: EdgeInsets.all(5),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_isSearching)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Rechercher...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 30.0),
                // Texte de Bienvenue
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingValue),
                  child: Text(
                    "Bienvenue Amédée !",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                // Block categories title
                const BlockTitle(
                  title: "Catégories",
                ),
                // Slider items
                SizedBox(
                  height: 150.0,
                  child: ListView(
                    padding:
                        const EdgeInsets.only(left: paddingValue, right: 10.0),
                    scrollDirection: Axis.horizontal,
                    children: const [
                      // slider item Business
                      SliderItem(
                        category: Categories.Business,
                        progress: .8,
                        tasksNumber: 80,
                      ),
                      SizedBox(width: 10.0),
                      // slider item Personal
                      SliderItem(
                          category: Categories.Personal,
                          progress: .35,
                          tasksNumber: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                // block Today's Tasks
                const BlockTitle(
                  title: "Les tâches du jour...",
                ),
                const SizedBox(height: 10.0),
                // Listes des taches
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: paddingValue),
                    itemCount: _filteredTasks.length,
                    itemBuilder: (context, index) {
                      return TaskItem(
                        task: _filteredTasks[index],
                        updateHome: rebuildHomePage,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 35.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
