class ValidatorRule {
  final RegExp pattern;
  final String errorMessage;

  const ValidatorRule(this.pattern, this.errorMessage);
}

enum ValidationType { email, password, invitationCode }

class Validators {
  static final Map<ValidationType, ValidatorRule> rules = {
    ValidationType.email: ValidatorRule(
      RegExp(r'^[\w.\-]+@([\w\-]+\.)+[A-Za-z]{2,}$'),
      'Invalid email address',
    ),
    ValidationType.password: ValidatorRule(
      RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$'),
      'Password must be at least 8 characters long and include an uppercase letter, a lowercase letter, a number, and a special character',
    ),
    ValidationType.invitationCode: ValidatorRule(
      RegExp(r'^[\s\S]{6,}$'),
      'Code must be 6 characters',
    ),
  };

  static String? validate(String value, ValidationType type) {
    final rule = rules[type];
    if (rule == null || rule.pattern.hasMatch(value)) return null;
    return rule.errorMessage;
  }
}
