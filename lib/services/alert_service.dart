
import 'package:flutter/material.dart';

class CustomToast {
  final String message;
  final IconData icon;
  final Color iconColor;

  CustomToast({
    required this.message,
    required this.icon,
    required this.iconColor,
  });

  // Animasyonlu toast gösterimi
  void show(BuildContext context) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    final AnimationController controller = AnimationController(
      vsync: NavigatorState(),
      duration: const Duration(milliseconds: 500),
    );

    // Animasyonlu görünüm ve kaybolma işlemleri
    final Animation<Offset> offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1), // Ekranın dışında (yukarıda)
      end: const Offset(0, 0), // Normal pozisyonuna hareket
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    // OverlayEntry ile bildirimin yapısı
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: 20.0,
        right: 20.0,
        child: Material(
          color: Colors.transparent,
          child: SlideTransition(
            position: offsetAnimation,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    size: 28,
                    color: iconColor,
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // Overlay'e ekleyin
    overlay?.insert(overlayEntry);

    // Animasyonu başlat
    controller.forward();

    // Bildirimi 3 saniye sonra kaldır
    Future.delayed(const Duration(seconds: 3)).then((_) {
      controller.reverse().then((_) {
        overlayEntry.remove(); // Bildirimi kaldır
      });
    });
  }
}
