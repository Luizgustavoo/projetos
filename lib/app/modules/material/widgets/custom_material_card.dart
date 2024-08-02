import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/material_controller.dart';
import 'package:projetos/app/data/models/material_model.dart';
import 'package:projetos/app/modules/material/widgets/create_material_modal.dart';

class CustomMaterialCard extends StatelessWidget {
  const CustomMaterialCard(
      {super.key, this.description, this.type, this.materialModel});
  final String? description;
  final String? type;
  final MaterialModel? materialModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFF3DB),
      elevation: 2,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(5),
      child: ListTile(
        trailing: IconButton(
            onPressed: () {
              final controller = Get.put(MaterialController());
              controller.selectedMaterial = materialModel;
              controller.fillAllFields();
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => CreateMaterialModal(
                        materialModel: materialModel,
                      ));
            },
            icon: const Icon(Icons.edit_rounded)),
        title: Text(
          description!,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
        ),
        subtitle: Text(
          type!,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
        ),
      ),
    );
  }
}
