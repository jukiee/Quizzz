import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'main.dart';
import 'review.dart';
import 'play.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _GameScreenState();
  }
}

class _GameScreenState extends State<GameScreen> {
  bool _isLoading = true;
  bool _answerChosen = false;
  int correctQuestion = 0;
  int wrongQuestion = 0;
  int _countdown = 10;
  bool _showQuestion = true;
  String _selectedAnswer = "";
  double _progressValue = 1.0;
  Timer? _countdownTimer;
  List<Map<String, dynamic>> _quizData = [];
  final List<Map<String, dynamic>> _history = [];
  int indexQuiz = 0;
  int isNotAnswer = 20;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _loadQuizData();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadQuizData() async {
    final random = Random();
    final String jsonStr = await rootBundle.loadString('assets/data.json');
    final jsonData = json.decode(jsonStr);
    final List<dynamic> quizDataList = jsonData as List<dynamic>;
    _quizData = quizDataList.map((item) => item as Map<String, dynamic>).toList();
    _quizData.shuffle(random);

    for (var question in _quizData) {
      question['answers'].shuffle(random);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _startCountdown() {
    const oneSec = Duration(seconds: 1);
    _countdownTimer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
          _progressValue = _countdown / 10.0;
        } else {
          timer.cancel();
          isNotAnswer--;
          _nextQuestion(false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double score = (correctQuestion / _quizData.length) * 10.0;
    if(_isLoading) {
      return const CircularProgressIndicator();
    } else {
      if(!_showQuestion) {
        _countdownTimer?.cancel();
        return ResultScreen(
          correctQuestion: correctQuestion,
          wrongQuestion: wrongQuestion,
          totalQuestions: _quizData.length,
          score: score,
          history: _history,
          quizData: _quizData,
          isNotAnswer: isNotAnswer
        );
      }
      String question = _quizData[indexQuiz]["question"];
      return Container(
        padding: const EdgeInsets.all(20.0),
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          runSpacing: 32,
          children: [
            AnimatedOpacity(
              opacity: _showQuestion ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 1000),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 18,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    width: 400,
                    height: 220,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.translate(
                          offset: const Offset(0, -60),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const SizedBox(
                                  height: 85,
                                  width: 85,
                                  child: CircleAvatar(
                                      backgroundColor: Colors.white
                                  )
                              ),
                              SizedBox(
                                height: 70,
                                width: 70,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.grey,
                                  value: _progressValue,
                                  color: Colors.blue,
                                  strokeWidth: 6,
                                ),
                              ),
                              Text(
                                "$_countdown",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -50),
                          child: Text(
                            "Câu ${indexQuiz + 1}/${_quizData.length}",
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -40),
                          child: SingleChildScrollView(
                            child: Text(
                              question,
                              maxLines: 5,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    )
                ),
              ),
            ),
            const SizedBox(height: 30),
            _showQuestion ?
            SingleChildScrollView(
                child: Column(
                  children: [
                    for (var i = 0; i < 4; i++)
                      Column(
                        children: [
                          _answerButton(
                            _quizData[indexQuiz]["answers"][i]["answer"],
                            _quizData[indexQuiz]["answers"][i]["isCorrect"],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                  ],
                ),
              )
                :
              ResultScreen(
                  correctQuestion: correctQuestion,
                  wrongQuestion: wrongQuestion,
                  totalQuestions: _quizData.length,
                  score: score,
                  history: _history,
                  quizData: _quizData,
                  isNotAnswer: isNotAnswer
              ),
              const SizedBox(height: 30)
          ],
        ),
      );
    }
  }

  Future<void> _nextQuestion(bool isCorrect) async {
    setState(() {
      _answerChosen = true;
    });
    if (indexQuiz > _quizData.length) {
      _countdownTimer?.cancel();
    }
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _answerChosen = false;
      if (isCorrect) {
        correctQuestion++;
      } else {
        wrongQuestion++;
      }
      indexQuiz++;
      _history.add({
        'question': _quizData[indexQuiz - 1]["question"],
        'selectedAnswer': _selectedAnswer,
        'isCorrect': isCorrect,
      });
      if (indexQuiz + 1 > _quizData.length) {
        _showQuestion = false;
      } else {
        _selectedAnswer = "";
        _countdownTimer?.cancel();
        _progressValue = 1.0;
        _countdown = 10;
        _startCountdown();
      }
    });
  }

  Widget _answerButton(String text, bool correct) {
    return OutlinedButton(
      onPressed: _answerChosen ? null : () {
        if (_selectedAnswer == text) {
          setState(() {
            _selectedAnswer = "";
          });
        } else {
          setState(() {
            _selectedAnswer = text;
          });
          if (correct) {
            _nextQuestion(true);
          } else {
            _nextQuestion(false);
          }
        }
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        side: const BorderSide(color: Colors.purple, width: 3.0),
        padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 18),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _selectedAnswer == text
              ? Icon(
            correct ? Icons.check_circle : Icons.cancel_rounded,
            color: correct ? Colors.green : Colors.red,
          )
              : const Icon(Icons.radio_button_unchecked),
        ],
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int correctQuestion;
  final int wrongQuestion;
  final int totalQuestions;
  final int isNotAnswer;
  final double score;
  final List<Map<String, dynamic>> history;
  final List<Map<String, dynamic>> quizData;

  const ResultScreen({
    Key? key,
    required this.correctQuestion,
    required this.wrongQuestion,
    required this.totalQuestions,
    required this.score,
    required this.history,
    required this.quizData,
    required this.isNotAnswer
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int percentageAnswer = (isNotAnswer / totalQuestions * 100).toInt();
    return Container(
      padding: const EdgeInsets.all(20.0),
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
                score.toStringAsFixed(1),
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.purple),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                width: 400,
                height: 180,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.blue, size: 28),
                              const SizedBox(width: 8),
                              Text(
                                  "$percentageAnswer %",
                                  style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                                "Hoàn thành",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey
                                )
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.check, color: Colors.green, size: 28),
                              const SizedBox(width: 8),
                              Text(
                                  "$correctQuestion",
                                  style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                                "Câu đúng",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.list_alt, color: Colors.blue, size: 28),
                              const SizedBox(width: 8),
                              Text(
                                  totalQuestions.toString(),
                                  style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                                "Tổng",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey
                                )
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.close, color: Colors.red, size: 28),
                              const SizedBox(width: 8),
                              Text(
                                  "$wrongQuestion",
                                  style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                                "Câu sai",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey
                                )
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20.0,
            runSpacing: 20.0,
            children: [
              _iconButton(Icons.replay_circle_filled_sharp, "Làm lại", () =>
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) =>
                    const PlayGame()),
                        (route) => false,
                  )
              ),
              _iconButton(Icons.home, "Trang chủ", () =>
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) =>
                      const MainAppWrapper()),
                        (route) => false,
                  )
              ),
              _iconButton(Icons.remove_red_eye_outlined, "Xem lại", () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        ReviewQuestionScreen(history, quizData)),
                  )
              ),
            ],
          ),
          const SizedBox(height: 50)
        ],
      ),
    );
  }
  Widget _iconButton(IconData iconData, String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.2),
              radius: 25,
              child: Icon(
                iconData,
                size: 30,
                color: Colors.blue,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                label,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}