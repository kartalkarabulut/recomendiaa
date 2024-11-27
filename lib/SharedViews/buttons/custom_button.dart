import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomButton extends ConsumerWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
  });

  final VoidCallback? onPressed;
  final String text;
  final double? width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isButtonWorking = ref.watch(isButtonWorkignProvider);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 60,
        width: width,
        decoration: BoxDecoration(
            color: Colors.deepOrange, borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: isButtonWorking
                ? const CircularProgressIndicator(
                    color: Colors.black,
                  )
                : Text(
                    text,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  )),
      ),
    );
  }
}

final isButtonWorkignProvider = StateProvider<bool>((ref) {
  return false;
});
