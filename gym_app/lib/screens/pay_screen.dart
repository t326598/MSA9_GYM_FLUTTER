// import 'package:flutter/material.dart';
// import 'package:tosspayments_widget_sdk_flutter/model/payment_info.dart';
// import 'package:tosspayments_widget_sdk_flutter/model/payment_widget_options.dart';
// import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';
// import 'package:tosspayments_widget_sdk_flutter/widgets/agreement.dart';
// import 'package:tosspayments_widget_sdk_flutter/widgets/payment_method.dart';

// class PayScreen extends StatefulWidget {
//   const PayScreen({super.key});

//   @override
//   State<PayScreen> createState() {
//     return _PayScreenState();
//   }
// }

// class _PayScreenState extends State<PayScreen> {
//   late PaymentWidget _paymentWidget;
//   PaymentMethodWidgetControl? _paymentMethodWidgetControl;
//   AgreementWidgetControl? _agreementWidgetControl;

//   @override
//   void initState() {
//     super.initState();

//     _paymentWidget = PaymentWidget(
//         clientKey: "test_ck_PBal2vxj81ND4Yve979e35RQgOAN",
//         customerKey: "a1b2c3d4e5f67890");

//     _paymentWidget
//         .renderPaymentMethods(
//             selector: 'methods',
//             amount: Amount(value: 300, currency: Currency.KRW, country: "KR"))
//         .then((control) {
//       _paymentMethodWidgetControl = control;
//     });

//     _paymentWidget.renderAgreement(selector: 'agreement').then((control) {
//       _agreementWidgetControl = control;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SafeArea(
//             child: Column(children: [
//       Expanded(
//           child: ListView(children: [
//         PaymentMethodWidget(
//           paymentWidget: _paymentWidget,
//           selector: 'methods',
//         ),
//         AgreementWidget(paymentWidget: _paymentWidget, selector: 'agreement'),
//         ElevatedButton(
//             onPressed: () async {
//               final paymentResult = await _paymentWidget.requestPayment(
//                   paymentInfo: const PaymentInfo(
//                       orderId: 'OrderId_123', orderName: '파란티셔츠 외 2건'));
//               if (paymentResult.success != null) {
//                 // 결제 성공 처리
//               } else if (paymentResult.fail != null) {
//                 // 결제 실패 처리
//               }
//             },
//             child: const Text('결제하기')),
//         ElevatedButton(
//             onPressed: () async {
//               final selectedPaymentMethod =
//                   await _paymentMethodWidgetControl?.getSelectedPaymentMethod();
//               print(
//                   '${selectedPaymentMethod?.method} ${selectedPaymentMethod?.easyPay?.provider ?? ''}');
//             },
//             child: const Text('선택한 결제수단 출력')),
//         ElevatedButton(
//             onPressed: () async {
//               final agreementStatus =
//                   await _agreementWidgetControl?.getAgreementStatus();
//               print('${agreementStatus?.agreedRequiredTerms}');
//             },
//             child: const Text('약관 동의 상태 출력')),
//         ElevatedButton(
//             onPressed: () async {
//               await _paymentMethodWidgetControl?.updateAmount(amount: 300);
//               print('결제 금액이 300원으로 변경되었습니다.');
//             },
//             child: const Text('결제 금액 변경'))
//       ]))
//     ])));
//   }
// }
