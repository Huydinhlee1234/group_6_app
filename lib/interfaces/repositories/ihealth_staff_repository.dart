// lib/interfaces/repositories/ihealth_staff_repository.dart
import '../../domain/entities/user.dart';

abstract class IHealthStaffRepository {
  Future<List<User>> getAllHealthStaff();
  Future<User> createHealthStaff(User staff);
  Future<User> updateHealthStaff(User staff);
  Future<void> deleteHealthStaff(String id);
}