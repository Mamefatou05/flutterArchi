import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

import '../CustomTextField.dart';

class ContactFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool multipleSelection;
  final ValueChanged<List<String>>? onContactsSelected;

  const ContactFormField({
    Key? key,
    required this.controller,
    this.label = "Numéro de téléphone",
    this.multipleSelection = false,
    this.onContactsSelected,
  }) : super(key: key);

  @override
  State<ContactFormField> createState() => _ContactFormFieldState();
}

class _ContactFormFieldState extends State<ContactFormField> {
  final TextEditingController _nameController = TextEditingController();
  final List<String> _selectedNumbers = [];
  bool _showNameField = false;

  Future<void> _saveContact(String phoneNumber, String name) async {
    try {
      final status = await Permission.contacts.request();
      if (!status.isGranted) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permission de contact refusée")),
        );
        return;
      }

      final newContact = Contact()
        ..givenName = name
        ..phones = [Item(value: phoneNumber)];

      await ContactsService.addContact(newContact);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contact enregistré avec succès")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'enregistrement: $e")),
      );
    }
  }

  void _addPhoneNumber(String number) {
    if (!widget.multipleSelection) {
      widget.controller.text = number;
      widget.onContactsSelected?.call([number]);
    } else {
      setState(() {
        _selectedNumbers.add(number);
      });
      widget.onContactsSelected?.call(_selectedNumbers);
    }
  }

  Future<void> _showSaveContactDialog(String phoneNumber) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enregistrer le contact"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nom du contact",
                hintText: "Entrez le nom",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              _saveContact(phoneNumber, _nameController.text);
              Navigator.of(context).pop();
              _nameController.clear();
            },
            child: const Text("Enregistrer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: widget.controller,
                label: widget.label,
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: () {
                if (widget.controller.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Veuillez entrer un numéro")),
                  );
                  return;
                }
                _addPhoneNumber(widget.controller.text);
                if (!widget.multipleSelection) {
                  _showSaveContactDialog(widget.controller.text);
                } else {
                  widget.controller.clear();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                if (widget.controller.text.isNotEmpty) {
                  _showSaveContactDialog(widget.controller.text);
                }
              },
            ),
          ],
        ),
        if (widget.multipleSelection && _selectedNumbers.isNotEmpty) ...[
          const SizedBox(height: 16),
          Card(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _selectedNumbers.length,
              itemBuilder: (context, index) {
                final number = _selectedNumbers[index];
                return ListTile(
                  title: Text(number),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.save),
                        onPressed: () => _showSaveContactDialog(number),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () {
                          setState(() {
                            _selectedNumbers.removeAt(index);
                          });
                          widget.onContactsSelected?.call(_selectedNumbers);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}