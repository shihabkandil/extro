import 'package:dartz/dartz.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/repositories/i_wallet_repository.dart';
import '../data_sources/i_dashboard_local_data_source.dart';
import 'package:extro/core/failures/failure.dart';

class WalletRepository implements IWalletRepository {
  final IDashboardLocalDataSource localDataSource;

  WalletRepository({required this.localDataSource});

  @override
  Future<Either<Failure, List<Wallet>>> getAllWallets() async {
    try {
      final responses = await localDataSource.getAllWallets();
      final wallets = responses.map((e) => Wallet(
        id: e.id,
        label: e.label,
        balance: e.balance,
        currency: e.currency,
        icon: e.icon,
        accentColor: e.accentColor,
      )).toList();
      return Right(wallets);
    } catch (e) {
      return Left(Failure.dataProcessing());
    }
  }
}
