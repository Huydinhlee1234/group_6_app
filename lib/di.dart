// import 'package:get_it/get_it.dart';
//
// // --- APIs ---
// import 'interfaces/api/iauth_api.dart';
// import 'interfaces/api/iheath_staff_api.dart';
// import 'interfaces/api/istudent_api.dart';
// import 'interfaces/api/ihealth_record_api.dart';
// import 'interfaces/api/icampaign_api.dart';
//
//
// import 'data/implementations/api/auth_api.dart';
// import 'data/implementations/api/student_api.dart';
// import 'data/implementations/api/health_record_api.dart';
// import 'data/implementations/api/campaign_api.dart';
// import 'data/implementations/api/health_staff_api.dart';
//
// // --- Repositories ---
// import 'interfaces/repositories/iauth_repository.dart';
// import 'interfaces/repositories/istudent_repository.dart';
// import 'interfaces/repositories/ihealth_record_repository.dart';
// import 'interfaces/repositories/icampaign_repository.dart';
// import 'interfaces/repositories/ihealth_staff_repository.dart';
//
// import 'data/implementations/repositories/auth_repository.dart';
// import 'data/implementations/repositories/student_repository.dart';
// import 'data/implementations/repositories/health_record_repository.dart';
// import 'data/implementations/repositories/campaign_repository.dart';
// import 'data/implementations/repositories/health_staff_repository.dart';
//
// // --- ViewModels ---
// import 'viewmodels/login/login_viewmodel.dart';
// import 'viewmodels/admin/admin_overview_viewmodel.dart';
// import 'viewmodels/admin/student_management_viewmodel.dart';
// import 'viewmodels/admin/health_staff_management_viewmodel.dart';
// import 'viewmodels/admin/campaign_management_viewmodel.dart';
// import 'viewmodels/admin/reports_viewmodel.dart';
// import 'viewmodels/health_staff/health_staff_dashboard_viewmodel.dart';
//
// final sl = GetIt.instance;
//
// void setupDependencies() {
//   // ---------------------------------------------------------------------------
//   // 1. Data Layer: APIs (Tương tác với DB hoặc Network)
//   // ---------------------------------------------------------------------------
//   sl.registerLazySingleton<IAuthApi>(() => AuthApi());
//   sl.registerLazySingleton<IStudentApi>(() => StudentApi());
//   sl.registerLazySingleton<IHealthRecordApi>(() => HealthRecordApi());
//   sl.registerLazySingleton<ICampaignApi>(() => CampaignApi());
//   sl.registerLazySingleton<IHealthStaffApi>(() => HealthStaffApi());
//
//   // ---------------------------------------------------------------------------
//   // 2. Data Layer: Repositories (Quản lý Data flow, gọi APIs)
//   // ---------------------------------------------------------------------------
//   sl.registerLazySingleton<IAuthRepository>(
//         () => AuthRepository(sl<IAuthApi>()),
//   );
//   sl.registerLazySingleton<IStudentRepository>(
//         () => StudentRepository(sl<IStudentApi>()),
//   );
//   sl.registerLazySingleton<IHealthRecordRepository>(
//         () => HealthRecordRepository(sl<IHealthRecordApi>()),
//   );
//   sl.registerLazySingleton<ICampaignRepository>(
//         () => CampaignRepository(sl<ICampaignApi>()),
//   );
//   sl.registerLazySingleton<IHealthStaffRepository>(
//         () => HealthStaffRepository(sl<IHealthStaffApi>()),
//   );
//
//   // ---------------------------------------------------------------------------
//   // 3. Presentation Layer: ViewModels
//   // Sử dụng registerFactory để mỗi lần gọi là khởi tạo một instance mới (giúp refresh UI)
//   // ---------------------------------------------------------------------------
//
//   // Auth
//   sl.registerFactory(() => LoginViewModel(sl<IAuthRepository>()));
//
//   // Admin ViewModels
//   sl.registerFactory(() => AdminOverviewViewModel(
//     sl<IStudentRepository>(),
//     sl<IHealthRecordRepository>(),
//     sl<ICampaignRepository>(),
//   ));
//
//   sl.registerFactory(() => StudentManagementViewModel(
//     sl<IStudentRepository>(),
//     sl<IHealthRecordRepository>(),
//     sl<ICampaignRepository>(),
//   ));
//
//   sl.registerFactory(() => HealthStaffManagementViewModel(
//     sl<IHealthStaffRepository>(),
//   ));
//
//   sl.registerFactory(() => CampaignManagementViewModel(
//     sl<ICampaignRepository>(),
//   ));
//
//   sl.registerFactory(() => ReportsViewModel(
//     sl<ICampaignRepository>(),
//     sl<IStudentRepository>(),
//     sl<IHealthRecordRepository>(),
//   ));
//
//   // Health Staff ViewModels
//   sl.registerFactory(() => HealthStaffDashboardViewModel(
//     sl<IHealthRecordRepository>(),
//   ));
// }

