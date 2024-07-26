import 'package:flutter/material.dart';

class CustomWalletCard extends StatelessWidget {
  const CustomWalletCard(
      {super.key, this.name, this.capturedValue, this.comission});

  final String? name;
  final String? capturedValue;
  final String? comission;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(5),
      child: ListTile(
        title: Text(
          'PROJETO: $name',
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'VALOR CAPTADO: $capturedValue',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            Text(
              'COMISSÃO: $comission',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
          ],
        ),
      ),
    );
  }
}
