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
    _fetchData(refresh: true); // Ambil data pertama kali

    // Logika Pagination: Ambil data tambahan saat scroll mendekati bawah
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore) {
        _fetchData();
      }
    });
  }

  Future<void> _fetchData({bool refresh = false}) async {
    if (user == null || (isLoading && !refresh)) return;

    setState(() => isLoading = true);

    if (refresh) {
      currentPage = 1;
      hasMore = true;
    }

    try {
      final newData = await ApiServiceKeuntungan.getStatusUser(
        user!.uid,
        page: currentPage,
        limit: 10,
      );

      if (mounted) {
        setState(() {
          isLoading = false;
          if (refresh) {
            listStatus = newData;
            // Jika data baru lebih kecil dari limit, maka tidak ada lagi data selanjutnya
            hasMore = newData.length == 10;
            currentPage = 2;
          } else {
            if (newData.isEmpty) {
              hasMore = false;
            } else {
              listStatus.addAll(newData);
              currentPage++;
              // Jika data yang baru saja diambil kurang dari 10, matikan hasMore
              if (newData.length < 10) hasMore = false;
            }
          }
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      print("Error fetching status: $e");
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Fungsi helper untuk format status
  Map<String, dynamic> _getStatusStyle(String? status) {
    switch (status?.toLowerCase()) {
      case 'diterima':
        return {'color': Colors.green, 'icon': Icons.check_circle};
      case 'ditolak':
        return {'color': Colors.red, 'icon': Icons.cancel};
      default:
        return {'color': Colors.orange, 'icon': Icons.pending_actions};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Penarikan"),
        backgroundColor: const Color(0xFF558B3E),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchData(refresh: true),
        color: const Color(0xFF558B3E),
        child: listStatus.isEmpty && !isLoading
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 250),
                  Center(child: Text("Belum ada riwayat penarikan")),
                  Center(
                    child: Text(
                      "Tarik ke bawah untuk memuat",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: listStatus.length,
                itemBuilder: (context, index) {
                  final item = listStatus[index];
                  final statusStyle = _getStatusStyle(item['status']);

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
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
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: (statusStyle['color'] as Color)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      statusStyle['icon'],
                                      size: 14,
                                      color: statusStyle['color'],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      (item['status'] ?? 'PENDING')
                                          .toString()
                                          .toUpperCase(),
                                      style: TextStyle(
                                        color: statusStyle['color'],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          _buildRowInfo("Metode", item['metode']),
                          _buildRowInfo("Rekening", item['rekening']),
                          _buildRowInfo("Nama", item['nama_pengguna']),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildRowInfo(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          Text(
            value?.toString() ?? "-",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
