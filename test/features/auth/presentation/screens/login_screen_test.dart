import 'package:extro/common/constants/app_strings.dart';
import 'package:extro/features/auth/presentation/widgets/feature_indicators.dart';
import 'package:extro/features/auth/presentation/widgets/login_footer.dart';
import 'package:extro/features/auth/presentation/widgets/login_header.dart';
import 'package:extro/features/auth/presentation/widgets/login_headline.dart';
import 'package:extro/features/auth/presentation/widgets/transaction_preview_card.dart';
import 'package:extro/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginScreen Widgets', () {
    late AppLocalizations localizer;

    setUpAll(() async {
      localizer = await AppLocalizations.delegate.load(const Locale('en'));
    });

    Widget buildTestWidget({required Widget child}) {
      return MaterialApp(
        home: Scaffold(body: child),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      );
    }

    testWidgets('LoginHeader renders with wallet icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(child: const LoginHeader()));

      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
    });

    testWidgets('LoginHeadline renders with correct text structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(child: const LoginHeadline()));

      expect(find.byType(Text), findsExactly(2));
      expect(find.text(localizer.loginSubtitle), findsOneWidget);
    });

    testWidgets('TransactionPreviewCard renders with balance amount', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(child: const TransactionPreviewCard()),
      );

      expect(find.text(AppStrings.balanceAmount), findsOneWidget);
    });

    testWidgets('TransactionPreviewCard displays all transaction icons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(child: const TransactionPreviewCard()),
      );

      expect(find.byIcon(Icons.sync), findsOneWidget);
      expect(find.byIcon(Icons.payments_outlined), findsOneWidget);
      expect(find.byIcon(Icons.train_outlined), findsOneWidget);
      expect(find.byIcon(Icons.restaurant_outlined), findsOneWidget);
    });

    testWidgets('TransactionPreviewCard shows correct amounts', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(child: const TransactionPreviewCard()),
      );

      expect(find.text(AppStrings.londonTravelAmount), findsOneWidget);
      expect(find.text(AppStrings.dinnerAmount), findsOneWidget);
      expect(find.text(AppStrings.freelanceAmount), findsOneWidget);
    });

    testWidgets('FeatureIndicators displays all three indicators', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(child: const FeatureIndicators()),
      );

      expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.byIcon(Icons.currency_exchange), findsOneWidget);
    });

    testWidgets('FeatureIndicators displays correct labels', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(child: const FeatureIndicators()),
      );

      expect(find.text(localizer.offline.toUpperCase()), findsOneWidget);
      expect(find.text(localizer.secure.toUpperCase()), findsOneWidget);
      expect(find.text(localizer.multiCur.toUpperCase()), findsOneWidget);
    });

    testWidgets('LoginFooter displays footer links', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(child: const LoginFooter()));

      expect(find.text(localizer.privacyPolicy), findsOneWidget);
      expect(find.text(localizer.termsOfService), findsOneWidget);
    });
  });
}
