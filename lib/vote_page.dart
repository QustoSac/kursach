import 'package:flutter/material.dart';
import 'package:kursach/results_page.dart';
import 'theme/theme.dart'; // Подключение темы, если используется

class VotePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: AppStyles.backgroundGradient, // Градиентный фон
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight, // Задаем минимальную высоту = высота экрана
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: kToolbarHeight + 20), // Отступ для AppBar
                      Center(
                        child: Text(
                          'Название голосования',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Вопрос 1: текстовый ввод
                      _buildQuestionBlock(
                        context,
                        questionNumber: 1,
                        questionText: '1. Вопрос',
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Ответ:',
                            hintStyle: TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.black,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                        ),
                      ),

                      // Вопрос 2: одиночный выбор
                      _buildQuestionBlock(
                        context,
                        questionNumber: 2,
                        questionText: '2. Вопрос',
                        child: Column(
                          children: [
                            _buildRadioOption(context, 'Ответ 1', 1),
                            _buildRadioOption(context, 'Ответ 2', 2),
                            _buildRadioOption(context, 'Ответ 3', 3),
                          ],
                        ),
                      ),

                      // Вопрос 3: множественный выбор
                      _buildQuestionBlock(
                        context,
                        questionNumber: 3,
                        questionText: '3. Вопрос',
                        child: Column(
                          children: [
                            _buildCheckboxOption(context, 'Ответ 1'),
                            _buildCheckboxOption(context, 'Ответ 2'),
                            _buildCheckboxOption(context, 'Ответ 3'),
                          ],
                        ),
                      ),

                      SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Обработка голосования
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => ResultsPage(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0); // Анимация справа налево
                                  const end = Offset.zero;
                                  const curve = Curves.easeOut;

                                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                  var offsetAnimation = animation.drive(tween);

                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                                transitionDuration: Duration(milliseconds: 1000),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text('Проголосовать', style: TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      ),
                      Spacer(), // Занимаем оставшееся пространство
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuestionBlock(BuildContext context,
      {required int questionNumber,
        required String questionText,
        required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            questionText,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        SizedBox(height: 10),
        child,
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildRadioOption(BuildContext context, String label, int value) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: null, // Укажите текущий выбранный value
          onChanged: (val) {
            // Логика обработки выбора
          },
          activeColor: Colors.white,
          fillColor: MaterialStateProperty.all(Colors.white),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildCheckboxOption(BuildContext context, String label) {
    return Row(
      children: [
        Checkbox(
          value: false, // Укажите текущее состояние
          onChanged: (val) {
            // Логика обработки выбора
          },
          activeColor: Colors.white,
          checkColor: Colors.black,
          fillColor: MaterialStateProperty.all(Colors.white),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
