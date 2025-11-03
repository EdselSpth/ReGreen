import 'package:flutter/material.dart';

class PenarikanKeuntunganPage extends StatefulWidget {
  const PenarikanKeuntunganPage({super.key});

  @override
  State<PenarikanKeuntunganPage> createState() =>
      _PenarikanKeuntunganPageState();
}

class _PenarikanKeuntunganPageState extends State<PenarikanKeuntunganPage> {
  String? selectedBank = 'BNI';

  final TextEditingController _rekeningController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF558B3E),
      body: Column(
        children: [
          // header
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 10,
              right: 20,
              bottom: 10,
            ),
            width: double.infinity,
            color: const Color(0xFF558B3E),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 100),
                const Text(
                  "Penarikan Keuntungan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),

          //Scrollable
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    const Text(
                      'Saldo',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Rp. 200.000.000,00',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 30),

                    _inputField('Nomor Rekening', _rekeningController),
                    const SizedBox(height: 16),

                    _bankOption('BNI'),
                    _bankOption('BCA'),
                    _bankOption('MANDIRI'),
                    _bankOption('BRI'),

                    const SizedBox(height: 20),

                    _inputField('Nominal', _nominalController),
                    const SizedBox(height: 6),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Minimal Penarikan Rp. 50.000',
                        style: TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF558B3E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Tarik',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: label == 'Nominal'
          ? TextInputType.number
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _bankOption(String bankName) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: RadioListTile<String>(
        value: bankName,
        groupValue: selectedBank,
        onChanged: (value) {
          setState(() {
            selectedBank = value;
          });
        },
        title: Text(
          bankName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        activeColor: const Color(0xFF558B3E),
      ),
    );
  }
}
