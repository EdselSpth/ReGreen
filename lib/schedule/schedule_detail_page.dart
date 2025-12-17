import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  bool _isLoading = false;
  bool _alreadySubmitted = false;

  Future<void> _submitPenjemputan() async {
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        _showDialog("Gagal", "User belum login");
        return;
      }

      await FirebaseFirestore.instance.collection('penjemputan').add({
        "userId": user.uid,
        "courierName": widget.courierName,
        "scheduleDate": widget.scheduleDate,
        "scheduleTime": widget.scheduleTime,
        "wasteTypes": widget.wasteTypes,
        "address":
            "Komplek Taman Bumi Prima Blok O No 8, Kecamatan Cibabat, Kelurahan Cimahi Utara, Kota Cimahi 40513",
        "status": "menunggu",
        "createdAt": FieldValue.serverTimestamp(),
      });

      setState(() {
        _alreadySubmitted = true;
      });

      _showDialog("Berhasil", "Penjemputan berhasil didaftarkan");
    } catch (e) {
      _showDialog("Error", "Terjadi kesalahan saat menyimpan data");
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

            // WHITE CONTENT AREA
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
                      // IMAGE
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
                      _boxText(widget.courierName),

                      _label("Detail Jadwal"),
                      _boxText(widget.scheduleDate),

                      _label("Detail Waktu"),
                      _boxText(widget.scheduleTime),

                      _label("Jenis Sampah"),
                      _boxText(widget.wasteTypes),

                      _label("Alamat Anda"),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDFE4D5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF558B3E)),
                        ),
                        child: const Text(
                          "Komplek Taman Bumi Prima Blok O No 8, Kecamatan Cibabat, Kelurahan Cimahi Utara, Kota Cimahi 40513",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Center(
                        child: Text(
                          "Keren areamu udah terdaftar!",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // BUTTON
                      GestureDetector(
                        onTap: (_isLoading || _alreadySubmitted)
                            ? null
                            : _submitPenjemputan,
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

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 14),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _boxText(String text) {
    return Container(
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
}
