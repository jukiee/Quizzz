import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'play.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainAppState();
  }
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 600,
        width: 350,
        child: Column(
          children: [
            Image.asset("assets/images/logo.png", height: 300, width: 300),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlayGame()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text("Bắt đầu"),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                _showGuide();
              },
              style: OutlinedButton.styleFrom(
                primary: Colors.blue,
                side: const BorderSide(color: Colors.blue),
                textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text("Hướng dẫn"),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                _confirmOut();
              },
              style: TextButton.styleFrom(
                primary: Colors.red,
                textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: const BorderSide(color: Colors.red),
                ),
              ),
              child: const Text("Thoát"),
            )
          ],
        ),
      ),
    );
  }
  void _confirmOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Bạn có muốn thoát ứng dụng?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showGuide() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Quiz"),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        "Hướng dẫn sử dụng ứng dụng:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "1. Bắt đầu: Nhấn vào nút 'Bắt đầu' để bắt đầu quá trình trả lời câu hỏi.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "2. Nhập tên: Sau khi nhấn 'Bắt đầu', nhập tên của bạn vào hộp văn bản và nhấn 'Tiếp tục'.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "3. Trả lời câu hỏi: Trả lời 20 câu hỏi bằng cách chọn câu trả lời đúng nhất.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "4. Kết quả: Sau khi trả lời xong 20 câu hỏi, ứng dụng sẽ hiển thị kết quả của bạn.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      SizedBox(height: 10),
                      Text(
                        "Lưu ý:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "- Trong quá trình thực hiện các câu hỏi không được thoát ứng dụng.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
