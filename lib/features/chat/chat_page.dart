import 'package:chorebuddies_flutter/features/chat/chat_service.dart';
import 'package:chorebuddies_flutter/features/chat/message_bubble.dart';
import 'package:chorebuddies_flutter/features/users/user_service.dart';
import 'package:chorebuddies_flutter/UI/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isInit = false;
  int? _householdId;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      final user = await context.read<UserService>().getMe();
      if (user.householdId != null) {
        setState(() {
          _householdId = user.householdId;
        });

        if (!mounted) return;

        final chatService = context.read<ChatService>();
        // 2. Załaduj historię i połącz się
        await chatService.loadHistory(_householdId!);
        await chatService.connect(_householdId!);
      }
    } catch (e) {
      debugPrint("Error initializing chat: $e");
    } finally {
      if (mounted) setState(() => _isInit = true);
    }
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty || _householdId == null) return;

    context.read<ChatService>().sendMessage(_householdId!, _controller.text.trim());
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    // Opcjonalnie: rozłącz przy wyjściu z ekranu,
    // ale jeśli chcesz powiadomienia w tle/na innych ekranach, zostaw połączenie.
    // context.read<ChatService>().disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInit) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_householdId == null) {
      return const Scaffold(body: Center(child: Text("You are not in a household.")));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Household Chat"),
        backgroundColor: Colors.white,
        elevation: 1,
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // --- LISTA WIADOMOŚCI ---
          Expanded(
            child: Consumer<ChatService>(
              builder: (context, chatService, child) {
                // Odwracamy listę, bo ListView ma reverse: true
                final messages = chatService.messages.reversed.toList();

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true, // Kluczowe dla czatu
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(message: messages[index]);
                  },
                );
              },
            ),
          ),

          // --- TYPING INDICATOR ---
          Consumer<ChatService>(
            builder: (context, chatService, child) {
              if (chatService.typingUser != null) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 4, top: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${chatService.typingUser} is typing...",
                      style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // --- POLE TEKSTOWE ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey.withOpacity(0.2))]),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    onChanged: (text) {
                      // Tu można dodać wysyłanie sygnału "Typing..."
                    },
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}