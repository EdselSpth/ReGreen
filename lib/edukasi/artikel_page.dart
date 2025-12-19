import 'package:flutter/material.dart';
import '../../service/api_service_artikel.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtikelPage extends StatelessWidget {
  const ArtikelPage({super.key});

  Future<void> _openPdf(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Tidak bisa membuka PDF';
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: FutureBuilder<List<dynamic>>(
          future: ApiServiceArtikel.getAllArtikel(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "Belum ada artikel",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            final articles = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: const Color(0xFFDDE7CC),
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _openPdf(article['file_pdf']),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Image (Static / Placeholder)
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: Image.asset(
                            'Assets/onboarding/ob1-image.png',
                            width: double.infinity,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Metadata
                              Row(
                                children: const [
                                  Icon(Icons.picture_as_pdf,
                                      size: 16,
                                      color: Color(0xFF558B3E)),
                                  SizedBox(width: 6),
                                  Text(
                                    "Artikel Edukasi",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF558B3E),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Title
                              Text(
                                article['nama_artikel'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Action
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Text(
                                    "Baca PDF",
                                    style: TextStyle(
                                      color: Color(0xFF558B3E),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(width: 4),
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
            );
          },
        ),
      ),
    );
  }
}
