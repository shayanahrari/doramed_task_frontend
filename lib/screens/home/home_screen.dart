import 'package:doramed/api/models.dart';
import 'package:doramed/api/requests.dart';
import 'package:doramed/db/shared_preffs.dart';
import 'package:doramed/materials/myappbar.dart';
import 'package:doramed/materials/screen_widget.dart';
import 'package:doramed/materials/theme/colors.dart';
import 'package:doramed/screens/login/login_scree.dart';
import 'package:doramed/screens/tasks/add_change_tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  static String routeName = '/';

  final JwtModel jwt;
  final UserModel user;

  const HomePage({
    super.key,
    required this.jwt,
    required this.user,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TaskService taskServices;
  final UserService userService = UserService();
  final SharedPref sharedPref = SharedPref();

  bool _logouting = false;

  @override
  void initState() {
    taskServices = TaskService(jwt: widget.jwt);
    super.initState();
  }

  void _onTaskDelete() {
    setState(() {});
  }

  void _logout(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.all(12),
        content: const Text(
          'Are you sure you want to exit?',
        ),
        action: SnackBarAction(
          label: 'Yes',
          onPressed: () async {
            try {
              setState(() {
                _logouting = true;
              });

              bool loggedOut = await userService.logout(widget.jwt);

              if (loggedOut) {
                setState(() {
                  _logouting = false;
                });

                await sharedPref.remove('jwt');
                await sharedPref.remove('user');

                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                }
              } else {
                setState(() {
                  _logouting = false;
                });
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      padding: EdgeInsets.all(12),
                      content: Text(
                        'Failed to exiting from account',
                      ),
                    ),
                  );
                }
              }
            } catch (e) {
              setState(() {
                _logouting = false;
              });
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    padding: EdgeInsets.all(12),
                    content: Text(
                      'something was wrong!',
                    ),
                  ),
                );
              }
            }
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.back,
      appBar: PublicAppBar(
        pageName: 'Doramed',
        titleStyle: const TextStyle(
          fontSize: 26,
          color: CustomColors.nine,
          fontWeight: FontWeight.w600,
          fontFamily: 'grandhotel',
        ),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {});
            },
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedRefresh,
              color: Colors.black,
              size: 24.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GestureDetector(
              onTap: () {
                _logout(context);
              },
              child: _logouting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: CustomColors.tronred,
                      ),
                    )
                  : HugeIcon(
                      icon: HugeIcons.strokeRoundedLogout02,
                      color: CustomColors.tronred,
                      size: 24.0,
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColors.but,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddTaskPage(
                user: widget.user,
                jwt: widget.jwt,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ScreenWidget(
        crossAxisAlignment: CrossAxisAlignment.start,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        content: [
          const Text(
            'Tasks',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          FutureBuilder(
            future: taskServices.listTasks(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<TaskModel?> tasksList = snapshot.data!;
                if (tasksList.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      TaskModel task = tasksList[index]!;
                      return TaskTileWidget(
                        task: task,
                        service: taskServices,
                        jwt: widget.jwt,
                        user: widget.user,
                        onDelete: _onTaskDelete,
                      );
                    },
                    itemCount: tasksList.length,
                  );
                } else {
                  return const NoContentWidget(
                    title: "No tasks found.",
                    description:
                        'You can use the floating "+" button to create a new tasks.',
                    image: 'assets/images/test.jpg',
                  );
                }
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Server error, do it later!'),
                );
              } else {
                return const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

class TaskTileWidget extends StatelessWidget {
  final UserModel user;
  final JwtModel jwt;
  final TaskModel task;
  final TaskService service;
  final VoidCallback onDelete;

  const TaskTileWidget({
    super.key,
    required this.service,
    required this.task,
    required this.onDelete,
    required this.user,
    required this.jwt,
  });

  // This function shows a snackbar with 'Yes' button for confirmation
  void showDeleteConfirmation(BuildContext context, String title) {
    // Show Yes button only after displaying initial snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.all(12),
        content: Text(
          'Delete $title ?',
        ),
        action: SnackBarAction(
          label: 'Yes',
          onPressed: () async {
            try {
              bool isDeleted = await service.deleteTask(task.id);

              if (isDeleted) {
                if (context.mounted) {
                  onDelete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      padding: EdgeInsets.all(12),
                      content: Text(
                        'Task deleted successfully',
                      ),
                    ),
                  );
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      padding: EdgeInsets.all(12),
                      content: Text(
                        'Failed to delete task',
                      ),
                    ),
                  );
                }
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    padding: EdgeInsets.all(12),
                    content: Text(
                      'something was wrong!',
                    ),
                  ),
                );
              }
            }
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: CustomColors.ten,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Row(
          children: [
            Text(
              task.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                const Text(
                  'status: ',
                  style: TextStyle(
                    fontSize: 12,
                    color: CustomColors.four,
                  ),
                ),
                Text(
                  task.status,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: CustomColors.eight,
                  ),
                ),
              ],
            ),
          ],
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              task.description ?? 'No description',
              style: const TextStyle(
                color: CustomColors.eight,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              'Due date: ${DateFormat('yyyy-MM-dd  HH:mm').format(task.dueDate)}',
              style: const TextStyle(
                fontSize: 12,
                color: CustomColors.four,
              ),
            ),
            Text(
              'Created at: ${DateFormat('yyyy-MM-dd  HH:mm').format(task.created)}',
              style: const TextStyle(
                fontSize: 12,
                color: CustomColors.four,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddTaskPage(
                          task: task,
                          user: user,
                          jwt: jwt,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Change',
                    style: TextStyle(
                      color: CustomColors.b,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    showDeleteConfirmation(context, task.title);
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      color: CustomColors.tronred,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class NoContentWidget extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const NoContentWidget({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return BoxWidget(
      backColor: CustomColors.ten,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: 300,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: CustomColors.ten,
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              title,
              style: const TextStyle(
                color: CustomColors.nine,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.15,
              ),
            ),
          ),
          SizedBox(
            width: 200,
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CustomColors.six,
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}
