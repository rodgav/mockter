import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mockter/application/extensions/methods_extension.dart';
import 'package:mockter/domain/model/mockter.dart';
import 'package:mockter/presentation/common/dialogs/mockter_dialogs.dart';
import 'package:mockter/presentation/home/home_viewmodel.dart';
import 'package:mockter/presentation/home/widgets/custom_text_form_field.dart';

class RoutesPage extends StatelessWidget {
  final HomeViewModel _homeViewModel;

  RoutesPage(this._homeViewModel, {Key? key}) : super(key: key);

  final _searchPathTextEditCtrl = TextEditingController();
  final _pathTextEditCtrl = TextEditingController();
  final _summaryTextEditCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<MockTerData?>(
        stream: _homeViewModel.mockTerDataOutput,
        builder: (_, snapshot) {
          final mockTerData = snapshot.data;
          final environment = mockTerData?.environment;
          final paths = environment?.paths;
          final path = mockTerData?.path;
          final pathId = path?.id;
          final responses = path?.responses;
          final response = mockTerData?.response;
          _pathTextEditCtrl.text = path?.path ?? '';
          _summaryTextEditCtrl.text = path?.summary ?? '';
          return Row(
            children: [
              SizedBox(
                width: 200,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Ink(
                              child: InkWell(
                                child: const Icon(Icons.add_box),
                                onTap: () {
                                  if (environment != null) {
                                    _homeViewModel.addPath(environment);
                                  } else {
                                    showErrorDialog(context,
                                        description: 'Error al añadir el path');
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              height: 30,
                              child:
                                  CustomTextFormField(_searchPathTextEditCtrl),
                            )
                          ]),
                    ),
                    Expanded(
                        child: paths != null
                            ? ListView.separated(
                                itemBuilder: (_, index) {
                                  final path = paths[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: path.id == pathId
                                                    ? Colors.blue
                                                    : Colors.transparent,
                                                width: 4))),
                                    child: ListTile(
                                      title: Stack(
                                        children: [
                                          Text(path.path, maxLines: 1),
                                          Positioned(
                                              right: 0,
                                              child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 4,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                      color: path.method
                                                          .getColor(),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2)),
                                                  child: Text(
                                                    path.method
                                                        .getName()
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10),
                                                  )))
                                        ],
                                      ),
                                      subtitle: Text(path.summary, maxLines: 1),
                                      onTap: () {
                                        final responses = path.responses;
                                        _homeViewModel.setMockTerData(
                                            ActionsMockTerData.selectMockTer,
                                            environment: environment,
                                            path: path,
                                            response: responses.isNotEmpty
                                                ? path.responses.first
                                                : null);
                                      },
                                    ),
                                  );
                                },
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 2),
                                itemCount: paths.length,
                              )
                            : const SizedBox()),
                  ],
                ),
              ),
              Container(
                width: 4,
                color: Colors.grey.shade300,
              ),
              Expanded(
                child: Column(children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    width: size.width,
                    height: 38,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: DropdownButtonFormField<Methods?>(
                              isExpanded: true,
                              isDense: true,
                              decoration: customInputDecoration(),
                              value: path?.method,
                              items: Methods.values
                                  .map((e) => DropdownMenuItem<Methods>(
                                      value: e, child: Text(e.getName())))
                                  .toList(),
                              onChanged: (value) {
                                path?.method = value;
                              }),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: CustomTextFormField(_pathTextEditCtrl)),
                        const SizedBox(width: 14),
                        Ink(
                          child: InkWell(
                              customBorder: const CircleBorder(),
                              child: const Icon(
                                Icons.save,
                                color: Colors.blue,
                              ),
                              onTap: () {
                                if (environment != null &&
                                    path != null &&
                                    response != null) {
                                  path.path = _pathTextEditCtrl.text.trim();
                                  path.summary =
                                      _summaryTextEditCtrl.text.trim();
                                  _homeViewModel.updatePath(
                                      environment, path, response);
                                } else {
                                  showErrorDialog(context,
                                      description:
                                          'Error al actualizar el path');
                                }
                              }),
                        ),
                        const SizedBox(width: 14),
                        Ink(
                          child: InkWell(
                              customBorder: const CircleBorder(),
                              child: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onTap: () {
                                if (environment != null && path != null) {
                                  _homeViewModel.deletePath(environment, path);
                                } else {
                                  showErrorDialog(context,
                                      description: 'Error al eliminar el path');
                                }
                              }),
                        ),
                        const SizedBox(width: 14),
                      ],
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      height: 38,
                      child: CustomTextFormField(_summaryTextEditCtrl)),
                  const Divider(),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(children: [
                      Ink(
                        child: InkWell(
                          child: const Icon(Icons.add_box),
                          onTap: () {
                            if (environment != null && path != null) {
                              _homeViewModel.addResponse(environment, path);
                            } else {
                              showErrorDialog(context,
                                  description: 'Error al añadir respuesta');
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          height: 38,
                          child: DropdownButtonFormField<Response?>(
                              isExpanded: true,
                              isDense: true,
                              decoration: customInputDecoration(),
                              value: response,
                              items: responses
                                  ?.map((e) => DropdownMenuItem<Response>(
                                        value: e,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  '${e.responseCode} - ${e.responseDetails}'),
                                              Icon(e.active
                                                  ? Icons.flag
                                                  : Icons.flag_outlined),
                                            ]),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                _homeViewModel.setMockTerData(
                                    ActionsMockTerData.selectMockTer,
                                    environment: environment,
                                    path: path,
                                    response: value);
                              }),
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                      child: ResponsePage(
                          _homeViewModel, environment, path, response))
                ]),
              ),
            ],
          );
        });
  }
}

