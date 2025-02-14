import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gym_app/models/user.dart';
import 'package:gym_app/provider/user_provider.dart';
import 'package:gym_app/screens/payment_screen.dart';
import 'package:gym_app/service/pay_service.dart';
import 'package:gym_app/service/ticketList_service.dart';
import 'package:gym_app/service/user_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tosspayments_widget_sdk_flutter/model/paymentData.dart';

/// [PayScreen] 위젯은 사용자에게 결제 수단 및 주문 관련 정보를 입력받아
/// 결제를 시작하는 화면을 제공합니다.
class PayScreen extends StatefulWidget {
  const PayScreen({super.key});

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  late List<Map<String, dynamic>> selectedTickets = [];

  final _form = GlobalKey<FormState>();
  late String payMethod = '카드'; // 결제수단
  late String orderId; // 주문번호
  late String orderName; // 주문명
  late String amount; // 결제금액
  late String customerName; // 주문자명
  late String customerEmail; // 구매자 이메일

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _fetchUserData(); // ✅ 사용자 데이터 불러오기
    _loadTickets(); // ✅ 이용권 정보 불러오기

    // arguments로 selectedTickets 받기
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is List<Map<String, dynamic>>) {
      selectedTickets = args;
      // selectedTickets에서 결제 금액 계산
      amount = selectedTickets
          .fold(0, (sum, ticket) => sum + ticket['price'] as int)
          .toString();
    } else {
      selectedTickets = [];
    }
  }

  bool isLoading = true;
  Users? _user;
  UserService userService = UserService();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  Future<void> _fetchUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? userId = userProvider.userInfo?.id;
    print('userId : $userId');
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
        print(_user?.email);
      });
      // 🔥 컨트롤러 값 설정
      _nameController.text = _user?.name ?? "";
      _emailController.text = _user?.email ?? "";
      // _phoneController.text = _user?.phone ?? "";
      // _birthController.text = _user?.birth ?? "";
    } catch (e) {
      debugPrint("❌ 사용자 정보를 불러오는 중 오류 발생: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadTickets() async {
    if (_user == null) return; // _user가 null일 경우 처리

    TicketListService ticketListService = TicketListService();
    try {
      // getTicketDate 메서드 호출 시 괄호 추가
      final response = await ticketListService.getTicketDate();
      final buyList = response['buyList']; // 구매 리스트
      final startDate = response['startDate']; // 티켓 시작 날짜
      final oldTicket = response['oldTicket']; // 가장 오래된 티켓

      // 상태 업데이트
      setState(() {
        selectedTickets = buyList; // 구매 리스트 업데이트
        // startDate와 oldTicket도 필요한 경우 상태에 저장할 수 있습니다.
      });
    } catch (e) {
      print('이용권 정보 조회 중 오류 : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('toss payments 결제 테스트'),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: '카드',
                decoration: const InputDecoration(
                  labelText: '결제수단',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: TextStyle(fontSize: 15, color: Color(0xffcfcfcf)),
                ),
                onChanged: (String? newValue) {
                  payMethod = newValue ?? '카드';
                },
                items: ['카드', '가상계좌', '계좌이체', '휴대폰', '상품권']
                    .map<DropdownMenuItem<String>>((String i) {
                  return DropdownMenuItem<String>(
                    value: i,
                    child: Text(i),
                  );
                }).toList(),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '주문번호(orderId)',
                ),
                initialValue:
                    'tosspaymentsFlutter_${DateTime.now().millisecondsSinceEpoch}',
                onSaved: (String? value) {
                  orderId = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '주문명(orderName)',
                ),
                initialValue: selectedTickets[0]['name'],
                onSaved: (String? value) {
                  orderName = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '결제금액(amount)',
                ),
                initialValue: NumberFormat('#,###')
                    .format(int.parse(amount)), // selectedTickets에서 계산한 금액
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSaved: (String? value) {
                  amount = value!;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '구매자명(customerName)',
                ),
                onSaved: (String? value) {
                  customerName = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '이메일(customerEmail)',
                ),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                onSaved: (String? value) {
                  customerEmail = value!;
                },
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async {
                    _form.currentState!.save();
                    PaymentData data = PaymentData(
                      paymentMethod: payMethod,
                      orderId: orderId,
                      orderName: orderName,
                      amount: int.parse(amount),
                      customerName: customerName,
                      customerEmail: customerEmail,
                      successUrl: Constants.success,
                      failUrl: Constants.fail,
                    );
                    var result = await Get.to(
                      () => const PaymentScreen(),
                      fullscreenDialog: true,
                      arguments: data,
                    );
                    print('result : $result');
                    if (result != null) {
                      // 'months' 값을 selectedTickets[0]['months']에서 가져옴
                      int months = selectedTickets[0]['months'];

                      // startDate를 ISO 형식으로 변환
                      final start =
                          DateTime.parse(selectedTickets[0]['start_date']);

                      // endDate를 계산
                      DateTime endDate =
                          DateTime(start.year, start.month + months, start.day);

                      // 구매 내역 저장 로직
                      Map<String, dynamic> buyData = {
                        'ticket_no': selectedTickets[0]['no'],
                        'user_no': _user!.no!,
                        'trainer_no': null, // trainer_no가 null인 경우
                        'buy_date': DateTime.now().toIso8601String(),
                        'start_date':
                            start.toIso8601String(), // start_date는 수정된 값으로 설정
                        'end_date':
                            endDate.toIso8601String(), // 계산된 end_date 사용
                        'status': '정상',
                      };

                      // 결제 내역 저장
                      await PayService().postBuyList(buyData);

                      // 결과 화면으로 이동
                      Get.toNamed("/result", arguments: result);
                    }
                  },
                  child: const Text(
                    '결제하기',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
