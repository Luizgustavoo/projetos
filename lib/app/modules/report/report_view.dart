import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/report_controller.dart';

class ReportView extends GetView<ReportController> {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('RELATÓRIOS'),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: const SafeArea(child: Text('ReportController')));
  }
}
