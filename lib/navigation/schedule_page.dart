import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  String selectedWaste = 'Semua';
  final List<String> wasteTypes = ['Semua', 'Organik', 'Plastik', 'Limbah B3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF558B3E),
      body: SafeArea(
        child: Column(
          children: [
            // === HEADER (CENTER TITLE) ===
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
              child: SizedBox(
                height: 50,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: const Text(
                        'Jadwal Penjemputan\nSampah Tersedia',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // === LAYER PUTIH ===
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8EDDE),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // === DROPDOWN FILTER ===
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDDE7CC),
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedWaste,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                          ),
                          style: const TextStyle(
                            fontWeight:
                                FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          dropdownColor: const Color(0xFFDDE7CC),
                          items: wasteTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text('Jenis Sampah : $type'),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedWaste = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // === LIST JADWAL ===
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _scheduleCard(
                              date: 'Senin, 19 Mei 2025',
                              time: '07:00 - 09:00',
                              type: 'Organik, Plastik',
                              courier: 'Raditya',
                              image: 'Assets/schedule/kurir1.png',
                            ),
                            _scheduleCard(
                              date: 'Senin, 26 Mei 2025',
                              time: '07:00 - 09:00',
                              type: 'Organik, Plastik',
                              courier: 'Edsel',
                              image: 'Assets/schedule/kurir2.png',
                            ),
                            _scheduleCard(
                              date: 'Senin, 2 Juni 2025',
                              time: '07:00 - 09:00',
                              type: 'Organik, Plastik',
                              courier: 'Reza',
                              image: 'Assets/schedule/kurir3.png',
                            ),
                            _scheduleCard(
                              date: 'Senin, 9 Juni 2025',
                              time: '07:00 - 09:00',
                              type: 'Organik, Plastik',
                              courier: 'Abdul',
                              image: 'Assets/schedule/kurir4.png',
                            ),
                            _scheduleCard(
                              date: 'Senin, 9 Juni 2025',
                              time: '07:00 - 09:00',
                              type: 'Organik, Plastik',
                              courier: 'Abdul',
                              image: 'Assets/schedule/kurir1.png',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// === WIDGET CARD JADWAL ===
Widget _scheduleCard({
  required String date,
  required String time,
  required String type,
  required String courier,
  required String image,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFDDE7CC),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        // TEXT AREA
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),

              Text(
                time,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),

              Text("Sampah : $type", style: const TextStyle(fontSize: 12)),
              Text("Kurir : $courier", style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 6),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF558B3E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Tersedia",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(image, width: 95, height: 95, fit: BoxFit.cover),
        ),
      ],
    ),
  );
}
