import 'package:chorebuddies_flutter/UI/styles/button_styles.dart';
import 'package:chorebuddies_flutter/UI/widgets/g_form_field.dart';
import 'package:chorebuddies_flutter/features/households/create_edit_page/create_edit_household_page.dart';
import 'package:chorebuddies_flutter/features/households/models/household.dart';
import 'package:flutter/material.dart';

class CreateEditHouseholdForm extends StatefulWidget {
  final Household model;
  final PageMode pageMode;
  final ValueChanged<Household>? onValidSubmit;
  final ValueChanged<PageMode>? onPageModeChanged;
  final bool showCancel;

  const CreateEditHouseholdForm({
    super.key,
    required this.model,
    required this.pageMode,
    this.onValidSubmit,
    this.onPageModeChanged,
    this.showCancel = true,
  });

  @override
  State<CreateEditHouseholdForm> createState() => _CreateEditHouseholdFormState();
}

class _CreateEditHouseholdFormState extends State<CreateEditHouseholdForm> {
  bool _isLoading = false;

  late final TextEditingController nameController;
  late final TextEditingController descriptionController;

  late PageMode mode;

  final _formKey = GlobalKey<FormState>();
  void _onSave() {
    _isLoading = true;
    if (_formKey.currentState?.validate() ?? false) {
      final model = widget.model;
      model.name = nameController.text;
      model.description = descriptionController.text;

      widget.onValidSubmit?.call(model);
    }
    _isLoading = false;
    if(mode == PageMode.create) return;
    setState(() => mode = PageMode.view);
    widget.onPageModeChanged?.call(mode);
  }

  Future<void> _switchToEdit() async {
    setState(() => mode = PageMode.edit);
    widget.onPageModeChanged?.call(mode);
  }

  @override
  void initState() {
    super.initState();

    mode = widget.pageMode;
    final model = widget.model;
    nameController = TextEditingController(text: model.name);
    descriptionController = TextEditingController(text: model.description);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GFormField(
            labelText: 'Name',
            controller: nameController,
            readonly: mode == PageMode.view,
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),

          GFormField(
            labelText: 'Description',
            controller: descriptionController,
            readonly: mode == PageMode.view,
            maxLines: null,
          ),

          const SizedBox(height: 24),

          if (mode == PageMode.view)
            Row(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _switchToEdit()),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          if (mode != PageMode.view)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (mode == PageMode.edit)
                  ElevatedButton(
                    onPressed: () => setState(() {
                      mode = PageMode.view;
                    }),
                    style: ElevatedButtonStyles.cancelStyle,
                    child: const Text('Cancel'),
                  ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _onSave(),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 10,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Save'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
