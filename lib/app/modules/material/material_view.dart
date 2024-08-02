import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/material_controller.dart';
import 'package:projetos/app/data/models/material_model.dart';
import 'package:projetos/app/modules/material/widgets/create_material_modal.dart';
import 'package:projetos/app/modules/material/widgets/custom_material_card.dart';

class MaterialView extends GetView<MaterialController> {
  const MaterialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('MATERIAIS DIVULGAÇÃO'),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Obx(
                () => Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      itemCount: controller.listMaterial.length,
                      itemBuilder: (context, index) {
                        MaterialModel materialModel =
                            controller.listMaterial[index];
                        return CustomMaterialCard(
                          description: materialModel.descricao,
                          type: materialModel.tipo,
                          materialModel: materialModel,
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 5),
          child: FloatingActionButton(
            mini: true,
            elevation: 2,
            backgroundColor: Colors.orange,
            onPressed: () {
              controller.clearAllFields();
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => const CreateMaterialModal(),
              );
            },
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
            ),
          ),
        ));
  }
}
