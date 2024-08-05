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
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (DismissDirection direction) async {
                            if (direction == DismissDirection.endToStart) {
                              showDialog(context, materialModel);
                            }
                            return false;
                          },
                          background: Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red,
                            ),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'EXCLUIR',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.delete_forever,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          child: CustomMaterialCard(
                            description: materialModel.descricao,
                            type: materialModel.tipo,
                            materialModel: materialModel,
                          ),
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

  void showDialog(context, MaterialModel materialModel) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(16),
      title: "Confirmação",
      content: Text(
        textAlign: TextAlign.center,
        "Deseja excluir o material ${materialModel.descricao}?",
        style: const TextStyle(
          fontFamily: 'Poppinss',
          fontSize: 18,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            Map<String, dynamic> retorno =
                await controller.deleteMaterial(materialModel.id!);

            if (retorno['success'] == true) {
              Get.back();
              Get.snackbar('Sucesso!', retorno['message'].join('\n'),
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                  snackPosition: SnackPosition.BOTTOM);
            } else {
              Get.snackbar('Falha!', retorno['message'].join('\n'),
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                  snackPosition: SnackPosition.BOTTOM);
            }
          },
          child: const Text(
            "CONFIRMAR",
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("CANCELAR"),
        ),
      ],
    );
  }
}
