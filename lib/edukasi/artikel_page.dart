import 'package:flutter/material.dart';

class ArtikelPage extends StatelessWidget {
  const ArtikelPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Dummy Artikel
    final List<Map<String, String>> articles = [
      {
        'title': 'Mengapa Daur Ulang Itu Penting?',
        'author': 'ReGreen Team',
        'readTime': '5 min baca',
        'image': 'Assets/onboarding/ob1-image.png', // Placeholder image
        'summary':
            'Daur ulang membantu mengurangi limbah di TPA, menghemat energi, dan melestarikan sumber daya alam kita yang terbatas.',
      },
      {
        'title': 'Panduan Memisahkan Sampah di Rumah',
        'author': 'Sarah Green',
        'readTime': '7 min baca',
        'image': 'Assets/onboarding/ob2-image.png',
        'summary':
            'Bingung membedakan sampah organik dan anorganik? Ikuti panduan praktis ini untuk memulai gaya hidup minim sampah.',
      },
      {
        'title': 'Bahaya Sampah Plastik bagi Lautan',
        'author': 'Dr. Ocean',
        'readTime': '4 min baca',
        'image': 'Assets/onboarding/ob3-image.png',
        'summary':
            'Jutaan ton plastik berakhir di lautan setiap tahun. Pelajari dampaknya terhadap kehidupan laut dan kesehatan kita.',
      },
      {
        'title': 'Cara Mengubah Sampah Makanan Menjadi Kompos',
        'author': 'Budi Tani',
        'readTime': '6 min baca',
        'image': 'Assets/onboarding/ob1-image.png',
        'summary':
            'Jangan buang sisa makananmu! Ubah menjadi pupuk alami yang kaya nutrisi untuk tanaman di halamanmu.',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF558B3E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF558B3E),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Artikel Edukasi',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFE8EDDE),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: const Color(0xFFDDE7CC), // Warna kartu hijau muda
              elevation: 2,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  // Aksi ketika artikel diklik
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Membuka artikel: ${article['title']}"),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar Artikel (Full Width di atas)
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: Image.asset(
                        article['image']!,
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Metadata (Penulis & Waktu)
                          Row(
                            children: [
                              const Icon(
                                Icons.person_outline,
                                size: 16,
                                color: Color(0xFF558B3E),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                article['author']!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF558B3E),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.access_time,
                                size: 16,
                                color: Color(0xFF558B3E),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                article['readTime']!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF558B3E),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Judul
                          Text(
                            article['title']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Ringkasan
                          Text(
                            article['summary']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87.withOpacity(0.7),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Tombol Baca Selengkapnya Kecil
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Text(
                                "Baca Selengkapnya",
                                style: TextStyle(
                                  color: Color(0xFF558B3E),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12,
                                color: Color(0xFF558B3E),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
