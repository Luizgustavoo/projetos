import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/material_controller.dart';
import 'package:projetos/app/data/models/material_model.dart';
import 'package:projetos/app/modules/material/views/pdf_view_page.dart';
import 'package:projetos/app/modules/material/widgets/create_material_modal.dart';
import 'package:share_plus/share_plus.dart';

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
            String url =
                'https://captacao.casadobommeninodearapongas.org/public/storage/arquivos/${materialModel!.arquivoVideo}';

            Get.to(() => PdfViewPage(pdfUrl: url), arguments: materialModel);
          } else if (materialModel!.tipo == 'video' &&
              materialModel!.arquivoVideo != null) {
            final controller = Get.put(MaterialController());
            List url = materialModel!.arquivoVideo!.split('=');

            controller.youtube(url[1]);
          }
        },
        leading: materialModel!.tipo == 'arquivo' &&
                materialModel!.arquivoVideo != null
            ? IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  String url =
                      'https://captacao.casadobommeninodearapongas.org/public/storage/arquivos/${materialModel!.arquivoVideo}';
                  Share.share('Veja este arquivo PDF: $url');
                },
              )
            : IconButton(
                onPressed: null,
                icon: Icon(
                  FontAwesomeIcons.youtube,
                  color: Colors.grey.shade600,
                )),
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
