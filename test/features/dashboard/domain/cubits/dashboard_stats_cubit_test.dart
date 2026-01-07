import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:extro/features/dashboard/domain/cubits/dashboard_stats_cubit/dashboard_stats_cubit.dart';
import 'package:extro/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:extro/features/dashboard/domain/repositories/i_dashboard_stats_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIDashboardStatsRepository extends Mock
    implements IDashboardStatsRepository {}

void main() {
  group('DashboardStatsCubit', () {
    late MockIDashboardStatsRepository mockRepository;

    const testStats = DashboardStats(
      totalIncome: 5550.0,
      totalExpenses: 326.49,
    );

    setUp(() {
      mockRepository = MockIDashboardStatsRepository();
    });

    group('Initial State', () {
      test('initial state is DashboardStatsState.initial()', () {
        final cubit = DashboardStatsCubit(repository: mockRepository);
        expect(cubit.state, equals(const DashboardStatsState.initial()));
      });
    });

    group('fetchDashboardStats', () {
      blocTest<DashboardStatsCubit, DashboardStatsState>(
        'emits [loading, success] when fetching stats succeeds',
        build: () {
          when(
            () => mockRepository.getDashboardStats(),
          ).thenAnswer((_) async => const Right(testStats));
          return DashboardStatsCubit(repository: mockRepository);
        },
        act: (cubit) => cubit.fetchDashboardStats(),
        expect: () => [
          const DashboardStatsState.loading(),
          const DashboardStatsState.success(testStats),
        ],
        verify: (_) {
          verify(() => mockRepository.getDashboardStats()).called(1);
        },
      );

      blocTest<DashboardStatsCubit, DashboardStatsState>(
        'emits [loading, success] with zero stats',
        build: () {
          const zeroStats = DashboardStats(
            totalIncome: 0.0,
            totalExpenses: 0.0,
          );
          when(
            () => mockRepository.getDashboardStats(),
          ).thenAnswer((_) async => const Right(zeroStats));
          return DashboardStatsCubit(repository: mockRepository);
        },
        act: (cubit) => cubit.fetchDashboardStats(),
        expect: () => [
          const DashboardStatsState.loading(),
          const DashboardStatsState.success(
            DashboardStats(totalIncome: 0.0, totalExpenses: 0.0),
          ),
        ],
      );

      blocTest<DashboardStatsCubit, DashboardStatsState>(
        'emits [loading, failure] when fetching stats fails',
        build: () {
          when(
            () => mockRepository.getDashboardStats(),
          ).thenAnswer((_) async => const Left(Failure.cache()));
          return DashboardStatsCubit(repository: mockRepository);
        },
        act: (cubit) => cubit.fetchDashboardStats(),
        expect: () => [
          const DashboardStatsState.loading(),
          const DashboardStatsState.failure(Failure.cache()),
        ],
        verify: (_) {
          verify(() => mockRepository.getDashboardStats()).called(1);
        },
      );

      blocTest<DashboardStatsCubit, DashboardStatsState>(
        'emits [loading, failure] with network error',
        build: () {
          when(
            () => mockRepository.getDashboardStats(),
          ).thenAnswer((_) async => const Left(Failure.network()));
          return DashboardStatsCubit(repository: mockRepository);
        },
        act: (cubit) => cubit.fetchDashboardStats(),
        expect: () => [
          const DashboardStatsState.loading(),
          const DashboardStatsState.failure(Failure.network()),
        ],
      );

      blocTest<DashboardStatsCubit, DashboardStatsState>(
        'does not emit new states when cubit is closed',
        build: () {
          when(
            () => mockRepository.getDashboardStats(),
          ).thenAnswer((_) async => const Right(testStats));
          return DashboardStatsCubit(repository: mockRepository);
        },
        act: (cubit) async {
          cubit.fetchDashboardStats();
          await cubit.close();
        },
        expect: () => [const DashboardStatsState.loading()],
      );
    });
  });
}
