import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/routes/app_routes.dart';
import 'package:projetos/app/utils/service_storage.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onClose;

  const CustomDrawer({required this.onClose, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Container(
        width: 250,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 150,
              color: Colors.orange,
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Menu',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.chart_bar_alt_fill),
              title: const Text(
                'LISTAGEM DE RELATÓRIOS',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 12),
              ),
              onTap: () {
                Get.toNamed(Routes.report);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: onClose,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                  onPressed: () {
                    ServiceStorage.clearBox();
                    Get.offAllNamed(Routes.login);
                  },
                  icon: const Icon(Icons.exit_to_app_rounded),
                  label: const Text('SAIR')),
            )
          ],
        ),
      ),
    );
  }
}
