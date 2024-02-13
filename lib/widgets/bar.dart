import 'package:flutter/material.dart';

class Bar extends StatelessWidget {
  const Bar({
    super.key,
    required this.totalPercentage,
  });

  final double totalPercentage;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        return Container(
          // height: constraints.maxHeight * 0.6,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 50,
          width: 11,
          child: Column(
            children: [
              Container(
                height: (1 - totalPercentage) * 48,
                color: Colors.transparent,
              ),
              Container(
                height: totalPercentage * 48,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
