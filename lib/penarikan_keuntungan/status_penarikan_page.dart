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

  static const Color kGreenDark = Color(0xFF558B3E);
  static const Color kCream = Color(0xFFE8EDDE);

  @override
  void initState() {
    super.initState();
    _fetchData(refresh: true);

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
            hasMore = newData.length == 10;
            currentPage = 2;
          } else {
            if (newData.isEmpty) {
              hasMore = false;
            } else {
              listStatus.addAll(newData);
              currentPage++;
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
      backgroundColor: kGreenDark,
      appBar: AppBar(
        title: const Text(
          "Riwayat Penarikan",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: kGreenDark,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: kCream,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          child: RefreshIndicator(
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
                      final bool isRejected = item['status']?.toString().toLowerCase() == 'ditolak';

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: (statusStyle['color'] as Color).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(statusStyle['icon'], size: 14, color: statusStyle['color']),
                                        const SizedBox(width: 4),
                                        Text(
                                          (item['status'] ?? 'PENDING').toString().toUpperCase(),
                                          style: TextStyle(color: statusStyle['color'], fontWeight: FontWeight.bold, fontSize: 11),
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
                              
                              // MENAMPILKAN ALASAN JIKA DITOLAK
                              if (isRejected && item['alasan_tolak'] != null) ...[
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.red.shade100),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Alasan Penolakan:",
                                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['alasan_tolak'],
                                        style: const TextStyle(color: Colors.black87, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
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
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13)),
          Text(value?.toString() ?? "-", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}