import 'package:daily_tasks_app/data/tasks_data.dart';
import 'package:daily_tasks_app/provider/projects.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:status_bar_control/status_bar_control.dart';
import 'package:uuid/uuid.dart';

class NewTaskScreen extends StatefulWidget {
  static const routeName = '/NewTaskScreen';
  const NewTaskScreen({super.key, required this.id});

  final String id;

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  var _statusbarHeight = 0.0;
  var _isToday = true;
  String? _projectId;
  final _formkey = GlobalKey<FormState>();
  var _enteredTaskTitle = '';
  var _enteredTaskDescription = '';
  var _enteredProjectName = '';
  var _newProject = false;

  void _getStatusBarHeight() async {
    final height = await StatusBarControl.getHeight;
    _projectId = widget.id;
    setState(() {
      _statusbarHeight = height;
    });
  }

  // void isSelected (){
  //   Provider.of<Projects>(context, listen: false).isSelected(id: widget.id);
  // }
  void _updateProject() async {
    //Validate returns a boolean which tells if form is valid or not
    final isValid = _formkey.currentState!.validate();

    //If there is no Image, do not move forward
    if (!isValid) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No task title'),
        ),
      );
      return;
    }

    //save form if valid
    _formkey.currentState!.save();
    final now = DateTime.now();
    if (_newProject) {
      Provider.of<Projects>(context, listen: false).addNewProject(
        id: const Uuid().v1(),
        projectName: _enteredProjectName,
        newTask: TasksData(
          title: _enteredTaskTitle,
          description: _enteredTaskDescription,
          timedue: _isToday
              ? DateTime(now.year, now.month, now.day)
              : DateTime(now.year, now.month, now.day + 1),
          isCompleted: false,
          taskId: const Uuid().v4(),
        ),
      );
    } else {
      Provider.of<Projects>(context, listen: false).updateProject(
        id: _projectId!,
        newTask: TasksData(
          title: _enteredTaskTitle,
          description: _enteredTaskDescription,
          timedue: _isToday
              ? DateTime(now.year, now.month, now.day)
              : DateTime(now.year, now.month, now.day + 1),
          isCompleted: false,
          taskId: const Uuid().v4(),
        ),
      );
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _newProject
            ? const Text('Project successfully added')
            : const Text('Project successfully updated'),
      ),
    );
    Navigator.pop(context);
  }

  @override
  void initState() {
    _getStatusBarHeight();
    // isSelected();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height - _statusbarHeight;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: SingleChildScrollView(
        // reverse: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CloseButton(height: height),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'New Task',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.6,
                    height: height * 0.16,
                    // color: Color.fromARGB(255, 230, 226, 226),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Bubble(
                              title: 'Today',
                              onTap: () => setState(() {
                                _isToday = true;
                              }),
                              isSelected: _isToday,
                            ),
                            Bubble(
                              title: 'Tomorrow',
                              onTap: () => setState(() {
                                _isToday = false;
                              }),
                              isSelected: !_isToday,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CircleBubble(
                              icon: Icons.notification_add_outlined,
                              onTap: () {},
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            CircleBubble(
                              icon: Icons.more_time_rounded,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.045,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: height * 0.13,
                    // color: Colors.black,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'PROJECTS',
                          style: TextStyle(
                            color: Colors.grey,
                            letterSpacing: 2,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          // color: Colors.grey,
                          width: double.infinity,
                          height: height * 0.08,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_newProject == false)
                                  CircleBubble(
                                    icon: Icons.add,
                                    onTap: () => setState(() {
                                      _projectId = '';
                                      _newProject = true;
                                    }),
                                  ),
                                Flexible(
                                  child: Consumer<Projects>(
                                    builder: (context, providerData, _) =>
                                        ListView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: providerData.projects.length,
                                      itemBuilder: (context, index) {
                                        return Bubble(
                                          title: providerData
                                              .projects[index].projectName,
                                          onTap: () {
                                            setState(() {
                                              _projectId = providerData
                                                  .projects[index].id;
                                              _newProject = false;
                                            });
                                            providerData.isSelected(
                                                id: _projectId!);
                                          },
                                          isSelected: _projectId ==
                                                  providerData
                                                      .projects[index].id
                                              ? true
                                              : false,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.045,
                  ),
                  SizedBox(
                    height: _newProject ? height * 0.5 : height * 0.4,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'TITLE',
                            style: TextStyle(
                              color: Colors.grey,
                              letterSpacing: 2,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                if (_newProject)
                                  TextFormField(
                                    cursorColor: Colors.black,
                                    textInputAction: TextInputAction.next,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Project title',
                                      labelStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 190, 189, 189),
                                      ),
                                      floatingLabelStyle: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color: Color.fromARGB(
                                              255, 190, 189, 189),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          width: 1.5,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.trim().isEmpty) {
                                        return;
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) =>
                                        _enteredProjectName = newValue!,
                                  ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  cursorColor: Colors.black,
                                  textInputAction: TextInputAction.next,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Task title',
                                    labelStyle: const TextStyle(
                                      color: Color.fromARGB(255, 190, 189, 189),
                                    ),
                                    floatingLabelStyle: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 190, 189, 189),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        width: 1.5,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return;
                                    }
                                    return null;
                                  },
                                  //TODO: Continue from here...
                                  onSaved: (newValue) =>
                                      _enteredTaskTitle = newValue!,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  minLines: 2,
                                  maxLines: 3,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  cursorColor: Colors.black,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Description',
                                    labelStyle: const TextStyle(
                                      color: Color.fromARGB(255, 190, 189, 189),
                                    ),
                                    floatingLabelStyle: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        width: 1.5,
                                        color:
                                            Color.fromARGB(255, 190, 189, 189),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  onSaved: (newValue) =>
                                      _enteredTaskDescription = newValue!,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ElevatedButton(
                              onPressed: () => _updateProject(),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 65),
                              ),
                              child: const Text(
                                'Create',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CloseButton extends StatelessWidget {
  const CloseButton({
    super.key,
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: height * 0.04),
      child: InkWell(
        radius: 60,
        onTap: () => Navigator.pop(context),
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                width: 1.5, color: const Color.fromARGB(255, 190, 189, 189)),
            // gradient: const LinearGradient(
            //   colors: [
            //     Color.fromRGBO(209, 207, 207, 0.624),
            //     Color.fromRGBO(179, 177, 177, 0.922),
            //     Color.fromRGBO(124, 123, 123, 0.624),
            //     Color.fromRGBO(143, 140, 140, 0.259),
            //   ],
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   transform: GradientRotation(50),
            // ),
          ),
          child: const Icon(
            Icons.close_rounded,
            size: 30,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class CircleBubble extends StatelessWidget {
  const CircleBubble({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: const Color.fromARGB(255, 190, 189, 189),
      child: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.white,
        child: IconButton(
          splashRadius: 28,
          onPressed: onTap,
          icon: Icon(
            icon,
            size: 28,
          ),
        ),
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  const Bubble({
    super.key,
    required this.title,
    required this.onTap,
    required this.isSelected,
  });

  final String title;
  final bool isSelected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            width: isSelected ? 0 : 1.5,
            color: isSelected
                ? Colors.transparent
                : const Color.fromARGB(255, 190, 189, 189),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
