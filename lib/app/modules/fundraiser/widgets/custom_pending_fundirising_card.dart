import 'package:flutter/material.dart';

class CustomPendingFundRaiserCard extends StatelessWidget {
  const CustomPendingFundRaiserCard(
      {super.key,
      this.companyName,
      this.fundRaiser,
      this.predictedDate,
      this.predictedValue,
      this.status});

  final String? companyName;

  final String? predictedValue;
  final String? predictedDate;
  final String? status;
  final String? fundRaiser;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFF3DB),
      elevation: 2,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(5),
      child: ListTile(
          dense: true,
          title: Text(
            'EMPRESA: $companyName',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('VALOR PREVISTO: $predictedValue'),
              Text('DATA PREVISTA: $predictedDate'),
              Text('STATUS: $status'.toUpperCase()),
              Text('CAPTADOR: $fundRaiser'.toUpperCase()),
            ],
          )),
    );
  }
}
