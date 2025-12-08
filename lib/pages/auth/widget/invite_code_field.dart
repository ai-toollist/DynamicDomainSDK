import 'package:flutter/material.dart';
import 'package:openim_common/openim_common.dart';
import 'app_text_form_field.dart';

class InviteCodeField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool? required;

  final bool isRequired;
  const InviteCodeField({
    super.key,
    required this.controller,
    this.focusNode,
    this.required = false,
    this.isRequired=false
  });

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      label: StrRes.invitationCode,
      isRequired: isRequired,
      validator: (value) {
        final isEmpty = value == null || value.isEmpty;
        final isInvalid = !isEmpty && !IMUtils.isValidInviteCode(value);

        if (required ?? false) {
          if (isEmpty) return StrRes.enterEnterpriseCode;
          if (isInvalid) return StrRes.invalidEnterpriseCode;
        } else if (isInvalid) {
          return StrRes.invalidEnterpriseCode;
        }

        return null;
      },
      controller: controller,
      focusNode: focusNode,
    );
  }
}
