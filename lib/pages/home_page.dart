import 'package:flutter/material.dart';
import 'submission_page.dart';
import 'approval_page.dart';
import 'assignment_page.dart';
import '../services/current_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blossom School'),
        centerTitle: false,
        actions: [
          // TEMPORARY: lets you switch between Budi (Pekerja) and Siti
          // (Manager) without real auth, for testing both roles.
          // Remove once login is implemented.
          // PopupMenuButton<int>(
          //   icon: const Icon(Icons.person_outline),
          //   onSelected: (id) {
          //     setState(() {
          //       CurrentUser.personnelId = id;
          //       CurrentUser.fullName = id == 3 ? 'Budi Santoso' : 'Ibu Siti Nurhaliza';
          //     });
          //   },
          //   itemBuilder: (context) => const [
          //     PopupMenuItem(value: 3, child: Text('Budi (Pekerja)')),
          //     PopupMenuItem(value: 2, child: Text('Siti (Manager)')),
          //   ],
          // ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selamat datang,',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              Text(
                CurrentUser.fullName,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const Text(
                'Menu Utama',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _MenuTile(
                icon: Icons.fact_check_outlined,
                title: 'Pengajuan',
                subtitle: 'Ajukan dan pantau status persetujuan',
                color: Colors.indigo,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SubmissionPage()),
                ),
              ),
              const SizedBox(height: 12),
              _MenuTile(
                icon: Icons.rule_folder_outlined,
                title: 'Persetujuan',
                subtitle: 'Tinjau pengajuan yang menunggu keputusan Anda',
                color: Colors.deepPurple,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ApprovalPage()),
                ),
              ),
              const SizedBox(height: 12),
              _MenuTile(
                icon: Icons.checklist_rtl_outlined,
                title: 'Penugasan',
                subtitle: 'Belum terhubung ke backend',
                color: Colors.grey,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AssignmentPage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.black45),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black26),
            ],
          ),
        ),
      ),
    );
  }
}
