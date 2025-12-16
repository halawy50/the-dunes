import 'package:the_dunes/features/employees/domain/entities/commission_entity.dart';
import 'package:the_dunes/features/employees/domain/repositories/commission_repository.dart';

class PayCommissionUseCase {
  final CommissionRepository repository;

  PayCommissionUseCase(this.repository);

  Future<CommissionEntity> call(int id, {String? note}) {
    return repository.payCommission(id, note: note);
  }
}



