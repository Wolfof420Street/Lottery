import 'package:flutter/material.dart';

class NumberGrid extends StatelessWidget {
  final Set<int> selectedNumbers;
  final Function(int) onNumberSelected;

  const NumberGrid({
    super.key,
    required this.selectedNumbers,
    required this.onNumberSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemSize = (constraints.maxWidth - 48) / 5; // Account for padding and spacing
        
        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1.0,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            mainAxisExtent: itemSize,
          ),
          itemCount: 50,
          itemBuilder: (context, index) {
            final number = index + 1;
            final isSelected = selectedNumbers.contains(number);
            
            return GestureDetector(
              onTap: () => onNumberSelected(number),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.0,
                  ),
                ),
                child: Center(
                  child: Text(
                    number.toString(),
                    style: TextStyle(
                      fontSize: itemSize * 0.4, // Responsive font size
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
} 