class ResponsePage extends StatelessWidget {
  final HomeViewModel _homeViewModel;
  final Environment? environment;
  final Path? path;
  final Response? response;

  ResponsePage(this._homeViewModel, this.environment, this.path, this.response,
      {Key? key})
      : super(key: key);

  final _statusCodeTextEditCtrl = TextEditingController();
  final _responseDetailsTextEditCtrl = TextEditingController();
  final _jsonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _statusCodeTextEditCtrl.text = (response?.responseCode ?? '').toString();
    _responseDetailsTextEditCtrl.text = response?.responseDetails ?? '';
    _jsonController.text = response?.response ?? '';
    return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: TabBar(tabs: [
                    Tab(
                        child: Text(
                      'Status & Body',
                      style: TextStyle(color: Colors.black54),
                    )),
                    Tab(
                        child: Text('Rules',
                            style: TextStyle(color: Colors.black54))),
                  ]),
                ),
                const SizedBox(width: 14),
                Ink(
                  child: InkWell(
                      customBorder: const CircleBorder(),
                      child: Icon(
                        (response?.active ?? false)
                            ? Icons.flag_rounded
                            : Icons.flag_outlined,
                      ),
                      onTap: () {
                        if (environment != null &&
                            path != null &&
                            response != null) {
                          response?.active = true;
                          response?.responseCode = int.tryParse(
                                  _statusCodeTextEditCtrl.text.trim()) ??
                              404;
                          response?.responseDetails =
                              _responseDetailsTextEditCtrl.text.trim();
                          final isJson =
                              checkJson(context, _jsonController.text.trim());
                          if (isJson) {
                            response?.response = _jsonController.text.trim();
                            _homeViewModel.updateResponse(
                                environment!, path!, response!);
                          } else {
                            response?.response = '';
                            _homeViewModel.updateResponse(
                                environment!, path!, response!);
                          }
                        } else {
                          showErrorDialog(context,
                              description: 'Error al actualizar response');
                        }
                      }),
                ),
                const SizedBox(width: 14),
                Ink(
                  child: InkWell(
                      customBorder: const CircleBorder(),
                      child: const Icon(
                        Icons.save,
                        color: Colors.blue,
                      ),
                      onTap: () {
                        if (environment != null &&
                            path != null &&
                            response != null) {
                          response?.responseCode = int.tryParse(
                                  _statusCodeTextEditCtrl.text.trim()) ??
                              404;
                          response?.responseDetails =
                              _responseDetailsTextEditCtrl.text.trim();
                          final isJson =
                              checkJson(context, _jsonController.text.trim());
                          if (isJson) {
                            response?.response = _jsonController.text.trim();
                            _homeViewModel.updateResponse(
                                environment!, path!, response!);
                          } else {
                            response?.response = '';
                            _homeViewModel.updateResponse(
                                environment!, path!, response!);
                          }
                        } else {
                          showErrorDialog(context,
                              description: 'Error al actualizar response');
                        }
                      }),
                ),
                const SizedBox(width: 14),
                Ink(
                  child: InkWell(
                      customBorder: const CircleBorder(),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      onTap: () {
                        if (environment != null &&
                            path != null &&
                            response != null) {
                          _homeViewModel.deleteResponse(
                              environment!, path!, response!);
                        } else {
                          showErrorDialog(context,
                              description: 'Error al eliminar response');
                        }
                      }),
                ),
                const SizedBox(width: 14),
              ],
            ),
            Expanded(
              child: TabBarView(children: [
                Center(
                    child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 100,
                              child: CustomTextFormField(
                                _statusCodeTextEditCtrl,
                                maxLines: 1,
                              )),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextFormField(
                              _responseDetailsTextEditCtrl,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTextFormField(_jsonController,
                            minLines: 40,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            paddingVertical: 10),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10, right: 10),
                        child: ElevatedButton(
                            onPressed: () {
                              checkJson(
                                  context, _jsonController.text.trim());
                            },
                            child: const Text('Format')),
                      ),
                    )
                  ],
                )),
                const Center(child: Text('Comming soon')),
              ]),
            )
          ],
        ));
  }

  bool checkJson(BuildContext context, String jsonString) {
    if (jsonString.isNotEmpty) {
      try {
        final json = jsonDecode(jsonString);
        final prettyJson = _prettifyJson(json);
        _jsonController.text = prettyJson;
        return true;
      } on FormatException catch (_) {
        showErrorDialog(context, description: 'No es un JSON valido');
        return false;
      }
    }
    return true;
  }

  String _prettifyJson(dynamic json) {
    var spaces = ' ' * 4;
    var encoder = JsonEncoder.withIndent(spaces);
    return encoder.convert(json);
  }
}
