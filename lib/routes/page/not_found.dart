import 'package:e_com/core/core.dart';
import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key, this.path = ''});
  final String? path;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text.rich(
          TextSpan(
            text: '404\n',
            style: context.textTheme.displayMedium,
            children: [
              TextSpan(
                text: path,
                style: context.textTheme.titleLarge
                    ?.copyWith(color: Colors.red.shade400),
              ),
              TextSpan(
                text: ' Not Found',
                style: context.textTheme.titleLarge,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
