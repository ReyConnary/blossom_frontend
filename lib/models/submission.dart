enum SubmissionStatus { pending, approved, rejected }

// MySQLi returns numeric columns as strings in JSON (e.g. "1" instead of 1),
// so every int field from the API must be parsed through this instead of
// a direct `as int` cast.
int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.parse(value);
  throw FormatException('Expected int-like value, got: $value');
}

SubmissionStatus _parseStatus(String raw) {
  switch (raw) {
    case 'Approved':
      return SubmissionStatus.approved;
    case 'Rejected':
      return SubmissionStatus.rejected;
    case 'Pending':
    default:
      return SubmissionStatus.pending;
  }
}

class Submission {
  final int submissionId;
  final int submissionTypeId;
  final int personnelId;
  final int currentStep;
  final String title;
  final String? description;
  final SubmissionStatus status;
  final String dateCreated;
  final String? dateFinished;

  Submission({
    required this.submissionId,
    required this.submissionTypeId,
    required this.personnelId,
    required this.currentStep,
    required this.title,
    this.description,
    required this.status,
    required this.dateCreated,
    this.dateFinished,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      submissionId: _asInt(json['SubmissionID']),
      submissionTypeId: _asInt(json['SubmissionTypeID']),
      personnelId: _asInt(json['PersonnelID']),
      currentStep: _asInt(json['CurrentStep']),
      title: json['Title'] as String,
      description: json['Description'] as String?,
      status: _parseStatus(json['Status'] as String),
      dateCreated: json['DateCreated'] as String,
      dateFinished: json['DateFinished'] as String?,
    );
  }
}

class SubmissionType {
  final int submissionTypeId;
  final String title;
  final String? description;

  SubmissionType({
    required this.submissionTypeId,
    required this.title,
    this.description,
  });

  factory SubmissionType.fromJson(Map<String, dynamic> json) {
    return SubmissionType(
      submissionTypeId: _asInt(json['SubmissionTypeID']),
      title: json['Title'] as String,
      description: json['Description'] as String?,
    );
  }
}