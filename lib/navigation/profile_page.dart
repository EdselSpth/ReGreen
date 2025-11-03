import 'package:flutter/material.dart';
import 'package:regreen/navigation/edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const Color kGreenDark = Color(0xFF558B3E);
  static const Color kCream = Color(0xFFE8EDDE);
  static const Color kGreenLight = Color(0xFFDDE7CC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreenDark,
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        backgroundColor: const Color(
          0xFF7F9F4F,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/profile1.jpeg'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: const [
                  Text(
                    'Edsel',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Bergabung Sejak 2025',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Informasi Pribadi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Menggunakan pushReplacement untuk menggantikan halaman tanpa menambah stack
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Edit Profil',
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(Icons.email, 'Email', 'edselspth@gmail.com'),
            const SizedBox(height: 16),
            _buildInfoCard(Icons.phone, 'No. Telepon', '0851-5503-0650'),
            const SizedBox(height: 16),
            _buildInfoCard(
              Icons.location_on,
              'Alamat',
              'Kompleks Taman Bumi Prima Blok O No 8, Kecamatan Cibabat, Kota Cimahi 40513',
            ),
            const SizedBox(height: 32),
            _buildInfoCard(Icons.exit_to_app, 'Lainnya', 'Keluar'),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                children: [
                  // Tombol back
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(999),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Profil Pengguna',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // LAYER krim rounded seperti Home
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: kCream,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Foto profil
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/profile1.jpeg'),
                            ),
                            border: Border.all(color: kGreenDark, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Center(
                        child: Column(
                          children: [
                            Text(
                              'Edsel',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Bergabung Sejak 2025',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Informasi Pribadi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditProfilePage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Edit Profil',
                              style: TextStyle(color: kGreenDark, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      _buildInfoCard(
                        icon: Icons.email,
                        title: 'Email',
                        content: 'edselspth@gmail.com',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        icon: Icons.phone,
                        title: 'No. Telepon',
                        content: '0851-5503-0650',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        icon: Icons.location_on,
                        title: 'Alamat',
                        content:
                            'Kompleks Taman Bumi Prima Blok O No 8, Kecamatan Cibabat, Kota Cimahi 40513',
                      ),

                      const SizedBox(height: 24),
                      const Text(
                        'Lainnya',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        icon: Icons.exit_to_app,
                        title: 'Keluar',
                        content: '',
                      ),
                      const SizedBox(height: 16),
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

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kGreenLight,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black87),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                if (content.isNotEmpty)
                  Text(
                    content,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
