import 'package:flutter/material.dart';

class CreateUI extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  final List<Map<String, dynamic>> quizData;

  const CreateUI(this.history, this.quizData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int score = 0;
    for (final answer in history) {
      if (answer['isCorrect'] == true) {
        score++;
      }
    }
    int totalQuestions = quizData.length;
    double percentageScore = (score / totalQuestions) * 10;
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox(
                  height: 220,
                  width: 220,
                  child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.purple
                  )
              ),
              const SizedBox(
                  height: 200,
                  width: 200,
                  child: CircleAvatar(
                      backgroundColor: Colors.pink
                  )
              ),
              const SizedBox(
                  height: 180,
                  width: 180,
                  child: CircleAvatar(
                      backgroundColor: Colors.purple
                  )
              ),
              const SizedBox(
                  height: 160,
                  width: 160,
                  child: CircleAvatar(
                      backgroundColor: Colors.grey
                  )
              ),
              const SizedBox(
                  height: 140,
                  width: 140,
                  child: CircleAvatar(
                      backgroundColor: Colors.white
                  )
              ),
              Text(
                percentageScore.toStringAsFixed(1),
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.purple),
              ),
            ],
          ),
          const SizedBox(height: 60),
          Expanded(
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final question = history[index]['question'];
                var selectedAnswer = history[index]['selectedAnswer'];
                final isCorrect = history[index]['isCorrect'];
                final correctAnswer = quizData[index]['answers']
                    .firstWhere((answer) => answer['isCorrect'] == true)['answer'];
                if(selectedAnswer.length == 0) {
                  selectedAnswer = "KHÔNG TRẢ LỜI";
                }
                return Card(
                  elevation: 4,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Câu hỏi:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          question,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Đáp án của bạn: $selectedAnswer",
                          style: TextStyle(
                            fontSize: 16,
                            color: isCorrect ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 10),
                        !isCorrect ? Text(
                          "Câu trả lời đúng: "
                              "$correctAnswer",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ) : const SizedBox(),
                        const SizedBox(height: 10),
                        Icon(
                          isCorrect ? Icons.check : Icons.clear,
                          color: isCorrect ? Colors.green : Colors.red,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class ReviewQuestionScreen extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  final List<Map<String, dynamic>> quizData;
  const ReviewQuestionScreen(this.history, this.quizData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background2.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: CreateUI(history, quizData),
            ),
          ),
        ],
      ),
    );
  }
}