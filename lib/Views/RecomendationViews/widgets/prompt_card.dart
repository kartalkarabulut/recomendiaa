import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PromptCard extends StatefulWidget {
  const PromptCard({
    Key? key,
    required this.prompt,
    required this.promptController,
  }) : super(key: key);

  final String prompt;
  final TextEditingController promptController;

  @override
  State<PromptCard> createState() => _PromptCardState();
}

class _PromptCardState extends State<PromptCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  bool _isHovered = false;
  late Animation<double> _scaleAnimation;

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animController.reverse();
      },
      child: GestureDetector(
        onTap: () {
          widget.promptController.text = widget.prompt;
          HapticFeedback.lightImpact();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 200,
              // height: 20,
              // constraints: const BoxConstraints(minHeight: 150),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.purple.withOpacity(0.7),
                    Colors.blue.withOpacity(0.5),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? Colors.purple.withOpacity(0.5)
                        : Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: BackgroundPatternPainter(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: Colors.white.withOpacity(0.9),
                            size: 20,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.prompt,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
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
  }
}

class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < size.width + size.height; i += 20) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(i.toDouble(), 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PromptScrollView extends StatelessWidget {
  const PromptScrollView({
    Key? key,
    required this.prompts,
    required this.promptController,
  }) : super(key: key);

  final TextEditingController promptController;
  final List<String> prompts;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: prompts
            .map((prompt) => PromptCard(
                  prompt: prompt,
                  promptController: promptController,
                ))
            .toList(),
      ),
    );
  }
}
