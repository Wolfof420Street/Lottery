import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../widgets/number_grid.dart';
import '../widgets/auto_picked_numbers.dart';

class LotteryPickerScreen extends StatefulWidget {
  const LotteryPickerScreen({super.key});

  @override
  State<LotteryPickerScreen> createState() => _LotteryPickerScreenState();
}

class _LotteryPickerScreenState extends State<LotteryPickerScreen> with SingleTickerProviderStateMixin {
  final Set<int> selectedNumbers = {};
  late AnimationController _animationController;
  List<int>? autoPickedNumbers;
  bool isAutoPicked = false;
  bool isTransitioning = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleNumber(int number) {
    if (isAutoPicked || isTransitioning) return;
    
    setState(() {
      if (selectedNumbers.contains(number)) {
        selectedNumbers.remove(number);
      } else if (selectedNumbers.length < 6) {
        selectedNumbers.add(number);
      }
    });
  }

  Future<void> _transitionToGrid() async {
    setState(() {
      isTransitioning = true;
    });
    
    // Reverse the animation to fade out the auto-picked numbers
    await _animationController.reverse();
    
    // Update the selected numbers
    setState(() {
      selectedNumbers.clear();
      selectedNumbers.addAll(autoPickedNumbers!);
      isAutoPicked = false;
      isTransitioning = false;
    });
  }

  void _autoPickNumbers() async {
    final random = Random();
    final numbers = <int>{};
    
    while (numbers.length < 6) {
      numbers.add(random.nextInt(50) + 1);
    }
    
    setState(() {
      autoPickedNumbers = numbers.toList()..sort();
      selectedNumbers.clear();
      isAutoPicked = true;
      _animationController.forward(from: 0.0);
    });

    // Wait for 3 seconds before transitioning back to grid
    await Future.delayed(const Duration(seconds: 3));
    if (mounted && isAutoPicked) {
      await _transitionToGrid();
    }
  }

  void _clearSelection() {
    if (isTransitioning) return;
    
    setState(() {
      selectedNumbers.clear();
      autoPickedNumbers = null;
      isAutoPicked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasValidSelection = selectedNumbers.length == 6 || 
        (autoPickedNumbers != null && autoPickedNumbers!.length == 6);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lottery Number Picker'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton.icon(
                        onPressed: isTransitioning ? null : _autoPickNumbers,
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text('Auto Pick'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton.icon(
                        onPressed: isTransitioning ? null : _clearSelection,
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                constraints: const BoxConstraints.expand(),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: isAutoPicked && autoPickedNumbers != null
                      ? AutoPickedNumbers(
                          key: const ValueKey('auto-picked'),
                          numbers: autoPickedNumbers!,
                          animation: _animationController,
                        )
                      : NumberGrid(
                          key: const ValueKey('number-grid'),
                          selectedNumbers: selectedNumbers,
                          onNumberSelected: _toggleNumber,
                        ),
                ),
              ),
            ),
            if (hasValidSelection)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isTransitioning ? null : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Numbers selected! Ready to proceed.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text('Proceed', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 