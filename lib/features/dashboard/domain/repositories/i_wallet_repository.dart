import 'package:dartz/dartz.dart';
import '../entities/wallet.dart';
import 'package:extro/core/failures/failure.dart';

abstract class IWalletRepository {
  Future<Either<Failure, List<Wallet>>> getAllWallets();
}
