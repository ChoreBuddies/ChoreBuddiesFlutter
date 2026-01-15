import 'dart:convert';
import 'package:chorebuddies_flutter/features/authentication/auth_manager.dart';
import 'package:chorebuddies_flutter/features/authentication/auth_client.dart';
import 'package:chorebuddies_flutter/features/chat/models/chat_message_dto.dart';
import 'package:chorebuddies_flutter/features/chat/models/chat_message_vm.dart';
import 'package:flutter/foundation.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:uuid/uuid.dart';

class ChatService extends ChangeNotifier {
  final AuthClient _authClient;
  final AuthManager _authManager;
  final String _apiEndpoint = '/chat';

  HubConnection? _hubConnection;
  List<ChatMessageVm> _messages = [];
  String? _typingUser;

  // Getters
  List<ChatMessageVm> get messages => _messages;
  String? get typingUser => _typingUser;
  bool get isConnected => _hubConnection?.state == HubConnectionState.connected;

  ChatService({
    required AuthClient authClient,
    required AuthManager authManager
  }) : _authClient = authClient, _authManager = authManager;

  Future<int> loadHistory({DateTime? before}) async {
    try {
      final queryParams = <String, String>{};

      if (before != null) {
        queryParams['before'] = before.toIso8601String();
      }

      final uri = _authClient.uri(_apiEndpoint).replace(queryParameters: queryParams);
      final response = await _authClient.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final dtos = jsonList.map((j) => ChatMessageDto.fromJson(j)).toList();
        final newVms = dtos.map((dto) => ChatMessageVm.fromDto(dto)).toList();

        if (before == null) {
          // Initial load
          _messages = newVms;
        } else {
          // History load
          _messages.insertAll(0, newVms);
        }

        notifyListeners();
        return newVms.length;
      }
    } catch (e) {
      debugPrint('Error loading chat history: $e');
    }
    return 0;
  }

  Future<void> connect(int householdId) async {
    if (isConnected) return;

    String hubUrl = _authClient.baseUrl;

    if (hubUrl.endsWith('/api/v1')) {
      hubUrl = hubUrl.substring(0, hubUrl.length - 7);
    }

    hubUrl = '$hubUrl/chatHub';

    debugPrint('Connecting to SignalR: $hubUrl');

    _hubConnection = HubConnectionBuilder()
        .withUrl(
      hubUrl,
      HttpConnectionOptions(
        accessTokenFactory: () async => _authManager.token,
        logging: (level, message) => debugPrint('SignalR: $message'),
      ),
    )
        .withAutomaticReconnect()
        .build();


    _hubConnection!.on('ReceiveMessage', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final json = arguments[0] as Map<String, dynamic>;
        final dto = ChatMessageDto.fromJson(json);
        _handleIncomingMessage(dto);
      }
    });

    _hubConnection!.on('UserIsTyping', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        _handleTyping(arguments[0] as String);
      }
    });

    await _hubConnection!.start();
    await _hubConnection!.invoke('JoinHouseholdChat', args: [householdId]);
    notifyListeners();
  }

  void _handleIncomingMessage(ChatMessageDto dto) {
    if (dto.isMine) {
      try {
        final localMsg = _messages.firstWhere(
                (m) => m.status == MessageStatus.sending && m.clientUniqueId == dto.clientUniqueId
        );

        localMsg.status = MessageStatus.sent;
        localMsg.id = dto.id;
        localMsg.sentAt = dto.sentAt;

        Future.delayed(const Duration(seconds: 3), () {
          localMsg.status = MessageStatus.none;
          notifyListeners();
        });

      } catch (e) {
        _messages.add(ChatMessageVm.fromDto(dto));
      }
    } else {
      _messages.add(ChatMessageVm.fromDto(dto));
    }
    notifyListeners();
  }

  Future<void> sendMessage(int householdId, String content) async {
    if (!isConnected) return;

    final tempId = const Uuid().v4();

    final localMsg = ChatMessageVm(
      id: 0,
      senderName: "Me",
      content: content,
      sentAt: DateTime.now(),
      isMine: true,
      clientUniqueId: tempId,
      status: MessageStatus.sending,
    );

    _messages.add(localMsg);
    notifyListeners();

    try {
      await _hubConnection!.invoke('SendMessage', args: [householdId, content, tempId]);
    } catch (e) {
      debugPrint('Error sending message: $e');
      _messages.remove(localMsg);
      notifyListeners();
    }
  }

  Future<void> sendTyping(int householdId) async {
    if (!isConnected) return;

    try {
      await _hubConnection!.invoke('SendTyping', args: [householdId]);
    } catch (e) {
      debugPrint('Error sending typing: $e');
    }
  }

  Future<void> disconnect() async {
    if (_hubConnection != null) {
      await _hubConnection!.stop();
      _hubConnection = null;
      notifyListeners();
    }
  }

  void _handleTyping(String userName) {
    _typingUser = userName;
    notifyListeners();
    // Reset po 3 sek
    Future.delayed(const Duration(seconds: 3), () {
      if (_typingUser == userName) {
        _typingUser = null;
        notifyListeners();
      }
    });
  }
}