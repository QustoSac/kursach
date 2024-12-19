
import 'package:flutter/material.dart';
import 'main_page.dart';
import 'theme/theme.dart';
import 'results_page.dart';

class ViewResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppStyles.backgroundGradient,
        child: SafeArea(child: Padding(padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ResultsPage(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(-1.0, 0.0); // Анимация справа налево
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
                    ),
                  ],
                ),
                SizedBox(height: 40),
                _buildTitle('Название голосования'),
                SizedBox(height: 20),
                _buildQuestionBlock('Вопрос', [
                  _buildResultRow('Вариант 1', 70),
                  _buildResultRow('Вариант 2', 30),
                  _buildResultRow('Вариант 3', 50),
                ]),
                SizedBox(height: 20),
                _buildQuestionBlock('Вопрос', [
                  _buildResultRow('Вариант 1', 80),
                  _buildResultRow('Вариант 2', 20),
                  _buildResultRow('Вариант 3', 60),
                ]),
                SizedBox(height: 40),

                Padding(
                  padding: const EdgeInsets.only(left: 20,bottom: 20),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: FloatingActionButton(
                      backgroundColor: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => MainPage(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(-1.0, 0.0); // Анимация справа налево
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
                      child: Icon(Icons.home, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ),
      ),

    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: AppStyles.titleTextStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildQuestionBlock(String question, List<Widget> results) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                question,
                style: AppStyles.buttonTextStyle,
              ),
            ),
          ),
          SizedBox(height: 10),
          ...results,
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, int percentage) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppStyles.listTileTextStyle),
            Text('$percentage%', style: AppStyles.listTileTextStyle),
          ],
        ),
        Slider(
          value: percentage.toDouble(),
          max: 100,
          min: 0,
          onChanged: null, // Неактивный слайдер
          activeColor: Colors.black,
          inactiveColor: Colors.grey,
        ),
      ],
    );
  }
}
