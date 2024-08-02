import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/material_controller.dart';
import 'package:projetos/app/data/models/material_model.dart';

class CreateMaterialModal extends GetView<MaterialController> {
  const CreateMaterialModal({super.key, this.materialModel});

  final MaterialModel? materialModel;
  @override
  Widget build(BuildContext context) {
    bool isUpdate = materialModel != null;

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
        key: controller.materialKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  'CADASTRO DE MATERIAIS',
                  style: TextStyle(
                      fontFamily: 'Poppinss',
                      fontSize: 17,
                      color: Color(0xFFEBAE1F)),
                ),
              ),
              const Divider(
                endIndent: 110,
                height: 5,
                thickness: 2,
                color: Colors.black,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.descriptionController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'DESCRIÇÃO',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedFileType.value,
                    items: const [
                      DropdownMenuItem(
                        value: 'video',
                        child: Text('VIDEO'),
                      ),
                      DropdownMenuItem(
                        value: 'arquivo',
                        child: Text('ARQUIVO'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedFileType.value = value;
                      }
                    },
                    decoration:
                        const InputDecoration(labelText: 'Tipo de Arquivo'),
                  )),
              const SizedBox(height: 10),
              Obx(() {
                if (controller.selectedFileType.value == 'video') {
                  return Column(
                    children: [
                      TextFormField(
                        controller: controller.linkController,
                        keyboardType: TextInputType.url,
                        decoration: const InputDecoration(
                          labelText: 'LINK DO VÍDEO',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o link do vídeo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                } else if (controller.selectedFileType.value == 'arquivo') {
                  return Column(
                    children: [
                      Obx(() {
                        return ElevatedButton.icon(
                          onPressed: () async {
                            await controller.pickPdf();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              controller.pdfUrl.value.isNotEmpty
                                  ? Colors.green
                                  : const Color(0xFFEBAE1F),
                            ),
                          ),
                          label: const Text(
                            'PDF',
                            style: TextStyle(
                                fontFamily: 'Poppinss', color: Colors.white),
                          ),
                          icon: const Icon(
                            Icons.upload,
                            color: Colors.white,
                          ),
                        );
                      }),
                      Obx(() {
                        if (controller.pdfUrl.value.isNotEmpty) {
                          return Text(
                            'PDF: ${controller.pdfUrl.value}',
                            style: const TextStyle(
                                color: Colors.green, fontFamily: 'Poppins'),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                      const SizedBox(height: 10),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Map<String, dynamic> retorno = isUpdate
                          ? await controller.updateMaterial(materialModel!.id)
                          : await controller.insertMaterial();

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
                    child: Text(
                      isUpdate ? 'ATUALIZAR' : 'CADASTRAR',
                      style: const TextStyle(
                          fontFamily: 'Poppins', color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 120,
                    child: TextButton(
                      onPressed: () {
                        controller.clearAllFields();
                        Get.back();
                      },
                      child: const Text(
                        'CANCELAR',
                        style: TextStyle(
                            fontFamily: 'Poppins', color: Color(0xFFEBAE1F)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
