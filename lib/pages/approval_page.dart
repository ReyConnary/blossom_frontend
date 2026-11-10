import 'package:flutter/material.dart';
import '../models/submission.dart';
import '../services/submission_api.dart';
import '../services/current_user.dart';

class ApprovalPage extends StatefulWidget {
  const ApprovalPage({super.key});

  @override
  State<ApprovalPage> createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage> {
  final SubmissionApi _api = SubmissionApi();
  late Future<List<Submission>> _pendingFuture;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _pendingFuture = _api
        .getPendingForPersonnel(CurrentUser.personnelId!)
        .then((list) => list
            .map((json) => Submission.fromJson(json as Map<String, dynamic>))
            .toList());
  }

  Future<void> _refresh() async {
    setState(_load);
    await _pendingFuture;
  }

  Future<void> _decide(Submission submission, String decision) async {
    try {
      await _api.submitDecision(
        submissionId: submission.submissionId,
        decision: decision,
        personnelId: CurrentUser.personnelId!,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pengajuan "${submission.title}" berhasil diproses')),
        );
      }
      _refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memproses: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Persetujuan Pengajuan')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Submission>>(
          future: _pendingFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return ListView(
                children: [
                  const SizedBox(height: 100),
                  Center(
                    child: Text(
                      'Gagal memuat data.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            }
            final pending = snapshot.data ?? [];
            if (pending.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 100),
                  Center(child: Text('Tidak ada pengajuan yang menunggu persetujuan.')),
                ],
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: pending.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final submission = pending[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        submission.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tahap ${submission.currentStep}',
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      if (submission.description != null &&
                          submission.description!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          submission.description!,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _decide(submission, 'Rejected'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Tolak'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FilledButton(
                              onPressed: () => _decide(submission, 'Approved'),
                              child: const Text('Setujui'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
