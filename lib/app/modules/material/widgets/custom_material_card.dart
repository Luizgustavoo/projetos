import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/material_controller.dart';
import 'package:projetos/app/data/models/material_model.dart';
import 'package:projetos/app/modules/material/views/pdf_view_page.dart';
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
        onTap: () {
          if (materialModel!.tipo == 'arquivo' &&
              materialModel!.arquivoVideo != null) {
            // Navega para a página de visualização de PDF
            String url =
                'https://captacao.casadobommeninodearapongas.org/public/storage/arquivos/${materialModel!.arquivoVideo}';

            Get.to(() => PdfViewPage(pdfUrl: url));
          } else if (materialModel!.tipo == 'video' &&
              materialModel!.arquivoVideo != null) {
            final controller = Get.put(MaterialController());
            List url = materialModel!.arquivoVideo!.split('=');

            controller.youtube(url[1]);
          }
        },
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
