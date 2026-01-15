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
  bool _isLoadingMore = false;
  int? _householdId;
  DateTime? _lastTypingTime;

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _scrollController.addListener(_onScroll);
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

        await chatService.loadHistory();
        await chatService.connect(_householdId!);
      }
    } catch (e) {
      debugPrint("Error initializing chat: $e");
    } finally {
      if (mounted) setState(() => _isInit = true);
    }
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;

      // If 100px from top and not loading more now
      if (currentScroll >= (maxScroll - 100) && !_isLoadingMore) {
        _loadMoreMessages();
      }
    }
  }

  Future<void> _loadMoreMessages() async {
    final chatService = context.read<ChatService>();
    if (chatService.messages.isEmpty) return;

    setState(() => _isLoadingMore = true);

    final oldestMessageDate = chatService.messages.first.sentAt;

    await chatService.loadHistory(before: oldestMessageDate);

    if (mounted) {
      setState(() => _isLoadingMore = false);
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
                final messages = chatService.messages.reversed.toList();

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length + (_isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= messages.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

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
                      if (_householdId != null && text.trim().isNotEmpty) {
                        final now = DateTime.now();

                        if (_lastTypingTime == null ||
                            now.difference(_lastTypingTime!) > const Duration(seconds: 2)) {

                          _lastTypingTime = now;
                          context.read<ChatService>().sendTyping(_householdId!);
                        }
                      }
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