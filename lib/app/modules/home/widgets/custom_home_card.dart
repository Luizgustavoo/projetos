import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    this.title,
    this.icon,
    this.onTap,
    super.key,
  });
  final String? title;
  final IconData? icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.orange,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              title!,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
