import 'package:equatable/equatable.dart';

import 'cyoc_generation_result.dart';

enum CyocGenerationStatus { idle, generating, done, failed }

class CyocGenerationProgress extends Equatable {
  const CyocGenerationProgress({this.status = CyocGenerationStatus.idle, this.result});

  final CyocGenerationStatus status;
  final CyocGenerationResult? result;

  bool get isRunning => status == CyocGenerationStatus.generating;

  bool get hasResult => result != null;

  CyocGenerationProgress runningKeepingResult() =>
      CyocGenerationProgress(status: CyocGenerationStatus.generating, result: result);

  CyocGenerationProgress runningClearingResult() =>
      const CyocGenerationProgress(status: CyocGenerationStatus.generating);

  CyocGenerationProgress completed(CyocGenerationResult result) =>
      CyocGenerationProgress(status: CyocGenerationStatus.done, result: result);

  CyocGenerationProgress cancelled() => CyocGenerationProgress(result: result);

  CyocGenerationProgress failed() =>
      CyocGenerationProgress(status: CyocGenerationStatus.failed, result: result);

  @override
  List<Object?> get props => [status, result];
}
