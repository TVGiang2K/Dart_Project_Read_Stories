import 'package:doan/services/commnet_service.dart';
import 'package:flutter/material.dart';
import 'package:doan/models/ComentDTOInsert.dart';// Đảm bảo import CommentService
import 'dart:convert';

class CommentFormWidget extends StatefulWidget {
  final int accountId; // Thêm tham số accountId
  final int storyId; // Thêm tham số storyId
  final int chapterId; // Thêm tham số chapterId
  final Function(int accountId, int storyId, int chapterId, String content) onSubmit;
  final Function onCommentAdded;

  const CommentFormWidget({
    Key? key,
    required this.accountId,
    required this.storyId,
    required this.chapterId,
    required this.onSubmit,
    required this.onCommentAdded,
  }) : super(key: key);

  @override
  _commentFormWidgetState createState() => _commentFormWidgetState();
}

class _commentFormWidgetState extends State<CommentFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  final CommentService _commentService = CommentService(); // Khởi tạo CommentService

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      ComentDTOInsert newComment = ComentDTOInsert(
        accountId: widget.accountId,
        storyId: widget.storyId,
        chapterId: widget.chapterId,
        content: _commentController.text,
      );

      final response = await _commentService.insertComment(newComment);
      if (response.statusCode == 200) {
        widget.onCommentAdded();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Bình luận đã được thêm thành công!',
              style: TextStyle(color: Colors.green), // Thay đổi màu sắc chữ ở đây
            ),
            backgroundColor: Colors.white, // Có thể thay đổi màu nền của SnackBar nếu bạn muốn
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Không thể thêm bình luận!',
              style: TextStyle(color: Colors.red), // Thay đổi màu sắc chữ ở đây
            ),
            backgroundColor: Colors.white, // Có thể thay đổi màu nền của SnackBar nếu bạn muốn
          ),
        );
      }

      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Viết bình luận',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  hintText: 'Nhập bình luận của bạn...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập bình luận';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Gửi bình luận'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}