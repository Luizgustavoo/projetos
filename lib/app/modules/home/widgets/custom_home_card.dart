import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

class HomeCard extends StatelessWidget {
  const HomeCard({
    this.title,
    this.icon,
    this.onTap,
    super.key,
    this.color = const Color(0xFFEBAE1F),
  });
  final String? title;
  final IconData? icon;
  final Function()? onTap;
  final Color color;

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
              size: kIsWeb || defaultTargetPlatform == TargetPlatform.windows
                  ? 120
                  : 40,
              color: color,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              title!,
              style: TextStyle(
                  fontSize:
                      kIsWeb || defaultTargetPlatform == TargetPlatform.windows
                          ? 20
                          : 10,
                  fontFamily: 'Poppins'),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
