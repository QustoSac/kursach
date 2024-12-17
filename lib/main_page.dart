import 'package:flutter/material.dart';
import 'package:kursach/profile_page.dart';
import 'package:kursach/theme/theme.dart';
import 'vote_page.dart';
import 'results_page.dart';
import 'add_survey_page.dart';
import 'database_helper.dart'; // Импорт для работы с БД

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isSwitched = false;
  List<Map<String, dynamic>> _surveys = []; // Список опросов из базы данных

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
                    Switch(
                      value: isSwitched,
                      onChanged: (bool value) {
                        setState(() {
                          isSwitched = value;
                        });
                      },
                      activeColor: Colors.white,
                      inactiveThumbColor: Colors.grey,
                      activeTrackColor: Colors.black,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Организации',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
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
                      return _buildMenuItem(context, survey['Title'], 'Описание голосования', survey['SurveyID']);
                    },
                  ),
                ),
                SizedBox(height: 20),
                // Нижняя панель с кнопкой и поиском
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => ResultsPage(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
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
                        style: AppStyles.elevatedButtonStyle.copyWith(
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12)),
                        ),
                        icon: Icon(Icons.search, color: Colors.white),
                        label: Text(
                          'Посмотреть результаты',
                          style: AppStyles.buttonTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    FloatingActionButton(
                      onPressed: () {
                        // Логика добавления голосования
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => CreateSurveyPage(  ),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
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
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, String description, int surveyId) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VotePage(),//surveyId: surveyId),
          ),
        );
      },
      child: ListTile(
        leading: Icon(Icons.star, color: Colors.white),
        title: Text(title, style: AppStyles.inputTextStyle.copyWith(fontSize: 18)),
        subtitle: Text(description, style: AppStyles.footerTextStyle.copyWith(color: Colors.white70)),
        trailing: Icon(Icons.chevron_right, color: Colors.white),
      ),
    );
  }
}
