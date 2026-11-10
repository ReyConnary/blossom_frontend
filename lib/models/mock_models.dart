// Mock in-memory models. No database — placeholders only, to be
// replaced once MySQL/API integration is wired up.

enum SubmissionStatus { pending, approved, rejected }

enum AssignmentStatus { assigned, inProgress, completed, verified, rejected }

class SubmissionItem {
  final String title;
  final String type;
  final int currentStep;
  final int totalSteps;
  final SubmissionStatus status;
  final String dateCreated;

  const SubmissionItem({
    required this.title,
    required this.type,
    required this.currentStep,
    required this.totalSteps,
    required this.status,
    required this.dateCreated,
  });
}

class AssignmentItem {
  final String title;
  final String issuer;
  final AssignmentStatus status;
  final bool proofRequired;
  final String dateCreated;

  const AssignmentItem({
    required this.title,
    required this.issuer,
    required this.status,
    required this.proofRequired,
    required this.dateCreated,
  });
}

// Static mock data so the UI has something to render.
final List<SubmissionItem> mockSubmissions = [
  const SubmissionItem(
    title: 'Cuti Tahunan - 3 Hari',
    type: 'Pengajuan Cuti',
    currentStep: 1,
    totalSteps: 2,
    status: SubmissionStatus.pending,
    dateCreated: '2026-11-01',
  ),
  const SubmissionItem(
    title: 'Reimbursement Transport',
    type: 'Pengajuan Reimbursement',
    currentStep: 2,
    totalSteps: 2,
    status: SubmissionStatus.approved,
    dateCreated: '2026-10-28',
  ),
  const SubmissionItem(
    title: 'Izin Sakit',
    type: 'Pengajuan Izin',
    currentStep: 1,
    totalSteps: 1,
    status: SubmissionStatus.rejected,
    dateCreated: '2026-10-20',
  ),
];

final List<AssignmentItem> mockAssignments = [
  const AssignmentItem(
    title: 'Siapkan Laporan Bulanan',
    issuer: 'Ibu Siti (Manager)',
    status: AssignmentStatus.inProgress,
    proofRequired: true,
    dateCreated: '2026-11-02',
  ),
  const AssignmentItem(
    title: 'Update Data Siswa Baru',
    issuer: 'Bapak Rian (Manager)',
    status: AssignmentStatus.completed,
    proofRequired: true,
    dateCreated: '2026-10-30',
  ),
  const AssignmentItem(
    title: 'Rapat Koordinasi Mingguan',
    issuer: 'Ibu Siti (Manager)',
    status: AssignmentStatus.verified,
    proofRequired: false,
    dateCreated: '2026-10-25',
  ),
];
