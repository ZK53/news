import 'package:flutter/material.dart';
import 'search_results_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(String value) {
    final q = value.trim();
    if (q.isEmpty) return;
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => SearchResultsScreen(query: q)));
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: c));

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
          child: Row(children: [
            Expanded(
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _controller,
                builder: (_, value, __) => TextField(
                  controller: _controller,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onSubmitted: _submit,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xFFEDEDED),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    prefixIcon: const Icon(Icons.search,
                        size: 18, color: Color(0xFF8A8A8E)),
                    suffixIcon: value.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.cancel,
                                size: 18, color: Color(0xFFB0B0B5)),
                            onPressed: _controller.clear),
                    enabledBorder: border(Colors.transparent),
                    focusedBorder: border(const Color(0xFF5B7CFA)),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
                  style: TextStyle(fontSize: 14, color: Color(0xFF1F2BFF))),
            ),
          ]),
        ),
      ),
    );
  }
}
