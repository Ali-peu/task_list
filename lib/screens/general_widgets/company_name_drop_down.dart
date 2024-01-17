import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_list/blocs/drop_down_bloc/drop_down_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DropDownWithRefKeyAndChangeValue extends StatelessWidget {
  final Future<List<dynamic>> getFutureList;
  const DropDownWithRefKeyAndChangeValue(
      {required this.getFutureList,
      required this.onRefKeyGetIt,
      required this.onDropDownValueChoose,
      super.key});
  final ValueChanged<String> onRefKeyGetIt;
  final ValueChanged<String> onDropDownValueChoose;

  @override
  Widget build(BuildContext context) {
    bool firstTime = true;
    final dropdownBloc = BlocProvider.of<DropDownBloc>(context);
    return BlocBuilder<DropDownBloc, DropdownBlocState>(
      builder: (context, state) {
        return FutureBuilder<List<dynamic>>(
          future: getFutureList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text(AppLocalizations.of(context)!.refreshPageText);
            } else {
              // TODO
              List<String> refKeyList = snapshot.data![0];
              List<String> companyName = snapshot.data![1];

              String selectedValue = state.selectedValue;
              firstTime
                  ? {
                      onDropDownValueChoose(companyName.first),
                      onRefKeyGetIt(refKeyList.first)
                    }
                  : {};

              return DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: state.selectedValue.isEmpty
                      ? companyName.first
                      : selectedValue,
                  isExpanded: true,
                  underline: const Divider(),
                  items: companyName.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null && newValue != state.selectedValue) {
                      dropdownBloc.add(ValueWasChange(newValue: newValue));
                      firstTime = false;
                      onRefKeyGetIt(refKeyList[companyName
                          .indexWhere((element) => element == newValue)]);
                      onDropDownValueChoose(newValue);
                      print('[false log]typeOfTask Task: $newValue');
                      print(
                          '[false log]  Это его ключевое представление форма :  ${refKeyList[companyName.indexWhere((element) => element == newValue)]}');
                    }
                  },
                ),
              );
            }
          },
        );
      },
    );
  }
}
