import 'package:get/get.dart';
import 'package:projetos/app/data/controllers/company_controller.dart';
import 'package:projetos/app/data/repositories/company_repository.dart';

class CompanyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompanyController>(() => CompanyController());
    Get.lazyPut<CompanyRepository>(() => CompanyRepository());
  }
}
