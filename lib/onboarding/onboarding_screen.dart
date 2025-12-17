import 'package:flutter/material.dart';
import 'package:regreen/onboarding/onboarding_page.dart';
import 'package:regreen/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color kOnboardingBackground = Color(0xFFE8EDDE);
const Color kGreenButton = Color(0xFF7A9B7A);
const Color kGreenText = Color(0xFF3B5B4F);
const Color kIndicatorInactive = Color(0xFFD9E0D9);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void goToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> onboardingPages = [
      const OnboardingPageContent(
        imagePath: 'Assets/onboarding/ob1-image.png',
        title: 'Selamat Datang Di ReGreen!',
        description:
            'Solusi mudah untuk hidup lebih hijau dan berkelanjutan. Bersama ReGreen, kita jaga bumi dengan langkah kecil yang berarti.',
      ),
      const OnboardingPageContent(
        imagePath: 'Assets/onboarding/ob2-image.png',
        title: 'Setor Sampahmu!',
        description:
            'Pesan pengangkutan sampah praktis langsung dari ponsel kamu.',
      ),
      const OnboardingPageContent(
        imagePath: 'Assets/onboarding/ob3-image.png',
        title: 'Dapatkan Uangmu!',
        description: 'Tarik hasil daur ulangmu dengan mudah dan cepat.',
      ),
    ];

    return Scaffold(
      backgroundColor: kOnboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: goToNextScreen,
                  child: const Text(
                    'Lewati',
                    style: TextStyle(
                      color: kGreenText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: onboardingPages,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingPages.length,
                        (index) => _buildIndicatorDot(index: index),
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage == onboardingPages.length - 1) {
                          goToNextScreen();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kGreenButton,
                        shape: _currentPage == onboardingPages.length - 1
                            ? RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              )
                            : const CircleBorder(),
                        padding: _currentPage == onboardingPages.length - 1
                            ? const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              )
                            : const EdgeInsets.all(16),
                      ),
                      child: _currentPage == onboardingPages.length - 1
                          ? const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Mulai',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            )
                          : const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 24,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget helper untuk membuat Indikator ---
  Widget _buildIndicatorDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.only(right: 8),
      height: 10,
      width: _currentPage == index ? 24 : 10, // Lebar saat aktif
      decoration: BoxDecoration(
        color: _currentPage == index ? kGreenButton : kIndicatorInactive,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
