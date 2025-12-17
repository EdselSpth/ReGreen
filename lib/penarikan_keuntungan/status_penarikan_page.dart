import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../service/api_service_keuntungan.dart';

class StatusPenarikanPage extends StatefulWidget {
  const StatusPenarikanPage({super.key});

  @override
  State<StatusPenarikanPage> createState() =>
      _StatusPenarikanPageState();
}

class _StatusPenarikanPageState
    extends State<StatusPenarikanPage> {
  late Future<List<dynamic>> futureStatus;
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      futureStatus =
          ApiServiceKeuntungan.getStatusUser(user!.uid);
    }
  }

  Future<void> refreshData() async {
    setState(() {
      futureStatus =
          ApiServiceKeuntungan.getStatusUser(user!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("User belum login")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Status Penarikan"),
        backgroundColor: const Color(0xFF558B3E),
      ),

      // 🔥 INI BAGIAN BODY YANG DIREPLACE
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: FutureBuilder<List<dynamic>>(
          future: futureStatus,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text("Belum ada penarikan")),
                ],
              );
            }

            final data = snapshot.data!;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];

                Color statusColor;
                IconData statusIcon;

                switch (item['status']) {
                  case 'diterima':
                    statusColor = Colors.green;
                    statusIcon = Icons.check_circle;
                    break;
                  case 'ditolak':
                    statusColor = Colors.red;
                    statusIcon = Icons.cancel;
                    break;
                  default:
                    statusColor = Colors.orange;
                    statusIcon = Icons.hourglass_top;
                }

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    title: Text(
                      "Rp ${item['nominal']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Status: ${item['status']}",
                    ),
                    trailing: Icon(
                      statusIcon,
                      color: statusColor,
                    ),
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
