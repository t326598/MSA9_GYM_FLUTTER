import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/provider/user_provider.dart';
import 'package:gym_app/widgets/custom_drawer.dart';
import 'package:gym_app/widgets/custom_snackbar.dart';

// 로그인 들어갑니다?
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _rememberId = false;

  TextEditingController _idController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final storage = FlutterSecureStorage();
  String? _id;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    _id = await storage.read(key: 'id');
    setState(() {
      if (_id != null) {
        _idController.text = _id.toString();
        _rememberId = true;
      } else {
        _rememberId = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    SnackBar customSnackbar() {
      return SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text("로그인 되었습니다."),
          ],
        ),
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }

    SnackBar customSnackbarfail() {
      return SnackBar(
        content: Row(
          children: const [
            Icon(Icons.cancel, color: Colors.white),
            SizedBox(width: 8),
            Text("아이디 및 비밀번호를 확인해주세요.."),
          ],
        ),
        duration: const Duration(seconds: 5),
        backgroundColor: const Color.fromARGB(255, 167, 9, 9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 49, 47, 47), // 👈 배경색 추가 (진한 회색)
        leading: SizedBox.shrink(),
      ),
      body: Container(
          decoration: BoxDecoration(color: const Color.fromARGB(255, 49, 47, 47)),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image(
                    image: AssetImage('images/logo.png'),
                    height: 100,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  autofocus: true,
                  controller: _idController,
                  validator: (value) {},
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // 기본 테두리 색상
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.5), // 포커스 상태 테두리 색상
                    ),
                    labelText: "아이디",
                    labelStyle: TextStyle(color: Colors.white), // 라벨 텍스트 색상 (하얀색)
                    hintText: "아이디를 입력해주세요.",
                    prefixIcon: Icon(Icons.person_outline, color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white70), // 힌트 텍스트 색상 (연한 하얀색)
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  obscureText: !_isPasswordVisible,
                  controller: _passwordController,
                  validator: (value) {},
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // 기본 테두리 색상
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.5), // 포커스 상태 테두리 색상
                    ),
                    labelText: "비밀번호",
                    labelStyle: TextStyle(color: Colors.white), // 라벨 텍스트 색상 (하얀색)
                    hintText: "비밀번호를 입력해주세요.",
                    hintStyle: TextStyle(color: Colors.white70), // 힌트 텍스트 색상 (연한 하얀색)
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40), // 좌우 패딩 추가
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 끝 정렬
                    children: [
                      // 아이디 저장 (왼쪽 마진 추가)
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberId,
                            onChanged: (bool? value) {
                              setState(() {
                                _rememberId = value!;
                              });
                            },
                          ),
                          GestureDetector(
                            child: const Text(
                              "아이디 저장",
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                _rememberId = !_rememberId;
                              });
                            },
                          ),
                        ],
                      ),
                      // 자동 로그인
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (bool? value) {
                              setState(() {
                                _rememberMe = value!;
                              });
                            },
                          ),
                          GestureDetector(
                            child: const Text(
                              "자동 로그인",
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                _rememberMe = !_rememberMe;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(width: 10), // 왼쪽 여백 추가
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                // 로그인 버튼
                ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      final id = _idController.text;
                      final password = _passwordController.text;

                      await userProvider.login(id, password,
                          rememberId: _rememberId, rememberMe: _rememberMe);
                      if (userProvider.isLogin) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackbar(),
                        );
                        Navigator.pushReplacementNamed(context, "/home");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackbarfail(),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 0, 0), // 배경색
                        foregroundColor: Colors.white, // 폰트색
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0) // 테투리 곡률
                            ),
                        // 버튼의 최소 크기 - 가로, 세로 크기
                        // double.infinity : 디바이스의 최대크기로 지정
                        minimumSize: const Size(double.infinity, 50.0)),
                    child: const Text(
                      "로그인",
                      style: TextStyle(fontSize: 24),
                    )),
                const SizedBox(
                  height: 20,
                ),

                // 소셜 로그인 버튼
                ElevatedButton(
                  onPressed: () {
                    print("버튼 클릭됨!");
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // 이미지 크기와 동일하게 설정
                  ),
                  child: Image.asset(
                    'images/kakao.login.png', // 이미지 파일 경로
                    width: 600, // 버튼 크기 조절
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40), // 좌우 패딩 추가
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 끝 정렬
                    children: [
                      // 아이디 저장 (왼쪽 마진 추가)
                      Row(
                        children: [
                          GestureDetector(
                            child: const Text(
                              "회원가입",
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                Navigator.pushNamed(context, "/join");
                              });
                            },
                          ),
                        ],
                      ),
                      Text(
                        "|",
                        style: TextStyle(color: Colors.white),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            child: const Text(
                              "아이디 찾기",
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                Navigator.pushNamed(context, "/findId");
                              });
                            },
                          ),
                        ],
                      ),
                      Text(
                        "|",
                        style: TextStyle(color: Colors.white),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            child: const Text(
                              "비밀번호 찾기",
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                Navigator.pushNamed(context, "/findPw");
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 110,
                ),
              ],
            ),
          ))),
    );
  }
}
