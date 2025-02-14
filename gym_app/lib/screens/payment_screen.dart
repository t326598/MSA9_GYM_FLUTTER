import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tosspayments_widget_sdk_flutter/model/paymentData.dart';
import 'package:tosspayments_widget_sdk_flutter/model/tosspayments_result.dart';
import 'package:tosspayments_widget_sdk_flutter/pages/tosspayments_sdk_flutter.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PaymentData data = Get.arguments as PaymentData;
    return TossPayments(
        clientKey: 'test_ck_PBal2vxj81ND4Yve979e35RQgOAN',
        data: data,
        success: (Success success) async {
          try {
            final response = await http.post(
              Uri.parse('https://api.tosspayments.com/v1/payments/confirm'),
              headers: {
                'Authorization':
                    'Basic ${base64Encode(utf8.encode('test_sk_yZqmkKeP8g9zllKA6A7kVbQRxB9l:'))}', // Secret Key 필요
                'Content-Type': 'application/json',
              },
              body: jsonEncode({
                'paymentKey': success.paymentKey,
                'orderId': success.orderId,
                'amount': success.amount,
              }),
            );

            if (response.statusCode == 200) {
              Get.back(result: '결제 성공');
            } else {
              Get.back(result: '결제 승인 실패: ${response.body}');
            }
          } catch (e) {
            Get.back(result: '결제 승인 중 오류: $e');
          }
        },
        fail: (Fail fail) {
          Get.back(result: fail);
        });
  }
}
