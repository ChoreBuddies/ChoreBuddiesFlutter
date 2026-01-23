import 'package:chorebuddies_flutter/UI/styles/button_styles.dart';
import 'package:chorebuddies_flutter/UI/widgets/g_form_field.dart';
import 'package:chorebuddies_flutter/features/predefined_rewards/models/predefined_reward_dto.dart';
import 'package:chorebuddies_flutter/features/predefined_rewards/predefined_reward_dialog.dart';
import 'package:chorebuddies_flutter/features/rewards/create_edit_page/create_edit_reward_page.dart';
import 'package:chorebuddies_flutter/features/rewards/models/reward_dto.dart';
import 'package:chorebuddies_flutter/utils/validators.dart';
import 'package:flutter/material.dart';

class CreateEditRewardForm extends StatefulWidget {
  final Reward model;
  final PageMode pageMode;
  final ValueChanged<Reward>? onValidSubmit;
  final ValueChanged<PageMode>? onPageModeChanged;
  final bool showCancel;

  const CreateEditRewardForm({
    super.key,
    required this.model,
    required this.pageMode,
    this.onValidSubmit,
    this.onPageModeChanged,
    this.showCancel = true,
  });

  @override
  State<CreateEditRewardForm> createState() => _CreateEditRewardFormState();
}

class _CreateEditRewardFormState extends State<CreateEditRewardForm> {
  bool _isLoading = false;

  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController costController;
  late final TextEditingController quantityController;

  late PageMode mode;

  final _formKey = GlobalKey<FormState>();
  void _onSave() {
    _isLoading = true;
    if (_formKey.currentState?.validate() ?? false) {
      final model = widget.model;
      model.name = nameController.text;
      model.description = descriptionController.text;
      model.cost = int.tryParse(costController.text) ?? 0;
      model.quantityAvailable = int.tryParse(quantityController.text) ?? 0;

      widget.onValidSubmit?.call(model);
    }
    _isLoading = false;
    if (mode == PageMode.create) return;
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
    costController = TextEditingController(text: model.cost.toString());
    quantityController = TextEditingController(
      text: model.quantityAvailable.toString(),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  bool get _readOnly => mode == PageMode.view;

  Future<void> _pickFromTemplate() async {
    final PredefinedRewardDto? template = await showDialog<PredefinedRewardDto>(
      context: context,
      builder: (context) => const PredefinedRewardSelectorDialog(),
    );

    if (template != null) {
      setState(() {
        nameController.text = template.name;
        descriptionController.text = template.description;
        costController.text = template.cost.toString();
        quantityController.text = template.quantityAvailable.toString();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Data loaded from template. You can now edit it."),
            backgroundColor: Colors.blue,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (mode == PageMode.create) ...[
            OutlinedButton.icon(
              onPressed: _pickFromTemplate,
              icon: const Icon(Icons.copy),
              label: const Text("Select from predefined"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(12),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            const SizedBox(height: 20),
          ],
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

          GFormField(
            labelText: 'Cost',
            controller: costController,
            keyboardType: TextInputType.number,
            readonly: mode == PageMode.view,
            validator: (value) {
              if (_readOnly) return null;
              if (value == null || value.isEmpty) return 'Required';
              return Validators.validate(
                value,
                ValidationType.nonNegativeInteger,
              );
            },
          ),

          GFormField(
            labelText: 'Quantity Available',
            controller: quantityController,
            keyboardType: TextInputType.number,
            readonly: mode == PageMode.view,
            validator: (value) {
              if (_readOnly) return null;
              if (value == null || value.isEmpty) return 'Required';
              return Validators.validate(
                value,
                ValidationType.nonNegativeInteger,
              );
            },
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
