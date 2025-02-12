import 'package:flutter/material.dart';

class FindPwScreen extends StatefulWidget {
  const FindPwScreen({super.key});

  @override
  State<FindPwScreen> createState() => _FindPwScreenState();
}

class _FindPwScreenState extends State<FindPwScreen> {
  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();

    final TextEditingController _idController = TextEditingController();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _birthController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 49, 47, 47),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("내 정보", style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 49, 47, 47)),
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              const Image(image: AssetImage("images/logo.png"), width: 100, height: 100),
              const SizedBox(height: 30),
              TextFormField(
                readOnly: true,
                controller: _idController,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration("아이디", "아이디를 입력해주세요."),
                validator: (value) => value == null || value.isEmpty ? "아이디를 입력하세요." : null,
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration("이름", "이름을 입력해주세요."),
                validator: (value) => value == null || value.isEmpty ? "이름을 입력하세요." : null,
              ),
              const SizedBox(height: 30),
              TextFormField(
                readOnly: true,
                controller: _birthController,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration("생일", ""),
                validator: (value) => value == null || value.isEmpty ? "아이디를 입력하세요." : null,
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration("이메일", "이메일 입력해주세요."),
                validator: (value) => value == null || value.isEmpty ? "이메일를 입력하세요." : null,
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _phoneController,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration("연락처", "연락처를 입력해주세요."),
                validator: (value) => value == null || value.isEmpty ? "아이디를 입력하세요." : null,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 사용자 정보 수정 완료 시 나타나는 스낵바
  SnackBar customSnackbar() {
    return SnackBar(
      content: Row(
        children: const [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Text("회원수정이 완료되었습니다."),
        ],
      ),
      duration: const Duration(seconds: 5),
      backgroundColor: const Color.fromARGB(255, 1, 155, 60),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  SnackBar customSnackbar1() {
    return SnackBar(
      content: Row(
        children: const [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Text("회원 탈퇴 성공!"),
        ],
      ),
      duration: const Duration(seconds: 5),
      backgroundColor: const Color.fromARGB(255, 1, 155, 60),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, String hint) {
    return InputDecoration(
      counterText: "", // 글자 수 제한 표시 안 보이게 설정
      border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      focusedBorder:
          const OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2.5)),
      labelText: label.isNotEmpty ? label : null,
      labelStyle: const TextStyle(color: Colors.white),
      hintText: hint.isNotEmpty ? hint : null,
      hintStyle: const TextStyle(color: Colors.white70),
    );
  }
}
