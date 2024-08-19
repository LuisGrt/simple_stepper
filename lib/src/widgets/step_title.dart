import 'package:flutter/material.dart';

class StepTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? logo;

  const StepTitle(
    this.title, {
    this.logo,
    this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Row(
            children: [
              if (logo != null)
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  child: logo,
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500, height: 1),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black38,
                      ),
                    )
                ],
              )
            ],
          ),
          const Divider(
            height: 35,
            thickness: .5,
            indent: 20,
            endIndent: 20,
          ),
        ],
      ),
    );
  }
}
