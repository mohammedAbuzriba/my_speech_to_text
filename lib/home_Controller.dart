import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeController extends GetxController {
  late stt.SpeechToText _speech;
  var isListening = false.obs;
  var text = "اضغط على الميكروفون لبدء التحدث".obs;
  var confidence = 1.0.obs;
  RxString selectedLanguage = 'ar'.obs;
  RxInt listenDuration = 5.obs; // مدة الاستماع الافتراضية بالثواني

  @override
  void onInit() {
    super.onInit();
    _speech = stt.SpeechToText();
  }

  void listen() async {
    if (!isListening.value) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          print('onStatus: $val');
          // تحقق من حالة الاستماع لتغيير حالة الزر
          if (val == 'notListening') {
            isListening.value = false; // تحديث حالة الزر إلى "غير مستمع"
          }
        },
        onError: (val) {
          print('onError: $val');
          isListening.value =
              false; // تحديث حالة الزر إلى "غير مستمع" عند حدوث خطأ
        },
      );
      if (available) {
        isListening.value = true;
        _speech.listen(
          onResult: (val) {
            text.value = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              confidence.value = val.confidence;
            }
          },
          localeId: selectedLanguage.value, // تحديد اللغة
          listenFor: Duration(seconds: listenDuration.value), // مدة الاستماع
        );
      } else {
        isListening.value = false;
        _speech.stop();
      }
    } else {
      isListening.value = false;
      _speech.stop();
    }
  }

  // تغيير المدة حسب المستخدم
  void setListenDuration(int duration) {
    listenDuration.value = duration;
  }

  void changeLanguage(String languageCode) {
    selectedLanguage.value = languageCode;
  }
}