import 'package:get_it/get_it.dart';

// --- APIs ---
import 'interfaces/api/iauth_api.dart';
import 'interfaces/api/iheath_staff_api.dart';
import 'interfaces/api/istudent_api.dart';
import 'interfaces/api/ihealth_record_api.dart';
import 'interfaces/api/icampaign_api.dart';

import 'data/implementations/api/auth_api.dart';
import 'data/implementations/api/student_api.dart';
import 'data/implementations/api/health_record_api.dart';
import 'data/implementations/api/campaign_api.dart';
import 'data/implementations/api/health_staff_api.dart';

// --- Repositories ---
import 'interfaces/repositories/iauth_repository.dart';
import 'interfaces/repositories/istudent_repository.dart';
import 'interfaces/repositories/ihealth_record_repository.dart';
import 'interfaces/repositories/icampaign_repository.dart';
import 'interfaces/repositories/ihealth_staff_repository.dart';

import 'data/implementations/repositories/auth_repository.dart';
import 'data/implementations/repositories/student_repository.dart';
import 'data/implementations/repositories/health_record_repository.dart';
import 'data/implementations/repositories/campaign_repository.dart';
import 'data/implementations/repositories/health_staff_repository.dart';

// --- ViewModels (Admin) ---
import 'viewmodels/login/login_viewmodel.dart';
import 'viewmodels/admin/admin_overview_viewmodel.dart';
import 'viewmodels/admin/student_management_viewmodel.dart';
import 'viewmodels/admin/health_staff_management_viewmodel.dart';
import 'viewmodels/admin/campaign_management_viewmodel.dart';
import 'viewmodels/admin/reports_viewmodel.dart';

// --- ViewModels (Health Staff) ---
import 'viewmodels/health_staff/health_staff_dashboard_viewmodel.dart';
import 'viewmodels/health_staff/station_selection_viewmodel.dart';
import 'viewmodels/health_staff/student_check_in_viewmodel.dart';
import 'viewmodels/health_staff/station_form_viewmodel.dart';

final sl = GetIt.instance;

void setupDependencies() {
  // 1. Data Layer: APIs
  sl.registerLazySingleton<IAuthApi>(() => AuthApi());
  sl.registerLazySingleton<IStudentApi>(() => StudentApi());
  sl.registerLazySingleton<IHealthRecordApi>(() => HealthRecordApi());
  sl.registerLazySingleton<ICampaignApi>(() => CampaignApi());
  sl.registerLazySingleton<IHealthStaffApi>(() => HealthStaffApi());

  // 2. Data Layer: Repositories
  sl.registerLazySingleton<IAuthRepository>(() => AuthRepository(sl<IAuthApi>()));
  sl.registerLazySingleton<IStudentRepository>(() => StudentRepository(sl<IStudentApi>()));
  sl.registerLazySingleton<IHealthRecordRepository>(() => HealthRecordRepository(sl<IHealthRecordApi>()));
  sl.registerLazySingleton<ICampaignRepository>(() => CampaignRepository(sl<ICampaignApi>()));
  sl.registerLazySingleton<IHealthStaffRepository>(() => HealthStaffRepository(sl<IHealthStaffApi>()));

  // 3. Presentation Layer: ViewModels
  sl.registerFactory(() => LoginViewModel(sl<IAuthRepository>()));

  sl.registerFactory(() => AdminOverviewViewModel(
    sl<IStudentRepository>(),
    sl<IHealthRecordRepository>(),
    sl<ICampaignRepository>(),
  ));

  sl.registerFactory(() => StudentManagementViewModel(
    sl<IStudentRepository>(),
    sl<IHealthRecordRepository>(),
    sl<ICampaignRepository>(),
  ));

  sl.registerFactory(() => HealthStaffManagementViewModel(
    sl<IHealthStaffRepository>(),
  ));

  sl.registerFactory(() => CampaignManagementViewModel(
    sl<ICampaignRepository>(),
  ));

  sl.registerFactory(() => ReportsViewModel(
    sl<ICampaignRepository>(),
    sl<IStudentRepository>(),
    sl<IHealthRecordRepository>(),
  ));

  // ✨ ĐÃ SỬA: Cung cấp đủ 2 Repo cho Dashboard
  sl.registerFactory(() => HealthStaffDashboardViewModel(
    sl<IHealthRecordRepository>(),
    sl<IStudentRepository>(),
  ));

  // ✨ ĐÃ THÊM: Đăng ký 3 ViewModel mới cho luồng khám bệnh
  sl.registerFactory(() => StationSelectionViewModel(
    sl<ICampaignRepository>(),
  ));

  sl.registerFactory(() => StudentCheckInViewModel(
    sl<IStudentRepository>(),
    sl<IHealthRecordRepository>(),
  ));

  sl.registerFactory(() => StationFormViewModel(
    sl<IHealthRecordRepository>(),
    sl<IStudentRepository>(),
  ));
}