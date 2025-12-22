import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../service/api_service_keuntungan.dart';

class StatusPenarikanPage extends StatefulWidget {
  const StatusPenarikanPage({super.key});

  @override
  State<StatusPenarikanPage> createState() => _StatusPenarikanPageState();
}

class _StatusPenarikanPageState extends State<StatusPenarikanPage> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> listStatus = [];
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 1;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchData(); // Ambil data awal tanpa loading screen
    
    // Listener untuk tetap mengambil data halaman berikutnya saat scroll (Pagination)
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9 &&
          !isLoading &&
          hasMore) {
        _fetchData();
      }
    });
  }

  Future<void> _fetchData({bool refresh = false}) async {
    if (user == null || isLoading) return;

    if (refresh) {
      currentPage = 1;
      hasMore = true;
    }

    isLoading = true; // Set true secara internal tanpa memicu UI loading indicator

    try {
      final newData = await ApiServiceKeuntungan.getStatusUser(
        user!.uid,
        page: refresh ? 1 : currentPage,
        limit: 10,
      );

      if (mounted) {
        setState(() {
          isLoading = false;
          if (refresh) {
            listStatus = newData;
            currentPage = 2;
          } else {
            if (newData.isEmpty) {
              hasMore = false;
            } else {
              listStatus.addAll(newData);
              currentPage++;
            }
          }
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      print("Error: $e");
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Status Penarikan"),
        backgroundColor: const Color(0xFF558B3E),
        elevation: 0,
      ),
      // Pull-to-Refresh adalah satu-satunya indikator loading yang tersisa
      body: RefreshIndicator(
        onRefresh: () => _fetchData(refresh: true),
        color: const Color(0xFF558B3E),
        child: listStatus.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text("Belum ada riwayat penarikan")),
                  Center(child: Text("Tarik ke bawah untuk memuat", style: TextStyle(color: Colors.grey, fontSize: 12))),
                ],
              )
            : ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: listStatus.length, // Tidak ada tambahan item untuk loading indicator
                itemBuilder: (context, index) {
                  final item = listStatus[index];
                  
                  Color statusColor;
                  IconData statusIcon;
                  switch (item['status'].toString().toLowerCase()) {
                    case 'diterima':
                      statusColor = Colors.green;
                      statusIcon = Icons.check_circle_outline;
                      break;
                    case 'ditolak':
                      statusColor = Colors.red;
                      statusIcon = Icons.highlight_off;
                      break;
                    default:
                      statusColor = Colors.orange;
                      statusIcon = Icons.access_time;
                  }

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rp ${item['nominal']}",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Icon(statusIcon, color: statusColor, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    item['status'].toString().toUpperCase(),
                                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          _buildDetailItem("Penerima", item['nama_pengguna']),
                          _buildDetailItem("Metode", item['metode']),
                          _buildDetailItem("Rekening", item['rekening']),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildDetailItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13)),
          Text(
            value?.toString() ?? "-",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}