import 'package:flutter/material.dart';
import 'package:gym_app/service/user_service.dart';

class FindIdScreen extends StatefulWidget {
  const FindIdScreen({super.key});

  @override
  State<FindIdScreen> createState() => _FindIdScreenState();
}

class _FindIdScreenState extends State<FindIdScreen> {
  void _updatePhone() {
    setState(() {
      _phone =
          "${_phoneFirstController.text}${_phoneSecondController.text}${_phoneThirdController.text}";
    });
  }

  final _formkey = GlobalKey<FormState>();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneFirstController = TextEditingController(text: "010");
  final TextEditingController _phoneSecondController = TextEditingController();
  final TextEditingController _phoneThirdController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  String? _selectedQuestion = "강아지 이름은?";
  String? _phone;
  String? foundId = null;

  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 49, 47, 47),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("아이디 찾기", style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 49, 47, 47)),
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              const Image(image: AssetImage("images/logo.png"), width: 100, height: 100),

              const SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration("이름", "이름을 입력해주세요."),
                validator: (value) => value == null || value.isEmpty ? "이름을 입력하세요." : null,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 첫 번째 필드 (010 고정)
                  SizedBox(
                    width: 60,
                    height: 45,
                    child: TextFormField(
                      controller: _phoneFirstController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _buildInputDecoration("", "").copyWith(
                        contentPadding: EdgeInsets.symmetric(vertical: 10), // 👈 내부 여백 조정
                      ),
                      keyboardType: TextInputType.number,
                      readOnly: true,
                      textAlignVertical: TextAlignVertical.center, // 👈 세로 중앙 정렬
                      textAlign: TextAlign.center, // 👈 가로 중앙 정렬 (선택 사항)
                    ),
                  ),

                  // 첫 번째 "-" 추가
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(" - ", style: TextStyle(color: Colors.white, fontSize: 30)),
                  ),

                  // 두 번째 필드 (4자리 입력)
                  SizedBox(
                    width: 90,
                    height: 45,
                    child: TextFormField(
                      controller: _phoneSecondController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _buildInputDecoration("", "").copyWith(
                        contentPadding: EdgeInsets.symmetric(vertical: 10), // 👈 내부 여백 조정
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      validator: (value) {
                        if (value == null || value.length != 4) {
                          return "4자리 입력";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.length == 4) {
                          FocusScope.of(context).nextFocus();
                        }
                        _updatePhone();
                      },
                      textAlignVertical: TextAlignVertical.center, // 👈 세로 중앙 정렬
                      textAlign: TextAlign.center, // 👈 가로 중앙 정렬 (선택 사항)
                    ),
                  ),

                  // 두 번째 "-" 추가
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(" - ", style: TextStyle(color: Colors.white, fontSize: 30)),
                  ),

                  // 세 번째 필드 (4자리 입력)
                  SizedBox(
                    width: 90,
                    height: 45,
                    child: TextFormField(
                      controller: _phoneThirdController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _buildInputDecoration("", "").copyWith(
                        contentPadding: EdgeInsets.symmetric(vertical: 10), // 👈 내부 여백 조정
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      validator: (value) {
                        if (value == null || value.length != 4) {
                          return "4자리 입력";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _updatePhone();
                      },
                      textAlignVertical: TextAlignVertical.center, // 👈 세로 중앙 정렬
                      textAlign: TextAlign.center, // 👈 가로 중앙 정렬 (선택 사항)
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: _buildInputDecoration("질문 확인", "").copyWith(
                  hintText: "질문을 선택해주세요.",
                  hintStyle: const TextStyle(color: Colors.white),
                ),
                dropdownColor: const Color.fromARGB(255, 49, 47, 47),
                value: _selectedQuestion,
                validator: (value) => value == null ? "질문을 선택하세요." : null,
                items: ["강아지 이름은?", "졸업한 초등학교는?", "태어난 지역은?", "보물 1호는?"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedQuestion = newValue;
                  });
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _answerController,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration("답변", "답변을 입력해주세요."),
                validator: (value) => value == null || value.isEmpty ? "답변을 입력하세요." : null,
              ),
              const SizedBox(height: 30),

              // 회원가입 버튼
              ElevatedButton(
                onPressed: () async {
                  if (!_formkey.currentState!.validate()) {
                    return;
                  }
                  String? result = await userService.findid({
                    'name': _nameController.text,
                    'phone': _phone,
                    'question': _selectedQuestion,
                    'answer': _answerController.text,
                  });
                  if (result != "NULL") {
                    setState(() {
                      foundId = result; // 🔥 찾은 아이디 저장
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(customSnackbar1());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  minimumSize: const Size(double.infinity, 50.0),
                ),
                child: const Text("아이디 찾기", style: TextStyle(fontSize: 24)),
              ),
              if (foundId != "NULL" && foundId != null) ...[
                const SizedBox(height: 30),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "찾은 아이디: $foundId",
                        style: TextStyle(
                            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, "/login"); // 🔥 로그인 페이지로 이동
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // 로그인 버튼 색상
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          minimumSize: const Size(double.infinity, 50.0),
                        ),
                        child: const Text("로그인하러 가기", style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 10),
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
          Text("정보가 일치합니다."),
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
          Text("정보가 일치하는 회원을 찾지 못했습니다."),
        ],
      ),
      duration: const Duration(seconds: 5),
      backgroundColor: const Color.fromARGB(255, 134, 5, 5),
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
