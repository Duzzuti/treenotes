import 'package:flutter/material.dart';

class LoadingScaffold extends StatelessWidget {
  final AppBar? appBar;
  final Widget body;
  final bool isLoading;

  const LoadingScaffold(
      {super.key, this.appBar, required this.body, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: appBar,
          body: body,
        ),
        if (isLoading)
          Scaffold(
            // Darken the background
            backgroundColor: Colors.black.withOpacity(0.7),
            body: const Column(
              children: [
                Spacer(flex: 4),
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: SizedBox.expand(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 6,
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 4),
              ],
            ),
          ),
      ],
    );
  }
}
