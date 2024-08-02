import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/material_controller.dart';
import 'package:projetos/app/data/models/material_model.dart';
import 'package:projetos/app/modules/material/widgets/create_material_modal.dart';

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
                        MaterialModel material = controller.listMaterial[index];
                        return Card(
                          color: const Color(0xFFFFF3DB),
                          elevation: 2,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.all(5),
                          child: ListTile(
                            trailing: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.edit_rounded)),
                            // leading: const CircleAvatar(
                            //   radius: 25,
                            //   backgroundImage: NetworkImage(
                            //       'https://planoscelular.claro.com.br/medias/300Wx300H-productCard-18726-dois.png?context=bWFzdGVyfGltYWdlc3w1NTU5N3xpbWFnZS9wbmd8YUdOaEwyZzBNaTg1TnpNeU1UUXdNVEExTnpVNEx6TXdNRmQ0TXpBd1NGOXdjbTlrZFdOMFEyRnlaRjh4T0RjeU5sOWtiMmx6TG5CdVp3fDI0ZDllZTVhNjczZjk0OWFkNzhiZWIwOWM0YTY5MDM3ZThlY2RkYzY0OTA4OWM3MjMzNjlkMGFlNWEwOWI0MDk'),
                            // ),
                            title: Text(
                              material.descricao!,
                              style: const TextStyle(
                                  fontFamily: 'Poppins', fontSize: 14),
                            ),
                            subtitle: Text(
                              material.tipo!,
                              style: const TextStyle(
                                  fontFamily: 'Poppins', fontSize: 13),
                            ),
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
              // controller.clearAllFields();
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
