import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyme/models/app_state/app_data.dart';
import 'package:studyme/models/measure/measure.dart';
import 'package:studyme/ui/screens/measure_creator_type.dart';
import 'package:studyme/ui/widgets/measure_card.dart';

import 'measure_preview.dart';

class MeasureLibrary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(builder: (context, model, child) {
      List<Measure> _unaddedMeasures = model.unaddedMeasures;
      return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text("Add Measure"),
        ),
        body: ListView.builder(
          itemCount: _unaddedMeasures.length,
          itemBuilder: (context, index) {
            Measure _measure = _unaddedMeasures[index];
            return MeasureCard(
                measure: _measure,
                onTap: () => _previewMeasure(context, _measure));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _createMeasure(context);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  _previewMeasure(context, measure) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeasurePreview(measure: measure, isAdded: false),
      ),
    );
  }

  _createMeasure(context) {
    Function saveFunction = (Measure measure) {
      Provider.of<AppData>(context, listen: false).addMeasure(measure);
      Navigator.pushNamedAndRemoveUntil(context, '/creator', (r) => false);
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeasureCreatorType(onSave: saveFunction),
      ),
    );
  }
}
