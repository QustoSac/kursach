import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'theme/theme.dart';
import 'main_page.dart';

class VotePage extends StatefulWidget {
  final int surveyId;

  VotePage({required this.surveyId});

  @override
  _VotePageState createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
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

  Future<void> _submitResponses() async {
    if (_userId == null) return;

    final formattedAnswers = _answers.entries.map((entry) {
      final questionId = entry.key;
      final answerData = entry.value;

      return {
        'questionID': questionId,
        'optionID': answerData['optionID'],
        'optionIDs': answerData['OptionIDs'],
        'textAnswer': answerData['textAnswer'],
      };
    }).toList();

    try {
      await DatabaseHelper().submitResponse(
        userID: _userId!,
        surveyID: widget.surveyId,
        answers: formattedAnswers,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ответы успешно отправлены!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка отправки ответов: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_survey == null || _userId == null) {
      return Center(child: CircularProgressIndicator());
    }

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
                          ),
                        ],
                      ),
                      SizedBox(height: kToolbarHeight + 20),
                      // Отступ для AppBar
                      Center(
                        child: Text(
                          _survey?['Title'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          _survey!['Description'] ?? '',
                          style: AppStyles.footerTextStyle.copyWith(color: Colors.white70),
                        ),
                      ),
                      SizedBox(height: 16),
                      ..._questions.map((question) {
                        final questionId = question['QuestionID'];
                        final questionText = question['QuestionText'];
                        final questionType = question['QuestionType'];

                        return _buildQuestionBlock(questionId, questionText, questionType);
                      }),
                      SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: _submitResponses,
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

  Widget _buildQuestionBlock(int questionId, String questionText, String questionType) {
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
        if (questionType == 'text') _buildTextQuestion(questionId),
        if (questionType == 'single_choice') _buildSingleChoiceQuestion(questionId),
        if (questionType == 'multiple_choice') _buildMultipleChoiceQuestion(questionId),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextQuestion(int questionId) {
    return TextFormField(
      onChanged: (text) {
        setState(() {
          _answers[questionId] = {'textAnswer': text};
        });
      },
      decoration: InputDecoration(
        hintText: 'Ответ: ',
        hintStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.black,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: Colors.white),
      maxLines: 1,
    );
  }

  Widget _buildSingleChoiceQuestion(int questionId) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper().getOptionsByQuestionId(questionId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        final options = snapshot.data!;
        return Column(
          children: options.map((option) {
            final optionId = option['OptionID'];
            return RadioListTile<int>(
              title: Text(option['OptionText'], style: TextStyle(color: Colors.white)),
              value: optionId,
              groupValue: _selectedOptionIds[questionId],
              onChanged: (value) {
                setState(() {
                  _selectedOptionIds[questionId] = value;
                  _answers[questionId] = {'optionID': value};
                });
              },
              activeColor: Colors.black,
              fillColor: MaterialStateProperty.all(Colors.white),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildMultipleChoiceQuestion(int questionId) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper().getOptionsByQuestionId(questionId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        final options = snapshot.data!;
        return Column(
          children: options.map((option) {
            final optionId = option['OptionID'];
            final isChecked = (_selectedMultipleOptionIds[questionId] ?? []).contains(optionId);
            return CheckboxListTile(
              title: Text(option['OptionText'], style: TextStyle(color: Colors.white)),
              value: isChecked,
              onChanged: (checked) {
                setState(() {
                  if (checked!) {
                    (_selectedMultipleOptionIds[questionId] ??= []).add(optionId);
                  } else {
                    (_selectedMultipleOptionIds[questionId] ??= []).remove(optionId);
                  }
                  _answers[questionId] = {'OptionIDs': _selectedMultipleOptionIds[questionId]};
                });
              },
              activeColor: Colors.white,
              checkColor: Colors.black,
              fillColor: MaterialStateProperty.all(Colors.white),
            );
          }).toList(),
        );
      },
    );
  }
}
