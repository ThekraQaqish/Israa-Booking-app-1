import 'package:flutter/material.dart';
import 'package:isra_fields_booking/core/theme/app_colors.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final Color placeholderColor;
  final IconData placeholderIcon;
  final double height;

  const ImageCarousel({
    super.key,
    required this.imageUrls,
    required this.placeholderColor,
    required this.placeholderIcon,
    this.height = 220,
  });

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final _pageController = PageController();
  int _current = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.imageUrls;

    if (images.isEmpty) {
      return _buildPlaceholder();
    }

    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (context, i) {
              return Image.network(
                images[i],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholder(),
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return _buildPlaceholder();
                },
              );
            },
          ),
          if (images.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _current == i ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _current == i ? Colors.white : Colors.white54,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                '${_current + 1} / ${images.length}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.placeholderColor,
            widget.placeholderColor.withOpacity(0.7),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          widget.placeholderIcon,
          size: 80,
          color: Colors.white.withOpacity(0.6),
        ),
      ),
    );
  }
}

class CourtImagePlaceholder extends StatelessWidget {
  final Color color;
  final IconData icon;
  final double height;
  final String? label;

  const CourtImagePlaceholder({
    super.key,
    required this.color,
    required this.icon,
    this.height = 160,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withOpacity(0.75)],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(icon, size: 72, color: Colors.white.withOpacity(0.5)),
          ),
          if (label != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  ),
                ),
                child: Text(
                  label!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Colors.white30),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      color: Colors.white70, size: 14),
                  SizedBox(width: 4),
                  Text('أضف صور',
                      style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}