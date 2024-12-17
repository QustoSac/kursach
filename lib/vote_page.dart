import 'package:flutter/material.dart';
import 'package:kursach/main_page.dart';
import 'package:kursach/results_page.dart';
import 'database_helper.dart';
import 'theme/theme.dart';

// ГЛАВНАЯ СТРАНИЦА ГОЛОСОВАНИЯ

class VotePage extends StatefulWidget {
  final int surveyId; // Идентификатор опроса

  VotePage({required this.surveyId});

  @override
  _VotePageState createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: AppStyles.backgroundGradient,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                      MainPage(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(-1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeOut;
                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    var offsetAnimation = animation.drive(tween);
                                    return SlideTransition(position: offsetAnimation, child: child);
                                  },
                                  transitionDuration: Duration(milliseconds: 1000),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: kToolbarHeight + 20),
                      Center(
                        child: Text(
                          'Название голосования',
                          style: TextStyle(
                              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Добавление динамического контента
                      Expanded(
                        child: SurveyDetailsPage(surveyId: 1), // Передача идентификатора опроса
                      ),
                      //Spacer(),
                    ],
                  ),
                ),
              ),
            ),
        );
  }
}

// СТРАНИЦА ОПРОСА
class SurveyDetailsPage extends StatefulWidget {
  final int surveyId;

  SurveyDetailsPage({required this.surveyId});

  @override
  _SurveyDetailsPageState createState() => _SurveyDetailsPageState();
}

class _SurveyDetailsPageState extends State<SurveyDetailsPage> {
  Map<String, dynamic>? _survey;
  List<Map<String, dynamic>> _questions = [];
  Map<int, dynamic> _answers = {};
  Map<int, int?> _selectedOptionIds = {};
  Map<int, List<int>> _selectedMultipleOptionIds = {};
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _loadSurveyDetails();
  }

  Future<void> _loadUserId() async {
    final userId = DatabaseHelper().currentUserId;
    if (userId != null) {
      setState(() {
        _userId = userId;
      });
    } else {
      throw Exception('Текущий пользователь не найден');
    }
  }

  Future<void> _loadSurveyDetails() async {
    final survey = await DatabaseHelper().getSurveyById(widget.surveyId);
    final questions = await DatabaseHelper().getQuestionsBySurveyId(widget.surveyId);
    setState(() {
      _survey = survey;
      _questions = questions;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_survey == null || _userId == null) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(_survey!['Title'] ?? '', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text(_survey!['Description'] ?? '', style: TextStyle(fontSize: 16)),
        SizedBox(height: 16),
        ..._buildQuestionWidgets(),
        SizedBox(height: 16,),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: AppStyles.elevatedButtonStyle,
            onPressed: _submitResponses,
            child: Text('Проголосовать', style: AppStyles.buttonTextStyle,),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildQuestionWidgets() {
    return _questions.map((question) {
      final questionId = question['QuestionID'];
      final questionText = question['QuestionText'];
      final questionType = question['QuestionType'];

      List<Widget> widgets = [];
      widgets.add(
        Text(questionText, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      );

      switch (questionType) {
        case 'text':
          widgets.add(_buildTextQuestion(questionId, questionText));
          break;
        case 'single_choice':
          widgets.add(_buildSingleChoiceQuestion(questionId, questionText));
          break;
        case 'multiple_choice':
          widgets.add(_buildMultipleChoiceQuestion(questionId, questionText));
          break;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      );
    }).toList();
  }

  Widget _buildTextQuestion(int questionId, String questionText) {
    return TextFormField(
      onChanged: (text) {
        setState(() {
          _answers[questionId] = {'textAnswer': text};
        });
      },
      decoration: InputDecoration(labelText: questionText),
    );
  }

  Widget _buildSingleChoiceQuestion(int questionId, String questionText) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper().getOptionsByQuestionId(questionId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          final options = snapshot.data ?? [];
          return Column(
            children: options.map((option) {
              final optionId = option['OptionID'];
              return RadioListTile<int>(
                title: Text(option['OptionText']),
                value: optionId,
                groupValue: _selectedOptionIds[questionId],
                onChanged: (value) {
                  setState(() {
                    _selectedOptionIds[questionId] = value;
                    _answers[questionId] = {'optionID': value};
                  });
                },
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget _buildMultipleChoiceQuestion(int questionId, String questionText) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper().getOptionsByQuestionId(questionId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          final options = snapshot.data ?? [];
          return Column(
            children: options.map((option) {
              final optionId = option['OptionID'];
              return CheckboxListTile(
                title: Text(option['OptionText']),
                value: (_selectedMultipleOptionIds[questionId] ?? []).contains(optionId),
                onChanged: (isChecked) {
                  setState(() {
                    if (isChecked!) {
                      (_selectedMultipleOptionIds[questionId] ??= []).add(optionId);
                    } else {
                      (_selectedMultipleOptionIds[questionId] ??= []).remove(optionId);
                    }
                    _answers[questionId] = {'OptionIDs': _selectedMultipleOptionIds[questionId]};
                  });
                },
              );
            }).toList(),
          );
        }
      },
    );
  }

  Future<void> _submitResponses() async {
    // Логика сохранения
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ответы успешно отправлены!')),
    );
  }
}
