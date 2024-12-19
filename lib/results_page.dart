import 'package:flutter/material.dart';
import 'package:kursach/main_page.dart';
import 'package:kursach/vote_page.dart';
import 'database_helper.dart';
import 'profile_page.dart';
import 'view_results_page.dart';
import 'theme/theme.dart';

class ResultsPage extends StatefulWidget {
  @override
  _ReaultsPageState createState() => _ReaultsPageState();
}

class _ReaultsPageState extends State<ResultsPage>{
  List<Map<String, dynamic>> _surveys = []; // Список опросов из базы данных
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    _loadSurveys(); // Загрузка опросов при инициализации
  }

  // Метод для загрузки опросов
  Future<void> _loadSurveys() async {
    final surveys = await DatabaseHelper().getAvailableSurveys();
    setState(() {
      _surveys = surveys;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppStyles.backgroundGradient, // Градиент фона
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Верхняя панель с аватаром
                Row(
                  children: [
                    IconButton(
                      icon: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const curve = Curves.easeInOut;
                              var tween = Tween<double>(begin: 0.8, end: 1.0).chain(CurveTween(curve: curve));
                              var scaleAnimation = animation.drive(tween);

                              return ScaleTransition(
                                scale: scaleAnimation,
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
                SizedBox(height: 30),
                // Заголовок и переключатели
                Row(
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: TextField(
                          obscureText: true,
                          decoration: AppStyles.golosovanieDecoration.copyWith(
                            hintText: 'Голосование',
                          ),
                          style: AppStyles.inputTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(width: 40),

                  ],
                ),
                SizedBox(height: 20),
                // Список голосований из базы данных
                Expanded(
                  child: _surveys.isEmpty
                      ? Center(child: Text('Нет доступных голосований.', style: TextStyle(color: Colors.white)))
                      : ListView.builder(
                    itemCount: _surveys.length,
                    itemBuilder: (context, index) {
                      final survey = _surveys[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SurveyDetailSheet(surveyId: survey['SurveyID']),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: Icon(Icons.star, color: Colors.white),
                          title: Text(survey['Title'], style: AppStyles.inputTextStyle.copyWith(fontSize: 18)),
                          subtitle: Text(survey['Description'], style: AppStyles.footerTextStyle.copyWith(color: Colors.white70)),
                          trailing: Icon(Icons.chevron_right, color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child : Align(
                  alignment: Alignment.bottomLeft,
                  child: FloatingActionButton(
                    onPressed: () {
                      // Логика кнопки "домой"
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
                    backgroundColor: Colors.black,
                    child: Icon(Icons.home, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

