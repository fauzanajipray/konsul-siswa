import 'package:flutter/material.dart';

class LoadingProgress extends StatelessWidget {
  const LoadingProgress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
      child: const Center(
        child: AlertDialog(
          content: SizedBox(
            width: 50.0, // Sesuaikan dengan lebar yang Anda inginkan
            height: 50.0, // Sesuaikan dengan tinggi yang Anda inginkan
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
