import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:tt_9/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:tt_9/const/subjects.dart';
import 'package:tt_9/data/operation.dart';
import 'package:tt_9/styles/app_theme.dart';

class AddNewOperationPage extends StatefulWidget {
  const AddNewOperationPage({super.key});

  @override
  State<AddNewOperationPage> createState() => _AddNewOperationPageState();
}

class _AddNewOperationPageState extends State<AddNewOperationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _objectiveController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  int _level = 1;

  @override
  void dispose() {
    _objectiveController.dispose();
    _subjectController.dispose();
    _topicController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveOperation() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        // Если дата не выбрана, показать сообщение об ошибке
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a date')),
        );
        return;
      }

      final operation = Operation(
        objective: _objectiveController.text,
        subject: _subjectController.text,
        topic: _topicController.text,
        date: _selectedDate!, // Безопасно использовать !, так как уже проверили
        level: _level,
        description: _descriptionController.text,
      );

      final operationBox = Hive.box<Operation>('operations');
      await operationBox.add(operation);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const CustomNavigationBar()));
    }
  }

  Future<void> _pickDate() async {
    // Используем CupertinoDatePicker внутри модального нижнего листа
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 250,
          color: AppTheme.background, // Фон соответствующий теме
          child: Column(
            children: [
              SizedBox(
                height: 190,
                child: CupertinoTheme(
                  data: CupertinoTheme.of(context).copyWith(
                    // Настраиваем цвет текста
                    textTheme: const CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        color: AppTheme
                            .secondary, // Установите желаемый цвет текста
                        fontSize: 20,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: _selectedDate ?? DateTime.now(),
                    minimumDate: DateTime(2020),
                    maximumDate: DateTime(2030),
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        _selectedDate = newDate;
                      });
                    },
                  ),
                ),
              ),
              CupertinoButton(
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color:
                        Colors.green, // Установите желаемый цвет текста кнопки
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubjectSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Отображение выбранного предмета
          Text(
            'Subject: ${_subjectController.text.isEmpty ? 'Select Subject' : _subjectController.text}',
            style: AppTheme.bodyLarge.copyWith(color: AppTheme.secondary),
          ),
          // PullDownButton для выбора предмета
          PullDownButton(
            itemBuilder: (context) => subjects.map((subject) {
              return PullDownMenuItem(
                itemTheme: const PullDownMenuItemTheme(),
                iconWidget: SvgPicture.asset(
                  getSubjectIcon(subject),
                  color: AppTheme.secondary,
                ),
                title: subject,
                onTap: () {
                  _updateSubject(subject);
                },
              );
            }).toList(),
            buttonBuilder: (context, showMenu) => CupertinoButton(
              onPressed: showMenu,
              padding: EdgeInsets.zero,
              child: const Row(
                children: [
                  Icon(
                    Icons.arrow_downward,
                    color: AppTheme.primary,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelSelector() {
    // Создаем список уровней от 1 до 10
    List<int> levels = List<int>.generate(5, (index) => index + 1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Отображение выбранного уровня
          Text(
            '$_level',
            style: AppTheme.bodyLarge.copyWith(color: AppTheme.secondary),
          ),
          // PullDownButton для выбора уровня
          PullDownButton(
            itemBuilder: (context) => levels.map((level) {
              return PullDownMenuItem(
                itemTheme: const PullDownMenuItemTheme(),
                iconWidget: const Icon(
                  Icons.star,
                  color: AppTheme.secondary,
                ),
                title: level.toString(),
                onTap: () {
                  _updateLevel(level);
                },
              );
            }).toList(),
            buttonBuilder: (context, showMenu) => CupertinoButton(
              onPressed: showMenu,
              padding: EdgeInsets.zero,
              child: const Row(
                children: [
                  Icon(
                    Icons.arrow_downward,
                    color: AppTheme.primary,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateSubject(String subject) {
    setState(() {
      _subjectController.text = subject;
    });
  }

  void _updateLevel(int level) {
    setState(() {
      _level = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: AppTheme.surface,
      hintStyle: const TextStyle(
          color: AppTheme.secondary,
          fontWeight: FontWeight.w400), // Стиль подсказок
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide.none,
      ),
    );

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Заголовок страницы
              const Row(
                children: [
                  Text(
                    'New Learning',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white, // Белый цвет заголовка
                    ),
                  )
                ],
              ),
              const SizedBox(height: 36),
              // Objective

              TextFormField(
                controller: _objectiveController,
                style: const TextStyle(
                    color: Colors.white), // Белый цвет вводимого текста
                cursorColor: Colors.white, // Белый цвет курсора
                decoration:
                    inputDecoration.copyWith(hintText: 'Learning objective'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter objective';
                  }
                  return null;
                },
              ),

              // Subject
              const SizedBox(height: 16),

              _buildSubjectSelector(),

              const SizedBox(height: 16),
              // Topic

              TextFormField(
                controller: _topicController,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration:
                    inputDecoration.copyWith(hintText: 'Topic of interest'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter topic';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              // Date
              GestureDetector(
                onTap: _pickDate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(72, 80, 100, 0.08),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedDate == null
                                ? 'Select a date'
                                : DateFormat.yMMMd().format(_selectedDate!),
                            style: _selectedDate == null
                                ? const TextStyle(
                                    color: AppTheme.secondary, fontSize: 16)
                                : const TextStyle(
                                    color: Colors.white, fontSize: 16),
                          ),
                          const Icon(Icons.calendar_month,
                              color: AppTheme.primary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Level

              _buildLevelSelector(),

              const SizedBox(height: 16),
              // Description

              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: inputDecoration.copyWith(hintText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              // Save Button
              ElevatedButton(
                onPressed: _saveOperation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Цвет фона кнопки
                  foregroundColor: Colors.white, // Цвет текста кнопки
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child:
                    const Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
