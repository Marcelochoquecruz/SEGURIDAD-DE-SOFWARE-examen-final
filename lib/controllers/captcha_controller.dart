import 'dart:math';
import 'package:get/get.dart';

class CaptchaController extends GetxController {
  final captchaText = ''.obs;
  final userInput = ''.obs;

  @override
  void onInit() {
    super.onInit();
    generateCaptcha();
  }

  void generateCaptcha() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    String result = '';
    
    for (var i = 0; i < 6; i++) {
      result += chars[random.nextInt(chars.length)];
    }
    
    captchaText.value = result;
  }

  bool validateCaptcha() {
    return userInput.value.toUpperCase() == captchaText.value;
  }
}
