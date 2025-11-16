import 'package:extro/core/failures/failure.dart';

import '../../l10n/app_localizations.dart';

class DisplayError {
  final String title;
  final String message;

  const DisplayError({
    required this.title,
    required this.message,
  });

  static DisplayError fromFailure(
    AppLocalizations localizer,
    Failure failure,
  ) {
    return failure.when(
      network: (message) => DisplayError(
        title: localizer.unknownError,
        message: message ?? localizer.networkError,
      ),
      server: (message) => DisplayError(
        title: localizer.unknownError,
        message: message ?? localizer.unknownError,
      ),
      dataProcessing: (message) => DisplayError(
        title: localizer.unknownError,
        message: message ?? localizer.dataProcessingError,
      ),
      authentication: (message) => DisplayError(
        title: localizer.unknownError,
        message: message ?? localizer.unknownError,
      ),
      notFound: (message) => DisplayError(
        title: localizer.unknownError,
        message: message ?? localizer.unknownError,
      ),
      unknown: (message) => DisplayError(
        title: localizer.unknownError,
        message: message ?? localizer.unknownError,
      ),
    );
  }
}
