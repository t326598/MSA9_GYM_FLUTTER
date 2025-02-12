import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart' as picker;
import 'package:gym_app/service/user_service.dart';

class Join extends StatefulWidget {
  const Join({super.key});

  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {
  void _updatePhone() {
    setState(() {
      _phone =
          "${_phoneFirstController.text}${_phoneSecondController.text}${_phoneThirdController.text}";
    });
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _phoneFirstController = TextEditingController(text: "010");
  final TextEditingController _phoneSecondController = TextEditingController();
  final TextEditingController _phoneThirdController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  String _selectedDomain = "@naver.com";
  String _gender = "남자";
  String? _selectedQuestion = "강아지 이름은?";
  String? _id;
  String? _password;
  String? _confirmPassword;
  String? _name;
  String? _email;
  String? _answer;
  String? _phone;

  UserService userService = UserService();

  // 달력 설정
  List<DateTime?> _dateDefaultValue = [DateTime.now()];
  final config = picker.CalendarDatePicker2Config(
    // 캘린더 타입 : single, multi, range
    calendarType: picker.CalendarDatePicker2Type.range,
    // 선택한 날자 색상
    selectedDayHighlightColor: Colors.redAccent,
    // 요일 라벨
    weekdayLabels: ['일', '월', '화', '수', '목', '금', '토'],
    // 요일 스타일
    weekdayLabelTextStyle: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
    // 시작 요일 : 0 (일), 1(월)
    firstDayOfWeek: 0,
    // 컨트롤 높이 사이즈
    controlsHeight: 50,
    // 날짜 스타일
    dayTextStyle: const TextStyle(
      color: Colors.green,
    ),
    // 비활성화된 날짜 스타일
    disabledDayTextStyle: const TextStyle(color: Colors.grey),
    // 선택가능한 날짜 설정
    // DateTime.now() : 현재 날짜 시간          - 2025/01/27
    // difference()   : 두 날짜 객체 간의 차이
    // DateTime.now().subtract(const Duration(days: 1))
    // : 오늘 날짜에서 1일을 뺀 값              - 2025/01/26
    // day.difference( 어제 ) : 선택된 날짜와 어제 날짜 사이의 시간 간격
    // isNegative : 음수인 확인 (특정 날짜와 어제 날짜 사이의 차이 음수면 true)
    selectableDayPredicate: (day) =>
        !day.difference(DateTime.now().subtract(const Duration(days: 1))).isNegative,
  );

  SnackBar customSnackbar() {
    return SnackBar(
      content: Row(
        children: const [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Text("회원가입이 완료되었습니다."),
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
                image: AssetImage("image/logo.png"),
                width: 100,
                height: 100,
              ),
              //아이디
              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50, // 높이를 50으로 고정
                      child: TextFormField(
                        controller: _idController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _buildInputDecoration("아이디", "아이디를 입력해주세요."),
                        validator: (value) => value == null || value.isEmpty ? "아이디를 입력하세요." : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // 간격 추가
                  SizedBox(
                    width: 120,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800], // 버튼 배경 색
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), // 네모 버튼
                      ),
                      onPressed: () async {
                        if (_idController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("아이디를 입력하세요.")),
                          );
                          return;
                        }

                        bool exists = await userService.checkId(_idController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(
                                  !exists ? Icons.cancel : Icons.check_circle,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(!exists ? "이미 사용 중인 아이디입니다." : "사용 가능한 아이디입니다."),
                              ],
                            ),
                            duration: const Duration(seconds: 5),
                            backgroundColor: !exists ? Colors.red : Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      },
                      child:
                          const Text("중복 확인", style: TextStyle(fontSize: 13, color: Colors.white)),
                    ),
                  ),
                ],
              ),
              // 비밀번호
              const SizedBox(height: 30),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration("비밀번호", "비밀번호를 입력해주세요."),
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
              // 이름
              const SizedBox(height: 30),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration("이름", "이름을 입력해주세요."),
                validator: (value) => value == null || value.isEmpty ? "이름을 입력하세요." : null,
              ),
              const SizedBox(height: 30),

              // 성별 선택
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text("성별", style: TextStyle(color: Colors.white)),
                  Radio<String>(
                    value: "남자",
                    groupValue: _gender,
                    onChanged: (value) => setState(() => _gender = value!),
                    activeColor: Colors.white,
                  ),
                  const Text("남자", style: TextStyle(color: Colors.white)),
                  Radio<String>(
                    value: "여자",
                    groupValue: _gender,
                    onChanged: (value) => setState(() => _gender = value!),
                    activeColor: Colors.white,
                  ),
                  const Text("여자", style: TextStyle(color: Colors.white)),
                ],
              ),

              Column(
                children: [
                  TextFormField(
                    controller: _birthController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "생년월일",
                      labelStyle: TextStyle(color: Colors.white),
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          print("생년월일 달력 아이콘 클릭...");

                          final result = await showDialog<List<DateTime>>(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: picker.CalendarDatePicker2(
                                  config: picker.CalendarDatePicker2Config(
                                    calendarType: picker.CalendarDatePicker2Type.single,
                                    selectedDayHighlightColor: Colors.red,
                                    weekdayLabels: ['월', '화', '수', '목', '금', '토', '일'],
                                  ),
                                  value: [],
                                  onValueChanged: (dates) {
                                    print(dates[0]);
                                    if (dates.isNotEmpty) {
                                      Navigator.pop(context, dates);
                                    }
                                  },
                                ),
                              );
                            },
                          );

                          if (result != null && result.isNotEmpty) {
                            final selectedDate = result[0];
                            final formatDate = "${selectedDate.year}/"
                                "${selectedDate.month.toString().padLeft(2, '0')}/"
                                "${selectedDate.day.toString().padLeft(2, '0')}";
                            _birthController.text = formatDate;
                          }
                        },
                        child: Icon(Icons.calendar_month, color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              // 이메일
              Row(
                children: [
                  // 이메일 아이디 입력 필드
                  SizedBox(
                    width: 170, // 👈 너비 조정
                    height: 50, // 👈 높이 조정
                    child: TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _buildInputDecoration("이메일", "이메일 아이디 입력"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "이메일을 입력하세요.";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _email = "$value$_selectedDomain"; // 이메일 아이디 + 선택한 도메인 결합
                        });
                      },
                    ),
                  ),

                  const SizedBox(width: 10), // 간격 추가

                  // 이메일 도메인 선택 드롭다운
                  SizedBox(
                    width: 150, // 👈 너비 조정
                    height: 50, // 👈 높이 조정
                    child: DropdownButtonFormField<String>(
                      value: _selectedDomain,
                      decoration: _buildInputDecoration("", ""),
                      dropdownColor: const Color.fromARGB(255, 49, 47, 47),
                      style: const TextStyle(color: Colors.white),
                      items: [
                        "@naver.com",
                        "@gmail.com",
                        "@daum.net",
                        "@yahoo.com",
                        "@outlook.com",
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedDomain = newValue!;
                          _email = "${_emailController.text}$_selectedDomain"; // 이메일 업데이트
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

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
                  bool exists = await userService.checkId(_idController.text!);
                  if (!exists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text("이미 사용중인 아이디입니다."),
                          ],
                        ),
                        duration: const Duration(seconds: 5),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                    return;
                  }

                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  bool result = await userService.registerUser({
                    'id': _idController.text,
                    'name': _nameController.text,
                    'password': _passwordController.text,
                    'email': _email,
                    'gender': _gender,
                    'phone': _phone,
                    'question': _selectedQuestion,
                    'answer': _answerController.text,
                    'birth': _birthController.text
                  });
                  if (result) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(customSnackbar());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  minimumSize: const Size(double.infinity, 50.0),
                ),
                child: const Text("회원가입", style: TextStyle(fontSize: 24)),
              ),
            ],
          ),
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
