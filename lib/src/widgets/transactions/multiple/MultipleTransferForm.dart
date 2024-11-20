import 'package:flutter/material.dart';
import '../../CustomTextField.dart';
import '../../contact/ContactFormField.dart';

class MultipleTransferForm extends StatefulWidget {
  final Function(double amount, List<String> selectedContacts) onTransfer;

  const MultipleTransferForm({Key? key, required this.onTransfer}) : super(key: key);

  @override
  State<MultipleTransferForm> createState() => _MultipleTransferFormState();
}

class _MultipleTransferFormState extends State<MultipleTransferForm> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _amountReceivedController = TextEditingController();
  final TextEditingController _contactsController = TextEditingController();
  List<String> _selectedContacts = [];

  void _syncAmounts({bool isSend = true}) {
    final amount = double.tryParse(isSend ? _amountController.text : _amountReceivedController.text);
    if (amount == null) return;

    if (isSend) {
      final received = amount - (amount * 0.01);
      _amountReceivedController.text = received.toStringAsFixed(2);
    } else {
      final send = amount / 0.99;
      _amountController.text = send.toStringAsFixed(2);
    }
  }

  void _handleTransfer() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0 || _selectedContacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez saisir un montant valide et sélectionner des contacts.")),
      );
      return;
    }
    widget.onTransfer(amount, _selectedContacts);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: _amountController,
          label: "Montant à envoyer",
          prefixIcon: Icons.attach_money,
          keyboardType: TextInputType.number,
          onChanged: (_) => _syncAmounts(isSend: true),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _amountReceivedController,
          label: "Montant reçu",
          prefixIcon: Icons.money,
          keyboardType: TextInputType.number,
          onChanged: (_) => _syncAmounts(isSend: false),
        ),
        const SizedBox(height: 16),
        ContactFormField(
          controller: _contactsController,
          label: "Saisissez un numéro",
          multipleSelection: true,
          onContactsSelected: (contacts) {
            setState(() {
              _selectedContacts = contacts;
            });
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _handleTransfer,
          child: const Text("Envoyer"),
        ),
      ],
    );
  }
}