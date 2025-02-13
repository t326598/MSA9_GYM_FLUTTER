import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart' as picker;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gym_app/models/user.dart';
import 'package:gym_app/provider/user_provider.dart';
import 'package:gym_app/screens/home_screen.dart';
import 'package:gym_app/service/user_service.dart';
import 'package:gym_app/widgets/snackbar.dart';
import 'package:provider/provider.dart';

class MyPageInfo extends StatefulWidget {
  const MyPageInfo({super.key});

  @override
  State<MyPageInfo> createState() => _MyPageInfoState();
}

class _MyPageInfoState extends State<MyPageInfo> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();

  Users? _user;
  UserService userService = UserService();
  bool updateUser = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // ✅ 사용자 데이터 불러오기
  }

  /// 🔥 사용자 정보를 가져와 `_user`와 컨트롤러에 값 설정
  Future<void> _fetchUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? userId = userProvider.userInfo?.id;
    print(userId);
    if (userId == null || userId.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final userData = await userService.getUser(userId); // 🔥 서버에서 데이터 가져오기
      setState(() {
        _user = Users.fromJson(userData); // ✅ JSON 데이터를 Users 객체로 변환
        isLoading = false; // 🔥 데이터 로딩 완료
      });

      // 🔥 컨트롤러 값 설정
      _idController.text = _user?.id ?? "";
      _nameController.text = _user?.name ?? "";
      _emailController.text = _user?.email ?? "";
      _phoneController.text = _user?.phone ?? "";
      _birthController.text = _user?.birth ?? "";
    } catch (e) {
      debugPrint("❌ 사용자 정보를 불러오는 중 오류 발생: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: true);
    print(userProvider.isLogin);
    if (!userProvider.isLogin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // canPop 남아있는 스택이 있는지 확인
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        Navigator.pushNamed(context, "/login");
      });
      return const HomeContent();
    }

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(), // 🔄 데이터 로딩 중 표시
      );
    }

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
              ),
              const SizedBox(height: 30),
              _buildEditableTextField(label: "이름", controller: _nameController),
              const SizedBox(height: 30),
              const SizedBox(height: 30),
              TextFormField(
                readOnly: true,
                controller: _birthController,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration("생일", ""),
                validator: (value) => value == null || value.isEmpty ? "아이디를 입력하세요." : null,
              ),
              const SizedBox(height: 30),
              _buildEditableTextField(label: "이메일", controller: _emailController),
              const SizedBox(height: 30),

              _buildEditableTextField(label: "연락처", controller: _phoneController),
              const SizedBox(height: 30),

              /// 🔥 회원 수정 버튼
              ElevatedButton(
                onPressed: () async {
                  if (!updateUser) {
                    bool result = await userService.updateUser({
                      'name': _nameController.text,
                      'email': _emailController.text,
                      'phone': _phoneController.text,
                      'no': _user?.no
                    });

                    if (result) {
                      setState(() {
                        updateUser = true;
                        _user = Users(
                          no: _user?.no,
                          id: _user?.id,
                          name: _nameController.text,
                          phone: _phoneController.text,
                          email: _emailController.text,
                          birth: _birthController.text,
                          enabled: _user?.enabled,
                          trainerNo: _user?.trainerNo,
                          authList: _user?.authList,
                        );
                      });
                      ScaffoldMessenger.of(context).showSnackBar(customSnackbar());
                    }
                  } else {
                    setState(() {
                      updateUser = false;
                    });
                  }
                },
                child:
                    Text(updateUser ? "회원 수정" : "회원 수정 완료", style: const TextStyle(fontSize: 24)),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (updateUser) {
                    _showDeleteDialog(context);
                  } else {
                    setState(() {
                      updateUser = true;
                      _user = Users(
                        no: _user?.no,
                        id: _user?.id,
                        name: _nameController.text,
                        phone: _phoneController.text,
                        email: _emailController.text,
                        birth: _birthController.text,
                        enabled: _user?.enabled,
                        trainerNo: _user?.trainerNo,
                        authList: _user?.authList,
                      );
                    });
                  }
                },
                child: Text(updateUser ? "회원 탈퇴" : "취소", style: TextStyle(fontSize: 24)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final storage = const FlutterSecureStorage();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("회원 탈퇴"),
          content: const Text("정말로 탈퇴하시겠습니까?"),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("취소")),
            TextButton(
                onPressed: () async {
                  bool result = await userService.deleteUser(_user?.no);
                  if (result) {
                    Navigator.pop(context);
                    Provider.of<UserProvider>(context, listen: false).logout();
                    Navigator.pushReplacementNamed(context, '/home');
                    await storage.delete(key: 'id');
                  }
                  ScaffoldMessenger.of(context).showSnackBar(customSnackbar1());
                },
                child: const Text("확인"))
          ],
        );
      },
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

  Widget _buildEditableTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: updateUser ? Colors.transparent : Colors.white, // 🔥 처음에는 투명, 수정 가능할 때 하얀색
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: TextFormField(
        readOnly: updateUser,
        controller: controller,
        style: TextStyle(color: updateUser ? Colors.white : Colors.black),
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
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
