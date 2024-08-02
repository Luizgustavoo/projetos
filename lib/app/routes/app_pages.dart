import 'package:get/get.dart';
import 'package:projetos/app/data/bindings/company_binding.dart';
import 'package:projetos/app/data/bindings/home_binding.dart';
import 'package:projetos/app/data/bindings/initial_binding.dart';
import 'package:projetos/app/data/bindings/login_binding.dart';
import 'package:projetos/app/data/bindings/fundraiser_binding.dart';
import 'package:projetos/app/data/bindings/bill_binding.dart';
import 'package:projetos/app/data/bindings/material_binding.dart';
import 'package:projetos/app/data/bindings/report_binding.dart';
import 'package:projetos/app/data/bindings/financial_binding.dart';
import 'package:projetos/app/modules/bill/views/detail_bill_view.dart';
import 'package:projetos/app/modules/company/views/all_company_view.dart';
import 'package:projetos/app/modules/company/views/available_company_view.dart';
import 'package:projetos/app/modules/company/views/contact_company_view.dart';
import 'package:projetos/app/modules/company/views/contact_timeline_view.dart';
import 'package:projetos/app/modules/company/views/expiring_company.dart';
import 'package:projetos/app/modules/company/views/my_company_view.dart';
import 'package:projetos/app/modules/fundraiser/views/pending_fundrising_view.dart';
import 'package:projetos/app/modules/home/home_view.dart';
import 'package:projetos/app/modules/initial/initial_view.dart';
import 'package:projetos/app/modules/login/login_view.dart';
import 'package:projetos/app/modules/fundraiser/views/fundraiser_view.dart';
import 'package:projetos/app/modules/bill/views/bill_view.dart';
import 'package:projetos/app/modules/material/material_view.dart';
import 'package:projetos/app/modules/report/report_view.dart';
import 'package:projetos/app/modules/financial/financial_view.dart';
import 'package:projetos/app/routes/app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.initial,
      page: () => const InitialView(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.mycompany,
      page: () => MyCompanyView(),
      binding: CompanyBinding(),
    ),
    GetPage(
      name: Routes.availablecompany,
      page: () => const AvailableCompanyView(),
      binding: CompanyBinding(),
    ),
    GetPage(
      name: Routes.allcompany,
      page: () => const AllCompanyView(),
      binding: CompanyBinding(),
    ),
    GetPage(
      name: Routes.expiringcompany,
      page: () => const ExpiringCompanyView(),
      binding: CompanyBinding(),
    ),
    GetPage(
      name: Routes.contactcompany,
      page: () => const ContactCompanyView(),
      binding: CompanyBinding(),
    ),
    GetPage(
      name: Routes.contacttimeline,
      page: () => const ContactTimeLineView(),
      binding: CompanyBinding(),
    ),
    GetPage(
      name: Routes.fundraiser,
      page: () => FundRaiserView(),
      binding: FundRaiserBinding(),
    ),
    GetPage(
      name: Routes.pendingfundrising,
      page: () => const PendingFundRisingView(),
      binding: FundRaiserBinding(),
    ),
    GetPage(
      name: Routes.report,
      page: () => const ReportView(),
      binding: ReportBinding(),
    ),
    GetPage(
      name: Routes.bill,
      page: () => const BillView(),
      binding: BillBinding(),
    ),
    GetPage(
      name: Routes.detailbill,
      page: () => const DetailBillView(),
      binding: BillBinding(),
    ),
    GetPage(
      name: Routes.financial,
      page: () => const FinancialView(),
      binding: FinancialBinding(),
    ),
    GetPage(
      name: Routes.material,
      page: () => const MaterialView(),
      binding: MaterialBinding(),
    ),
  ];
}
