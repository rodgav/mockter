import 'package:flutter/material.dart';
import 'package:mockter/presentation/common/dialogs/mockter_dialogs.dart';
import 'package:mockter/presentation/home/home_viewmodel.dart';
import 'package:mockter/presentation/home/widgets/custom_text_form_field.dart';

class SettingsPage extends StatelessWidget {
  final HomeViewModel _homeViewModel;
  final String? _host;
  final int? _port;

  SettingsPage(this._homeViewModel, this._host, this._port, {Key? key})
      : super(key: key);
  final _nameTextEditCtrl = TextEditingController();
  final _descriptionTextEditCtrl = TextEditingController();
  final _hostTextEditCtrl = TextEditingController();
  final _portTextEditCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MockTerData?>(
        stream: _homeViewModel.mockTerDataOutput,
        builder: (_, snapshot) {
          final mockTerData = snapshot.data;
          final environment = mockTerData?.environment;
          final path = mockTerData?.path;
          final response = mockTerData?.response;
          _setValuesToTextCtrls(mockTerData);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Name'),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 240,
                        height: 30,
                        child: CustomTextFormField(_nameTextEditCtrl),
                      )
                    ]),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Description'),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                            height: 30,
                            child:
                                CustomTextFormField(_descriptionTextEditCtrl)),
                      )
                    ]),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('API URL'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                height: 38,
                child: Row(
                  children: [
                    SizedBox(
                        width: 120,
                        child: CustomTextFormField(_hostTextEditCtrl)),
                    const SizedBox(width: 10),
                    const Text(':'),
                    const SizedBox(width: 10),
                    SizedBox(
                        width: 60,
                        child: CustomTextFormField(_portTextEditCtrl)),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Actions'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () {
                          if (environment != null &&
                              path != null &&
                              response != null) {
                            environment.title = _nameTextEditCtrl.text.trim();
                            environment.description =
                                _descriptionTextEditCtrl.text.trim();
                            final host = _hostTextEditCtrl.text.trim();
                            final port =
                                int.tryParse(_portTextEditCtrl.text.trim()) ??
                                    0;
                            _homeViewModel.updateEnvironment(
                                host, port, environment, path, response);
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text('Save')),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () {
                          if (environment != null) {
                            _homeViewModel.deleteEnvironment(environment);
                          } else {
                            showErrorDialog(context,
                                description:
                                    'Ocurrio un error al eliminar el environment');
                          }
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete environment')),
                  ],
                ),
              )
            ],
          );
        });
  }

  _setValuesToTextCtrls(MockTerData? mockTerData) {
    if (mockTerData != null) {
      _nameTextEditCtrl.text = mockTerData.environment?.title ?? '';
      _descriptionTextEditCtrl.text =
          mockTerData.environment?.description ?? '';
      _hostTextEditCtrl.text = _host ?? '127.0.0.1';
      _portTextEditCtrl.text = _port != null ? _port.toString() : '7001';
    }
  }
}
