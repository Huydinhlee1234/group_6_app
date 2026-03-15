import 'package:flutter/material.dart';
import '../../../domain/entities/user.dart';

class HealthStaffForm extends StatefulWidget {
  final User? staff;
  final List<String> existingUsernames;
  final Function(Map<String, dynamic> data) onSave;

  const HealthStaffForm({
    super.key,
    this.staff,
    required this.existingUsernames,
    required this.onSave,
  });

  @override
  State<HealthStaffForm> createState() => _HealthStaffFormState();
}

class _HealthStaffFormState extends State<HealthStaffForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
  bool _changePassword = false;

  @override
  void initState() {
    super.initState();
    if (widget.staff != null) {
      _usernameController.text = widget.staff!.username;
      _nameController.text = widget.staff!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.staff == null ? 'Thêm nhân viên mới' : 'Chỉnh sửa nhân viên',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                widget.staff == null ? 'Nhập thông tin nhân viên y tế mới' : 'Cập nhật thông tin nhân viên y tế',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Username Field
              _buildLabel('Tên tài khoản'),
              TextFormField(
                controller: _usernameController,
                enabled: widget.staff == null,
                decoration: _inputDecoration('VD: nvyt01'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Vui lòng nhập tên tài khoản';
                  if (value.length < 3) return 'Tên tài khoản phải có ít nhất 3 ký tự';
                  if (!RegExp(r'^[a-z0-9_]+$').hasMatch(value)) return 'Chỉ chứa chữ thường, số và dấu gạch dưới';
                  if (widget.staff == null && widget.existingUsernames.contains(value)) return 'Tên tài khoản đã tồn tại';
                  return null;
                },
              ),
              if (widget.staff == null)
                const Padding(
                  padding: EdgeInsets.only(top: 4, left: 4),
                  child: Text('Chỉ dùng chữ thường, số và dấu gạch dưới (_)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                ),

              const SizedBox(height: 16),

              // Name Field
              _buildLabel('Họ và tên'),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('VD: Nguyễn Văn A'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Vui lòng nhập họ tên';
                  if (value.trim().length < 2) return 'Họ tên phải có ít nhất 2 ký tự';
                  return null;
                },
              ),

              const SizedBox(height: 8),

              // Password Section
              if (widget.staff != null)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Đổi mật khẩu', style: TextStyle(fontSize: 14)),
                  value: _changePassword,
                  onChanged: (val) => setState(() {
                    _changePassword = val!;
                    if (!_changePassword) _passwordController.clear();
                  }),
                  controlAffinity: ListTileControlAffinity.leading,
                ),

              if (widget.staff == null || _changePassword) ...[
                _buildLabel('Mật khẩu'),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  decoration: _inputDecoration('Nhập mật khẩu (tối thiểu 6 ký tự)').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                      onPressed: () => setState(() => _showPassword = !_showPassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Vui lòng nhập mật khẩu';
                    if (value.length < 6) return 'Mật khẩu phải có ít nhất 6 ký tự';
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: Colors.grey, width: 2),
                      ),
                      child: const Text('Hủy', style: TextStyle(color: Colors.black87)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Colors.blue, Colors.cyan]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          widget.staff == null ? 'Thêm mới' : 'Cập nhật',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'id': widget.staff?.id,
        'username': _usernameController.text.trim(),
        'name': _nameController.text.trim(),
      };
      if (widget.staff == null || _changePassword) {
        data['password'] = _passwordController.text;
      }
      widget.onSave(data);
      Navigator.pop(context);
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
            const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue, width: 2)),
      errorStyle: const TextStyle(fontSize: 11),
    );
  }
}