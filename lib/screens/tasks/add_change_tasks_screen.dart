import 'package:bottom_picker/bottom_picker.dart';
import 'package:doramed/api/models.dart';
import 'package:doramed/api/requests.dart';
import 'package:doramed/materials/custom_listtiles.dart';
import 'package:doramed/materials/myappbar.dart';
import 'package:doramed/materials/screen_widget.dart';
import 'package:doramed/materials/textfields.dart';
import 'package:doramed/materials/theme/colors.dart';
import 'package:doramed/screens/home/status_screen.dart';
import 'package:flutter/material.dart';

class AddTaskPage extends StatefulWidget {
  static String routeName = '/add-task';
  final TaskModel? task;
  final UserModel user;
  final JwtModel jwt;

  const AddTaskPage({
    super.key,
    this.task,
    required this.user,
    required this.jwt,
  });

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  late final TaskService taskServices;

  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedDateTime;

  bool _isLoading = false;

  int _selectedOption = 1;

  @override
  void initState() {
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _selectedDateTime = widget.task!.dueDate;
      _selectedOption = statusSetterFromString(widget.task!.status);
    }
    taskServices = TaskService(jwt: widget.jwt);
    super.initState();
  }

  int statusSetterFromString(String status) {
    if (status == 'in_progress') {
      return 1;
    } else if (status == 'completed') {
      return 2;
    } else {
      return 3;
    }
  }

  String statusSetterFromInt(int status) {
    if (status == 1) {
      return 'in_progress';
    } else if (status == 2) {
      return 'completed';
    } else {
      return 'postponed';
    }
  }

  void _addTask(BuildContext context) async {
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      if (_selectedDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please choose a date and time'),
          ),
        );
        return;
      }

      String title = _titleController.text.trim();
      String? description = _descriptionController.text;
      DateTime dueDate = _selectedDateTime!;

      setState(() {
        _isLoading = true;
      });

      Map<String, dynamic> data = {
        "user": widget.user.id,
        "title": title,
        "description": description,
        "due_date": dueDate.toIso8601String(),
        "assigned_users": [],
      };

      TaskModel task = await taskServices.createTask(data);

      setState(() {
        _isLoading = false;
      });

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => StatusPage(
              jwt: widget.jwt,
              user: widget.user,
              message: '${task.title} created Successfully',
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('something was wrong do it later!'),
          ),
        );
      }
    }
  }

  void _changeTask(BuildContext context) async {
    try {
      if (widget.task == null) {
        return;
      }

      if (!_formKey.currentState!.validate()) {
        return;
      }

      if (_selectedDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please choose a date and time'),
          ),
        );
        return;
      }

      String title = _titleController.text.trim();
      String? description = _descriptionController.text;
      DateTime dueDate = _selectedDateTime!;

      setState(() {
        _isLoading = true;
      });

      Map<String, dynamic> data = {
        'id': widget.task!.id,
        "user": widget.user.id,
        "title": title,
        "description": description,
        "due_date": dueDate.toIso8601String(),
        'status': statusSetterFromInt(_selectedOption),
        "assigned_users": [],
      };

      TaskModel task = await taskServices.updateTask(widget.task!.id, data);

      setState(() {
        _isLoading = false;
      });

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => StatusPage(
              jwt: widget.jwt,
              user: widget.user,
              message: '${task.title} updated Successfully',
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('something was wrong do it later!'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.back,
      appBar: PublicAppBar(
        pageName: widget.task != null ? 'Change task' : 'Add Task',
      ),
      body: ScreenWidget(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
        content: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ChangeBoxSetWidget(
                  title: 'title',
                  content: SetTextFormField(
                    hintText: 'type here..',
                    keyboardType: TextInputType.name,
                    controller: _titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                ),
                ChangeBoxSetWidget(
                  title: 'description',
                  content: SetTextFormField(
                    hintText: 'type here..',
                    maxLines: 1,
                    keyboardType: TextInputType.name,
                    controller: _descriptionController,
                  ),
                ),
                ChangeBoxSetWidget(
                  title: 'Date & Time',
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        _selectedDateTime != null
                            ? 'Selected: ${_selectedDateTime!.toLocal()}'
                            : 'Selected: No date and time selected yet!',
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: 250,
                        child: GestureDetector(
                          onTap: () {
                            _openDateTimePicker(context);
                          },
                          child: const Text(
                            'Tap here to select date and time',
                            style: TextStyle(
                              color: CustomColors.b,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ChangeBoxSetWidget(
                  title: 'Status',
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ItemTileSet(
                        title: 'In progress',
                        haveBorder: true,
                        trailing: _buildRadioOption(
                          1,
                        ),
                        ontap: () {
                          setState(() {
                            _selectedOption = 1;
                          });
                        },
                      ),
                      ItemTileSet(
                        title: 'Completed',
                        haveBorder: true,
                        trailing: _buildRadioOption(
                          2,
                        ),
                        ontap: () {
                          setState(() {
                            _selectedOption = 2;
                          });
                        },
                      ),
                      ItemTileSet(
                        title: 'Postponed',
                        haveBorder: false,
                        trailing: _buildRadioOption(
                          3,
                        ),
                        ontap: () {
                          setState(() {
                            _selectedOption = 3;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          widget.task == null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.selc,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _addTask(context);
                    },
                    child: _isLoading
                        ? const SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: CustomColors.ten,
                            ),
                          )
                        : const Text(
                            'Add Task',
                            style: TextStyle(
                              color: CustomColors.ten,
                            ),
                          ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.selc,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _changeTask(context);
                    },
                    child: _isLoading
                        ? const SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: CustomColors.ten,
                            ),
                          )
                        : const Text(
                            'Change Task',
                            style: TextStyle(
                              color: CustomColors.ten,
                            ),
                          ),
                  ),
                )
        ],
      ),
    );
  }

  void _openDateTimePicker(BuildContext context) {
    BottomPicker.dateTime(
      minuteInterval: 2,
      pickerTitle: const Text(
        'Set the event exact time and date',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.black,
        ),
      ),
      onSubmit: (date) {
        setState(() {
          _selectedDateTime = date;
        });
      },
      onCloseButtonPressed: () {},
      minDateTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      maxDateTime: DateTime(2030, 8, 2),
      initialDateTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      gradientColors: const [
        Color(0xfffdcbf1),
        Color(0xffe6dee9),
      ],
    ).show(context);
  }

  Widget _buildRadioOption(int value) {
    return Radio(
      value: value,
      groupValue: _selectedOption,
      visualDensity: const VisualDensity(
        horizontal: VisualDensity.minimumDensity,
        vertical: VisualDensity.minimumDensity,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return CustomColors.selc;
        }
        return CustomColors.six;
      }),
      activeColor: CustomColors.selc, // Customize the color
      onChanged: (int? value) {
        setState(() {
          _selectedOption = value!;
        });
      },
    );
  }
}
