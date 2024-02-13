import 'package:daily_tasks_app/provider/projects.dart';
import 'package:daily_tasks_app/widgets/project_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<Projects>(context).projects;

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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Text('$index')
                return ProjectWidget(
                  id: providerData[index].id,
                  projectTitle: providerData[index].projectName,
                );
              },
              childCount: providerData.length,
            ),
          ),
        ],
      ),
    );
  }
}
