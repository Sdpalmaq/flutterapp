import 'package:flutter/material.dart';

class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double breakpoint;
  final double bottomPadding;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.spacing = 16,
    this.breakpoint = 600,
    this.bottomPadding = 16, // ← espaciado inferior por defecto
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding), // ← wrap con padding
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < breakpoint) {
            return Column(
              children: children
                  .map((child) => Padding(
                        padding: EdgeInsets.only(bottom: spacing),
                        child: SizedBox(width: double.infinity, child: child),
                      ))
                  .toList(),
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children.asMap().entries.map((entry) {
              final isLast = entry.key == children.length - 1;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: isLast ? 0 : spacing),
                  child: entry.value,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}