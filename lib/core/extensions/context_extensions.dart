import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

extension ContextExtensions on BuildContext {
  AppLocalizations get localizer => AppLocalizations.of(this)!;

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => mediaQuery.size;

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  EdgeInsets get padding => mediaQuery.padding;

  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }
}
