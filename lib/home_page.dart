import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_speech_to_text/home_controller.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController speechController = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Text Example'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.timer,
              color: Colors.blue,
            ),
            onPressed: () => _showListenDurationDialog(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // تحسين عرض الدقة
            Obx(() => Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: speechController.confidence.value > 0.8
                          ? Colors.green // لون أخضر للدقة العالية
                          : speechController.confidence.value > 0.5
                              ? Colors.orange // لون برتقالي للدقة المتوسطة
                              : Colors.red, // لون أحمر للدقة المنخفضة
                      size: 30, // حجم الأيقونة
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'الدقة: ${(speechController.confidence.value * 100.0).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                )),
            // تحسين عرض النص
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Obx(() => Text(
                      speechController.text.value,
                      style: const TextStyle(fontSize: 24),
                    )),
              ),
            ),
            // تحسين الأزرار لتغيير اللغة
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(() => ElevatedButton.icon(
                      onPressed: () => speechController.changeLanguage('en'),
                      icon: Icon(
                        Icons.language,
                        color: speechController.selectedLanguage.value == 'en'
                            ? Colors.white
                            : Colors.blue, // تغيير لون الأيقونة
                      ),
                      label: Text(
                        'English',
                        style: TextStyle(
                          color: speechController.selectedLanguage.value == 'en'
                              ? Colors.white
                              : Colors.blue, // تغيير لون النص
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            speechController.selectedLanguage.value == 'en'
                                ? Colors.blue
                                : Colors.white,
                        side: const BorderSide(
                          color: Colors.blue,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )),
                const SizedBox(width: 20),
                Obx(() => ElevatedButton.icon(
                      onPressed: () => speechController.changeLanguage('ar'),
                      icon: Icon(
                        Icons.language,
                        color: speechController.selectedLanguage.value == 'ar'
                            ? Colors.white
                            : Colors.green, // تغيير لون الأيقونة
                      ),
                      label: Text(
                        'العربية',
                        style: TextStyle(
                          color: speechController.selectedLanguage.value == 'ar'
                              ? Colors.white
                              : Colors.green,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            speechController.selectedLanguage.value == 'ar'
                                ? Colors.green
                                : Colors.white,
                        side: const BorderSide(
                          color: Colors.green,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
      // تحسين زر الاستماع العائم
      floatingActionButton: Obx(() => FloatingActionButton(
            onPressed: () => speechController.listen(),
            tooltip: 'Listen',
            backgroundColor:
                speechController.isListening.value ? Colors.red : Colors.blue,
            child: Icon(
              speechController.isListening.value ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
          )),
    );
  }

  // حوار (Dialog) لتغيير مدة الاستماع
  void _showListenDurationDialog() {
    final HomeController controller = Get.find<HomeController>();
    final TextEditingController durationController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('الزمن الحالي ${controller.listenDuration}'),
        content: TextField(
          controller: durationController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'أدخل مدة الاستماع بالثواني',
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // قم بتحديث مدة الاستماع هنا
              final int? newDuration = int.tryParse(durationController.text);
              if (newDuration != null) {
                controller.setListenDuration(newDuration);
              }
              Get.back(); // استخدم Get.back لإغلاق الحوار
            },
            child: const Text('تأكيد'),
          ),
          TextButton(
            onPressed: () => Get.back(), // استخدم Get.back لإغلاق الحوار
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }
}
