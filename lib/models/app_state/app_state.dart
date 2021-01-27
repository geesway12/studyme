import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:studyme/models/app_state/default_measures.dart';
import 'package:studyme/models/intervention/intervention.dart';
import 'package:studyme/models/measure/measure.dart';
import 'package:studyme/models/trial.dart';
import 'package:studyme/models/trial_schedule.dart';
import 'package:uuid/uuid.dart';

class AppState extends ChangeNotifier {
  static const activeTrialKey = 'trial';
  static const isEditingKey = 'is_editing';

  Box box;
  Trial _trial;
  List<Measure> _measures;
  bool get isEditing => box.get(isEditingKey);

  Trial get trial => _trial;
  List<Measure> get measures => _measures;

  List<Measure> get unaddedMeasures {
    List<Measure> measures = defaultMeasures;
    measures.removeWhere(
        (i) => _trial.measures.map((x) => x.id).toList().contains(i.id));
    return measures;
  }

  void setInterventionA(Intervention intervention) {
    _trial.a = intervention;
    _trial.save();
    notifyListeners();
  }

  void setInterventionB(Intervention intervention) {
    _trial.b = intervention;
    _trial.save();
    notifyListeners();
  }

  Trial setupNewTrial() {
    final _interventionA = Intervention()
      ..id = Uuid().v4()
      ..name = 'Take medicine'
      ..description = 'Take your bloody medicine right now';
    final _interventionB = Intervention()
      ..id = Uuid().v4()
      ..name = 'Do sport'
      ..description = '';

    final _trialSchedule = TrialSchedule(
        phaseDuration: 1,
        numberOfCycles: 1,
        phaseOrder: PhaseOrder.alternating);

    return Trial()
      ..a = _interventionA
      ..b = _interventionB
      ..measures = []
      ..schedule = _trialSchedule;
  }

  int _getTrialIndexForMeasureId(String id) {
    return _trial.measures.indexWhere((i) => i.id == id);
  }

  void updateMeasure(Measure measure, Measure newMeasure) {
    var index = _getTrialIndexForMeasureId(measure.id);
    if (index >= 0) {
      _trial.measures[index] = newMeasure;
      _trial.save();
      notifyListeners();
    }
  }

  void addMeasureToTrial(Measure measure) {
    _trial.measures.add(measure);
    _trial.save();
    notifyListeners();
  }

  void removeMeasureFromTrial(Measure measure) {
    var index = _getTrialIndexForMeasureId(measure.id);
    if (index >= 0) {
      _trial.measures.removeAt(index);
      _trial.save();
      notifyListeners();
    }
  }

  void updateSchedule(TrialSchedule schedule) {
    _trial.schedule = schedule;
    _trial.save();
    notifyListeners();
  }

  loadAppState() async {
    box = await Hive.openBox('app_data');
    _trial = box.get(activeTrialKey);
    if (_trial == null) {
      // first time app is started
      _trial = setupNewTrial();
      box.put(activeTrialKey, _trial);
      box.put(isEditingKey, true);
    }
  }

  startTrial() {
    saveIsEditing(true);
    DateTime now = DateTime.now();
    _trial.startDate = DateTime(now.year, now.month, now.day);
    _trial.save();
  }

  saveIsEditing(bool isEditing) {
    box.put(isEditingKey, isEditing);
  }
}
