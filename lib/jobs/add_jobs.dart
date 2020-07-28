import 'package:TimeTracker/services/database.dart';
import 'package:TimeTracker/widgets/form_submit_button.dart';
import 'package:TimeTracker/widgets/platform_alert_dialog.dart';
import 'package:TimeTracker/widgets/platform_exception_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:TimeTracker/model/job_model.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddJobsPage extends StatefulWidget {
  const AddJobsPage({@required this.database, this.jobModel});
  final Database database;
  final JobModel jobModel;

  static Future<void> show(BuildContext context, {JobModel job}) async {
    final db = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddJobsPage(database: db, jobModel: job),
      fullscreenDialog: true,
    ));
  }

  @override
  _AddJobsPageState createState() => _AddJobsPageState();
}

class _AddJobsPageState extends State<AddJobsPage> {
  final _formKey = GlobalKey<FormState>();
  String _jobName;
  int _ratePerHour;

  FocusNode _jobNameFocusNode = FocusNode();
  FocusNode _rateFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.jobModel != null) {
      _jobName = widget.jobModel.name;
      _ratePerHour = widget.jobModel.ratePerHour;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.jobModel == null ? Text('Add Job') : Text('Edit Job'),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Builder(
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            initialValue: _jobName,
            focusNode: _jobNameFocusNode,
            decoration: InputDecoration(labelText: 'Job Name'),
            onSaved: (value) => _jobName = value,
            validator: (value) =>
                value.isEmpty ? 'Job name cannot be empty' : null,
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(_rateFocusNode),
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 8.0),
          TextFormField(
            initialValue: widget.jobModel == null
                ? null
                : widget.jobModel.ratePerHour.toString(),
            focusNode: _rateFocusNode,
            decoration: InputDecoration(labelText: 'Rate Per Hour'),
            keyboardType:
                TextInputType.numberWithOptions(decimal: false, signed: false),
            onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
            validator: (value) =>
                value.isEmpty ? 'Rate per hour cannot be empty' : null,
            textInputAction: TextInputAction.done,
            onEditingComplete: _submit,
          ),
          SizedBox(height: 20.0),
          FormSubmitButton(
            text: 'Submit',
            backGroundColor: Colors.indigo,
            borderRadius: 32.0,
            textColor: Colors.white,
            fontSize: 20.0,
            height: 45.0,
            onPressed: _submit,
          ),
          SizedBox(height: 20.0),
          Visibility(
            maintainState: true,
            maintainSize: false,
            maintainAnimation: true,
            visible: false,
            child: Center(child: CircularProgressIndicator()),
          )
        ],
      ),
    );
  }

  bool _validateForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else
      return false;
  }

  Future<void> _submit() async {
    try {
      if (_validateForm()) {
        final jobs = await widget.database.jobStream().first;
        final jobNames = jobs.map((e) => e.name).toList();
        if (widget.jobModel != null) {
          jobNames.remove(widget.jobModel.name);
        }
        if (jobNames.contains(_jobName)) {
          PlatformAlertDialog(
            title: 'Cannot Create Job',
            content:
                'This job name already exist. Please provide another name.',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          final id = widget.jobModel?.id ?? DateTime.now().toIso8601String();
          JobModel job =
              JobModel(id: id, name: _jobName, ratePerHour: _ratePerHour);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      }
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation Failed',
        exception: e,
      ).show(context);
    }
  }
}
