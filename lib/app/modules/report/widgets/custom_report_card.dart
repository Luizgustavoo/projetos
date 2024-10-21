import 'package:flutter/material.dart';

class CustomReportCard extends StatelessWidget {
  const CustomReportCard({super.key, this.onTap, this.title, this.subtitle});

  final Function()? onTap;
  final String? title;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFF3DB),
      elevation: 2,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(5),
      child: ListTile(
        title: Container(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            title ?? "",
            style: const TextStyle(fontFamily: 'Poppinss'),
          ),
        ),
        subtitle: subtitle,
        trailing:
            IconButton(onPressed: onTap, icon: const Icon(Icons.download)),
      ),
    );
  }
}
