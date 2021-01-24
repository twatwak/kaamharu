import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/database_helper.dart';
import '../models/task_model.dart';
import '../screens/add_task_screen.dart';
import '../utils/utils.dart';

class TodoListScreeen extends StatefulWidget {
  @override
  _TodoListScreeenState createState() => _TodoListScreeenState();
}

class _TodoListScreeenState extends State<TodoListScreeen> {
  Future<List<Task>> _taskList;
  final DateFormat _dateFormat = DateFormat('MMM dd,yyyy');
  final String _welmsg = Utils.getWelcomeMessage();

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  Widget _buildTask(Task task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Card(
        margin: EdgeInsets.all(2),
        elevation: 5,
        child: Column(
          children: [
            ListTile(
              dense: true,
              isThreeLine: true,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 50,
                  width: 50,
                  color: Colors.purple,
                  child: Icon(
                    Icons.work,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              title: Container(
                child: Text(
                  task.title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      decoration: task.status == 0
                          ? TextDecoration.none
                          : TextDecoration.lineThrough),
                ),
              ),
              subtitle: Text(
                '${task.desc} [${_dateFormat.format(task.date)}]',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    decoration: task.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough),
              ),
              trailing: Checkbox(
                  onChanged: (value) {
                    task.status = value ? 1 : 0;
                    DatabaseHelper.instance.updateTask(task);
                    _updateTaskList();
                  },
                  activeColor: Theme.of(context).primaryColor,
                  value: task.status == 1 ? true : false),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddTaskSreen(
                    task: task,
                    updateTaskList: _updateTaskList,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text(
          'Kaam Haru',
          style: TextStyle(fontFamily: 'Lato'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTaskSreen(
                updateTaskList: _updateTaskList,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: _taskList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final int completedTaskCount = snapshot.data
                .where((Task task) => task.status == 1)
                .toList()
                .length;

            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10),
              itemCount: 1 + snapshot.data.length,
              itemBuilder: (BuildContext context, int i) {
                if (i == 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _welmsg,
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Completed: $completedTaskCount of ${snapshot.data.length} tasks.',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              'Task List',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return _buildTask(snapshot.data[i - 1]);
              },
            );
          }),
    );
  }
}
