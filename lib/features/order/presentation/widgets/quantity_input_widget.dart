import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuantityInputWidget extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;

  const QuantityInputWidget({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<QuantityInputWidget> createState() => _QuantityInputWidgetState();
}

class _QuantityInputWidgetState extends State<QuantityInputWidget> {
  late TextEditingController _controller;
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _controller = TextEditingController(text: _currentValue.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      _currentValue++;
      _controller.text = _currentValue.toString();
    });
    widget.onChanged(_currentValue);
  }

  void _decrement() {
    if (_currentValue > 1) {
      setState(() {
        _currentValue--;
        _controller.text = _currentValue.toString();
      });
      widget.onChanged(_currentValue);
    }
  }

  void _onTextChanged(String value) {
    final newValue = int.tryParse(value);
    if (newValue != null && newValue > 0) {
      _currentValue = newValue;
      widget.onChanged(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text('Sipariş Adedi', style: theme.textTheme.bodyMedium),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: theme.inputDecorationTheme.fillColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildButton(context, Icons.remove, _decrement),
              SizedBox(
                width: 70,
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(border: InputBorder.none),
                  onChanged: _onTextChanged,
                ),
              ),
              _buildButton(context, Icons.add, _increment),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context, IconData icon, VoidCallback onTap) {
    return IconButton(icon: Icon(icon, size: 20), onPressed: onTap);
  }
}
