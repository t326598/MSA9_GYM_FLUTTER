import 'package:flutter/material.dart';
import 'package:gym_app/service/user_service.dart';

class Changepw extends StatefulWidget {
  const Changepw({super.key});

  @override
  State<Changepw> createState() => _ChangepwState();
}

//
class _ChangepwState extends State<Changepw> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  UserService userService = UserService();

  SnackBar customSnackbar() {
    return SnackBar(
      content: Row(
        children: const [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Text("비밀번호 변경이 완료되었습니다."),
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
          Text("비밀번호 변경 실패 잠시후 다시 시도해주세요."),
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

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    String? userId = args?['id'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 49, 47, 47),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("회원가입", style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 49, 47, 47)),
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey, // 유효성 검사 추가
          child: ListView(
            children: [
              const Image(
                image: AssetImage("images/logo.png"),
                width: 100,
                height: 100,
              ),
              //아이디
              const SizedBox(height: 30),

              // 비밀번호
              const SizedBox(height: 30),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration("변경 비밀번호", "비밀번호를 입력해주세요."),
                validator: (value) =>
                    (value == null || value.length < 6) ? "비밀번호는 6자 이상 입력해야 합니다." : null,
              ),

              const SizedBox(height: 30),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration("비밀번호 확인", "비밀번호를 다시 입력해주세요."),
                validator: (value) =>
                    (value != _passwordController.text) ? "비밀번호가 일치하지 않습니다." : null,
              ),
              // 이름              const SizedBox(height: 30),
              const SizedBox(height: 50),
              // 회원가입 버튼
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  bool result = await userService
                      .changePw({'id': userId, 'password': _passwordController.text});
                  if (result) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(customSnackbar());
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(customSnackbar1());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  minimumSize: const Size(double.infinity, 50.0),
                ),
                child: const Text("비밀번호 변경", style: TextStyle(fontSize: 24)),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
