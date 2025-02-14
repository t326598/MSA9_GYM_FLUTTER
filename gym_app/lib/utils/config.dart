import 'package:gym_app/widgets/pay_widget.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_widget_options.dart';
import 'package:tosspayments_widget_sdk_flutter/utils/phase.dart';

class LocalConfig {
  static UIState get uiState {
    switch (PhaseConfig.phase) {
      case Phase.live:
        return _live;
      case Phase.staging:
        return _staging;
      case Phase.dev:
        return _dev;
    }
  }

  static final UIState _live = UIState(
    clientKey: 'test_ck_PBal2vxj81ND4Yve979e35RQgOAN',
    customerKey: 'test_sk_yZqmkKeP8g9zllKA6A7kVbQRxB9l',
    currency: Currency.KRW,
    country: "KR",
    amount: 50000,
    redirectUrl: null,
  );

  static final UIState _staging = UIState(
    clientKey: 'test_ck_PBal2vxj81ND4Yve979e35RQgOAN',
    customerKey: 'test_sk_yZqmkKeP8g9zllKA6A7kVbQRxB9l',
    currency: Currency.KRW,
    country: "KR",
    amount: 50000,
    variantKeyMethod: 'DEFAULT',
    variantKeyAgreement: 'DEFAULT',
    redirectUrl: '',
  );

  static final UIState _dev = UIState(
    clientKey: 'test_ck_PBal2vxj81ND4Yve979e35RQgOAN',
    customerKey: 'test_sk_yZqmkKeP8g9zllKA6A7kVbQRxB9l',
    currency: Currency.KRW,
    country: "KR",
    amount: 50000,
    redirectUrl: null,
  );
}
