import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/data/models/fundraisings_model.dart';
import 'package:projetos/app/utils/formatter.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ContactTimeLineView extends GetView<CompanyController> {
  const ContactTimeLineView({super.key});

  @override
  Widget build(BuildContext context) {
    final Company company = Get.arguments as Company;
    return Scaffold(
      appBar: AppBar(
        title: const Text('CONTRIBUIÇÕES'),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: company.fundraisings!.length,
          itemBuilder: (context, index) {
            FundRaising fundRaising = company.fundraisings![index];
            return TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.0,
              beforeLineStyle: const LineStyle(
                color: Colors.orange,
                thickness: 2,
              ),
              afterLineStyle: const LineStyle(
                color: Colors.orange,
                thickness: 2,
              ),
              indicatorStyle: const IndicatorStyle(
                width: 15,
                color: Colors.orange,
                indicatorXY: 0.5,
                padding: EdgeInsets.all(8),
              ),
              endChild: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade200,
                ),
                constraints: const BoxConstraints(
                  minHeight: 120,
                ),
                padding: const EdgeInsets.all(16.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    // Text(
                    //   'Valor Arrecadado: R\$ ${contact.amount.toStringAsFixed(2)}',
                    //   style: const TextStyle(fontSize: 16),
                    // ),
                    // const SizedBox(height: 8),
                    // Text(
                    //   'Captador: ${contact.captor}',
                    //   style: const TextStyle(fontSize: 16),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
