import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyme/models/app_state/app_state.dart';
import 'package:studyme/models/measure/choice_measure.dart';
import 'package:studyme/models/measure/free_measure.dart';
import 'package:studyme/models/measure/measure.dart';
import 'package:studyme/models/measure/scale_measure.dart';
import 'package:studyme/ui/editor/measure_editor_screen.dart';
import 'package:studyme/ui/widgets/choice_measure_widget.dart';
import 'package:studyme/ui/widgets/free_measure_widget.dart';
import 'package:studyme/ui/widgets/scale_measure_widget.dart';

class MeasurePreviewScreen extends StatelessWidget {
  final Measure measure;
  final bool isAdded;

  const MeasurePreviewScreen({@required this.measure, @required this.isAdded});

  @override
  Widget build(BuildContext context) {
    Widget _preview;
    switch (measure.runtimeType) {
      case FreeMeasure:
        _preview = FreeMeasureWidget(measure, null);
        break;
      case ChoiceMeasure:
        _preview = ChoiceMeasureWidget(measure, null);
        break;
      case ScaleMeasure:
        _preview = ScaleMeasureWidget(measure, null);
        break;
      default:
        return null;
    }

    return Scaffold(
        appBar: AppBar(title: Text(measure.name + " (Preview)")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                if (measure.description != null &&
                    measure.description.length > 0)
                  Text(measure.description),
                if (_preview != null) _preview,
                if (!isAdded)
                  OutlineButton.icon(
                      icon: Icon(Icons.add),
                      label: Text("Add to trial"),
                      onPressed: () {
                        Navigator.pop(context, measure);
                      }),
                if (isAdded)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlineButton.icon(
                          icon: Icon(Icons.delete),
                          label: Text("Remove"),
                          onPressed: () {
                            _removeMeasure(context);
                          }),
                      OutlineButton.icon(
                          icon: Icon(Icons.edit),
                          label: Text("Edit"),
                          onPressed: () {
                            _editMeasure(context);
                          }),
                    ],
                  )
              ],
            ),
          ),
        ));
  }

  _removeMeasure(context) {
    Provider.of<AppState>(context, listen: false)
        .removeMeasureFromTrial(measure);
    Navigator.pop(context);
  }

  _editMeasure(context) {
    _navigateToEditor(context).then((result) {
      if (result != null) {
        Provider.of<AppState>(context, listen: false)
            .updateMeasure(measure, result);
        Navigator.pop(context);
      }
    });
  }

  Future _navigateToEditor(context) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MeasureEditorScreen(isCreator: false, measure: measure),
      ),
    );
  }
}
