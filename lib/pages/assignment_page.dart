import 'package:flutter/material.dart';
import '../models/mock_models.dart';
import '../widgets/status_badge.dart';

class AssignmentPage extends StatelessWidget {
  const AssignmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Penugasan')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: mockAssignments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = mockAssignments[index];
          return _AssignmentCard(item: item);
        },
      ),
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  final AssignmentItem item;
  const _AssignmentCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final statusInfo = _statusInfo(item.status);
    final actionLabel = _actionLabel(item.status);

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
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              StatusBadge(label: statusInfo.label, color: statusInfo.color),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Dari: ${item.issuer}',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(
                item.proofRequired
                    ? Icons.camera_alt_outlined
                    : Icons.check_circle_outline,
                size: 14,
                color: Colors.black38,
              ),
              const SizedBox(width: 4),
              Text(
                item.proofRequired
                    ? 'Memerlukan bukti foto'
                    : 'Tanpa bukti',
                style: const TextStyle(fontSize: 11, color: Colors.black45),
              ),
            ],
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: null, // belum terhubung ke database
                child: Text(actionLabel),
              ),
            ),
          ],
        ],
      ),
    );
  }

  ({String label, Color color}) _statusInfo(AssignmentStatus status) {
    switch (status) {
      case AssignmentStatus.assigned:
        return (label: 'Ditugaskan', color: Colors.blueGrey);
      case AssignmentStatus.inProgress:
        return (label: 'Dikerjakan', color: Colors.orange);
      case AssignmentStatus.completed:
        return (label: 'Selesai', color: Colors.indigo);
      case AssignmentStatus.verified:
        return (label: 'Terverifikasi', color: Colors.green);
      case AssignmentStatus.rejected:
        return (label: 'Ditolak', color: Colors.red);
    }
  }

  String? _actionLabel(AssignmentStatus status) {
    switch (status) {
      case AssignmentStatus.assigned:
        return 'Mulai Kerjakan';
      case AssignmentStatus.inProgress:
        return 'Tandai Selesai';
      case AssignmentStatus.completed:
      case AssignmentStatus.verified:
      case AssignmentStatus.rejected:
        return null;
    }
  }
}
