import '../../../domain/entities/user.dart';
import '../../../interfaces/api/iheath_staff_api.dart';
import '../../../interfaces/repositories/ihealth_staff_repository.dart';

class HealthStaffRepository implements IHealthStaffRepository {
  final IHealthStaffApi _api;

  HealthStaffRepository(this._api);

  @override
  Future<List<User>> getAllHealthStaff() => _api.getAllHealthStaff();

  @override
  Future<User> createHealthStaff(User staff) => _api.createHealthStaff(staff);

  @override
  Future<User> updateHealthStaff(User staff) => _api.updateHealthStaff(staff);

  @override
  Future<void> deleteHealthStaff(String id) => _api.deleteHealthStaff(id);
}