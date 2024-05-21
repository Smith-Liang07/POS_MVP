import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/GlobalConfig.dart';
import '../../common/widgets/alert_dialog.dart';
import '../../common/widgets/appbar.dart';
import '../../common/widgets/custom_button.dart';
import '../../common/widgets/numpad.dart';
import '../../constants/color_constant.dart';
import '../../constants/text_style_constant.dart';
import '../../floor_plan/presentation/floor_plan_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../provider/auth_provider.dart';
import '../provider/auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String pin = '';
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        pin = _controller.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (Object? previous, Object? next) {
      if (next is AuthSuccessState) {
        if (POSDtls.TBLManagement) {
          Get.offAll(const FloorPlanScreen());
        } else {
          Get.offAll(HomeScreen());
        }
      } else if (next is AuthErrorState) {
        showDialog(
            context: context,
            builder: (context) {
              return AppAlertDialog(
                title: 'Error',
                message: next.errMsg,
                onConfirm: () {},
              );
            });
      }
    });

    return Scaffold(
      appBar: PreferredSize(
        child: AppBarWidget(false),
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
      ),
      body: Center(
        child: Row(
          children: [
            Expanded(child: leftLogo()),
            Expanded(child: rightLoginForm()),
          ],
        ),
      ),
    );
  }

  Widget leftLogo() {
    return Center(
      child: Image.asset(
        'assets/images/raptor-logo.png',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget rightLoginForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250.w,
          height: 25.h,
          decoration: BoxDecoration(
            color: primaryDarkColor.withOpacity(0.8),
          ),
          child: Center(
            child: Text(
              pin,
              style: titleTextDarkStyle,
            ),
          ),
        ),
        Container(
          width: 250.w,
          height: 130.h,
          color: Colors.transparent,
          child: NumPad(
              buttonWidth: 250.w / 4,
              buttonHeight: 130.h / 4,
              delete: () {},
              onSubmit: () {},
              controller: _controller),
        ),
        SizedBox(
          height: 10.h,
        ),
        CustomButton(
            width: 250.w,
            height: 25.h,
            callback: pinSignIn,
            text: 'Sign In',
            borderColor: primaryDarkColor,
            fillColor: primaryDarkColor),
      ],
    );
  }

  Future<void> pinSignIn() async {
    if (pin.isEmpty) {
      return;
    }
    await ref.read(authProvider.notifier).pinSingIn(pin);
  }
}