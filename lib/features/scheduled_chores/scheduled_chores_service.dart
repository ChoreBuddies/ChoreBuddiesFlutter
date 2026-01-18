import 'package:chorebuddies_flutter/features/authentication/auth_client.dart';

class ScheduledChoresService {
  final AuthClient _authClient;
  final String _endpoint = '/scheduledChores/preferences';
  ScheduledChoresService({required AuthClient authClient})
    : _authClient = authClient;
}
