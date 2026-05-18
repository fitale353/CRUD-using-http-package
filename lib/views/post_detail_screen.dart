import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/post_model.dart';
import '../providers/post_provider.dart';

class PostDetailScreen extends StatefulWidget {
  final Post? post; // If null, the screen runs in "Create" mode.

  const PostDetailScreen({super.key, this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post?.title ?? '');
    _bodyController = TextEditingController(text: widget.post?.body ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<PostProvider>();
    bool success;

    if (widget.post == null) {
      // Create Mode
      success = await provider.addPost(_titleController.text, _bodyController.text);
    } else {
      // Update Mode
      success = await provider.editPost(widget.post!.id!, _titleController.text, _bodyController.text);
    }

    if (context.mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.post == null ? 'Post created successfully!' : 'Post updated successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<PostProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post == null ? 'Create New Post' : 'Edit Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        key: ValueKey(widget.post?.id),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bodyController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Body Content', border: OutlineInputBorder()),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter body context' : null,
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                      onPressed: _saveForm,
                      child: Text(widget.post == null ? 'Submit Post' : 'Update Post'),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
