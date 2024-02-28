import 'package:daily_tasks_app/provider/projects.dart';
import 'package:daily_tasks_app/widgets/project_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'new_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<Projects>(context).projects;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // forceElevated: true,
            // elevation: 5,
            collapsedHeight: 56,
            expandedHeight: 200,
            pinned: true,
            stretch: true,
            flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              var top = constraints.biggest.height;
              return FlexibleSpaceBar(
                stretchModes: const [
                  StretchMode.blurBackground,
                  StretchMode.fadeTitle,
                  StretchMode.zoomBackground,
                ],
                expandedTitleScale: 2,
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: 1,
                  child: top > 71 && top < 91
                      ? const Text(
                          "Hello Favour",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                          ),
                        )
                      : const Text(
                          "",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    const SizedBox(
                      height: 200,
                      width: double.infinity,
                    ),
                    // Image.asset(
                    //   "images/todo3.jpg",
                    //   fit: BoxFit.cover,
                    // ),
                    // const DecoratedBox(
                    //   position: DecorationPosition.foreground,
                    //   decoration: BoxDecoration(
                    //     gradient: LinearGradient(
                    //       colors: [
                    //         Colors.white54,
                    //         Colors.transparent,
                    //       ],
                    //       begin: Alignment.centerLeft,
                    //       end: Alignment.center,
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      top: 60,
                      left: 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hello, Favour",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Your",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Projects (${providerData.length})",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/profile.jpg'),
                                radius: 45,
                              )
                              // Image.asset('images/profile.jpg'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            // FlexibleSpaceBar(
            //   background: Text(
            //     'Your Projects (6)',
            //     style: TextStyle(
            //       color: Colors.black,
            //     ),
            //   ),
            //   collapseMode: CollapseMode.parallax,
            // ),
          ),
          FutureBuilder(
            future: Provider.of<Projects>(context, listen: false)
                .fetchAndSetProjects(),
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? SliverToBoxAdapter(
                        child: SizedBox(
                          // color: Colors.black,
                          height: height - 300,
                          width: double.infinity,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : providerData.isEmpty
                        ? SliverToBoxAdapter(
                            child: SizedBox(
                              // color: Colors.black,
                              height: height - 300,
                              width: double.infinity,
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'No Project Here',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Click the \'Add New Project\' button to add a new project',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SliverAnimatedList(
                            itemBuilder: (context, index, animation) {
                              return SizeTransition(
                                sizeFactor: animation,
                                child: ProjectWidget(
                                  id: providerData[index].id,
                                  projectTitle: providerData[index].projectName,
                                  index: index,
                                ),
                              );
                            },
                            initialItemCount: providerData.length,
                          ),
          ),
        ],
      ),
      floatingActionButton: providerData.isEmpty
          ? FloatingActionButton.extended(
              label: const Text('Add New Project'),
              onPressed: () => showModalBottomSheet(
                context: context,
                builder: (context) {
                  return AnimatedContainer(
                    height: height,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: const NewTaskScreen(
                      id: '',
                    ),
                  );
                },
                isScrollControlled: true,
              ),
              foregroundColor: Colors.white,
              tooltip: 'Add project',
              icon: const Icon(Icons.create_new_folder_outlined),
            )
          : FloatingActionButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                builder: (context) {
                  return AnimatedContainer(
                    height: height,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: const NewTaskScreen(
                      id: '',
                    ),
                  );
                },
                isScrollControlled: true,
              ),
              foregroundColor: Colors.white,
              tooltip: 'Add project',
              child: const Icon(Icons.create_new_folder_outlined),
            ),
    );
  }
}
