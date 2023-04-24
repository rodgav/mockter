import 'package:flutter/material.dart';
import 'package:mockter/presentation/home/home_viewmodel.dart';

class LogsPage extends StatelessWidget {
  final HomeViewModel _homeViewModel;

  const LogsPage(this._homeViewModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
        stream: _homeViewModel.logsOutput,
        builder: (_, snapshot) {
          final logs = snapshot.data;
          return logs != null
              ? ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (_, index) {
                    final log = logs[index];
                    return Text(log);
                  },
                  itemCount: logs.length,
                )
              : const SizedBox();
        });
  }
}
