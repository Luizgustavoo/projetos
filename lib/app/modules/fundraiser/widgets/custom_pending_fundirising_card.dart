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
          trailing: const SizedBox(
            width: 118,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Arraste para atualizar',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 7.5,
                      color: Colors.black54),
                ),
                SizedBox(width: 5),
                Icon(Icons.arrow_back_ios_new_rounded,
                    size: 20, color: Colors.black54)
              ],
            ),
          ),
          dense: true,
          title: Text(
            'EMPRESA: $companyName'.toUpperCase(),
            style: const TextStyle(fontSize: 12.5, fontFamily: 'Poppinss'),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('VALOR PREVISTO: $predictedValue',
                  style: const TextStyle(fontFamily: 'Poppins')),
              Text('DATA PREVISTA: $predictedDate',
                  style: const TextStyle(fontFamily: 'Poppins')),
              Text('STATUS: $status'.toUpperCase(),
                  style: const TextStyle(fontFamily: 'Poppins')),
              Text('CAPTADOR: $fundRaiser'.toUpperCase(),
                  style: const TextStyle(fontFamily: 'Poppins')),
            ],
          )),
    );
  }
}
