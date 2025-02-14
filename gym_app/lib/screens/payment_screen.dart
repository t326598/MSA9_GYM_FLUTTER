import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      success: (Success success) {
        // 결제 성공 시 결과를 반환하고 이전 화면으로 돌아갑니다.
        Get.back(result: success);
      },
      fail: (Fail fail) {
        // 결제 실패 시 결과를 반환하고 이전 화면으로 돌아갑니다.
        Get.back(result: fail);
      },
    );
  }
}
