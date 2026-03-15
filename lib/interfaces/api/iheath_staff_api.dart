// lib/interfaces/api/ihealth_staff_api.dart
import '../../domain/entities/user.dart';

abstract class IHealthStaffApi {
  Future<List<User>> getAllHealthStaff();
  Future<User> createHealthStaff(User staff);
  Future<User> updateHealthStaff(User staff);
  Future<void> deleteHealthStaff(String id);
}

