import 'package:flutter/material.dart';
import '../models/submission.dart';
import '../services/submission_api.dart';
import '../services/current_user.dart';
import '../widgets/status_badge.dart';

class SubmissionPage extends StatefulWidget {
  const SubmissionPage({super.key});

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  final SubmissionApi _api = SubmissionApi();
  late Future<List<Submission>> _submissionsFuture;

  @override
  void initState() {
    super.initState();
    _loadSubmissions();
  }

  void _loadSubmissions() {
    _submissionsFuture = _api
        .getSubmissionsForPersonnel(CurrentUser.personnelId!)
        .then((list) => list
            .map((json) => Submission.fromJson(json as Map<String, dynamic>))
            .toList());
  }

  Future<void> _refresh() async {
    setState(_loadSubmissions);
    await _submissionsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengajuan')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewSubmissionSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Ajukan Baru'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Submission>>(
          future: _submissionsFuture,
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
            final submissions = snapshot.data ?? [];
            if (submissions.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 100),
                  Center(child: Text('Belum ada pengajuan.')),
                ],
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: submissions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) =>
                  _SubmissionCard(submission: submissions[index]),
            );
          },
        ),
      ),
    );
  }

  void _showNewSubmissionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _NewSubmissionForm(
        api: _api,
        onCreated: () {
          Navigator.pop(context);
          _refresh();
        },
      ),
    );
  }
}

class _NewSubmissionForm extends StatefulWidget {
  final SubmissionApi api;
  final VoidCallback onCreated;

  const _NewSubmissionForm({required this.api, required this.onCreated});

  @override
  State<_NewSubmissionForm> createState() => _NewSubmissionFormState();
}

class _NewSubmissionFormState extends State<_NewSubmissionForm> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  List<SubmissionType> _types = [];
  SubmissionType? _selectedType;
  bool _loadingTypes = true;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTypes();
  }

  Future<void> _loadTypes() async {
    try {
      final raw = await widget.api.getSubmissionTypes();
      setState(() {
        _types = raw
            .map((j) => SubmissionType.fromJson(j as Map<String, dynamic>))
            .toList();
        _loadingTypes = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat jenis pengajuan: $e';
        _loadingTypes = false;
      });
    }
  }

  Future<void> _submit() async {
    if (_selectedType == null || _titleController.text.trim().isEmpty) {
      setState(() => _error = 'Jenis pengajuan dan judul wajib diisi');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await widget.api.createSubmission(
        submissionTypeId: _selectedType!.submissionTypeId,
        personnelId: CurrentUser.personnelId!,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
      );
      widget.onCreated();
    } catch (e) {
      setState(() {
        _error = 'Gagal mengirim pengajuan: $e';
        _submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pengajuan Baru',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (_loadingTypes)
            const Center(child: CircularProgressIndicator())
          else
            DropdownButtonFormField<SubmissionType>(
              decoration: const InputDecoration(
                labelText: 'Jenis Pengajuan',
                border: OutlineInputBorder(),
              ),
              items: _types
                  .map((t) => DropdownMenuItem(
                        value: t,
                        child: Text(t.title),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedType = value),
            ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Judul',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Deskripsi',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submitting ? null : _submit,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: _submitting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Kirim Pengajuan'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmissionCard extends StatelessWidget {
  final Submission submission;
  const _SubmissionCard({required this.submission});

  @override
  Widget build(BuildContext context) {
    final statusInfo = _statusInfo(submission.status);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  submission.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              StatusBadge(label: statusInfo.label, color: statusInfo.color),
            ],
          ),
          const SizedBox(height: 4),
          if (submission.description != null && submission.description!.isNotEmpty)
            Text(
              submission.description!,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          const SizedBox(height: 10),
          Text(
            submission.status == SubmissionStatus.pending
                ? 'Tahap ${submission.currentStep}'
                : 'Diajukan ${submission.dateCreated}',
            style: const TextStyle(fontSize: 11, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  ({String label, Color color}) _statusInfo(SubmissionStatus status) {
    switch (status) {
      case SubmissionStatus.pending:
        return (label: 'Pending', color: Colors.orange);
      case SubmissionStatus.approved:
        return (label: 'Disetujui', color: Colors.green);
      case SubmissionStatus.rejected:
        return (label: 'Ditolak', color: Colors.red);
    }
  }
}
