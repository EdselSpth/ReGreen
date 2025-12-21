import 'package:flutter/material.dart';
import 'package:regreen/service/schedule_service.dart';

class ScheduleDetailPage extends StatefulWidget {
  final String courierName;
  final String scheduleDate;
  final String scheduleTime;
  final String wasteTypes;
  final String courierImage;

  const ScheduleDetailPage({
    super.key,
    required this.courierName,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.wasteTypes,
    required this.courierImage,
  });

  @override
  State<ScheduleDetailPage> createState() => _ScheduleDetailPageState();
}

class _ScheduleDetailPageState extends State<ScheduleDetailPage> {
  final ScheduleService _service = ScheduleService();

  bool _isLoading = false;
  bool _alreadySubmitted = false;

  final String _address =
      "Komplek Taman Bumi Prima Blok O No 8, Kecamatan Cibabat, Kelurahan Cimahi Utara, Kota Cimahi 40513";

  Future<void> _handleSubmit() async {
    setState(() => _isLoading = true);

    try {
      await _service.submitPenjemputan(
        courierName: widget.courierName,
        scheduleDate: widget.scheduleDate,
        scheduleTime: widget.scheduleTime,
        wasteTypes: widget.wasteTypes,
        address: _address,
      );

      setState(() => _alreadySubmitted = true);

      _showDialog("Berhasil", "Penjemputan berhasil didaftarkan");
    } catch (e) {
      _showDialog("Gagal", e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF558B3E),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, size: 22),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      "Detail Penjemputan\nSampah",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 35),
                ],
              ),
            ),

            // CONTENT
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8EDDE),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset(
                            widget.courierImage,
                            width: 130,
                            height: 130,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      _label("Nama Kurir"),
                      _box(widget.courierName),

                      _label("Detail Jadwal"),
                      _box(widget.scheduleDate),

                      _label("Detail Waktu"),
                      _box(widget.scheduleTime),

                      _label("Jenis Sampah"),
                      _box(widget.wasteTypes),

                      _label("Alamat Anda"),
                      _box(_address),

                      const SizedBox(height: 25),

                      GestureDetector(
                        onTap: (_isLoading || _alreadySubmitted)
                            ? null
                            : _handleSubmit,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _alreadySubmitted
                                ? Colors.grey
                                : const Color(0xFF558B3E),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    _alreadySubmitted
                                        ? "Sudah Terdaftar"
                                        : "Daftar Penjemputan",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4, top: 14),
    child: Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
    ),
  );

  Widget _box(String text) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFDDE7CC),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    ),
  );
}
