import 'package:flutter/material.dart';
import 'package:mockter/application/dependency_injection.dart';
import 'package:mockter/domain/model/mockter.dart';
import 'package:mockter/presentation/common/dialogs/mockter_dialogs.dart';
import 'package:mockter/presentation/home/home_viewmodel.dart';
import 'package:mockter/presentation/home/pages/logs.dart';
import 'package:mockter/presentation/home/pages/routes.dart';
import 'package:mockter/presentation/home/pages/settings.dart';
import 'package:mockter/presentation/home/widgets/custom_text_form_field.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _searchEnviromentTextEditCtrl = TextEditingController();

  final _homeViewModel = getIt<HomeViewModel>();

  @override
  void initState() {
    _homeViewModel.start();
    super.initState();
  }

  double _width = 160.0;
  final double _minWidth = 140.0;
  final double _maxWidth = 180.0;
  bool _isHovering = false;

  @override
  void dispose() {
    _homeViewModel.finish();
    _searchEnviromentTextEditCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<MockTer?>(
          stream: _homeViewModel.mockTerOutput,
          builder: (_, snapshot) {
            final mockTer = snapshot.data;
            final environments = mockTer?.environments;
            return Column(
              children: [
                Container(
                  width: size.width,
                  color: Colors.grey.shade200,
                  child: Row(
                    children: [
                      PopupMenuButton(
                        itemBuilder: (_) => [
                          const PopupMenuItem(child: Text('Acerca de')),
                          const PopupMenuItem(child: Text('Salir'))
                        ],
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Aplicación'),
                        ),
                      ),
                      PopupMenuButton<String>(
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: 'importar',
                            child: Text('Importar'),
                          ),
                          const PopupMenuItem(
                            value: 'exportar',
                            child: Text('Exportar'),
                          )
                        ],
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Importar/Exportar'),
                        ),
                        onSelected: (value) {
                          switch (value) {
                            case 'importar':
                              _homeViewModel.selectFile();
                              break;
                            case 'exportar':
                              break;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                StreamBuilder<Server?>(
                    stream: _homeViewModel.serverRunningOutput,
                    builder: (_, snapshot) {
                      final server = snapshot.data;
                      return AnimatedContainer(
                        color: Colors.green,
                        width: size.width,
                        height: server != null ? 20 : 0,
                        duration: const Duration(milliseconds: 800),
                        child: Center(
                          child: Text(
                            'RUNNING SERVER  /  environment: ${server?.environmentName}  /  host: ${server?.host}  /  port: ${server?.port}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }),
                Expanded(
                  child: StreamBuilder<MockTerData?>(
                      stream: _homeViewModel.mockTerDataOutput,
                      builder: (_, snapshot) {
                        final environment = snapshot.data?.environment;
                        final environmentName = environment?.title;
                        final environmentId = environment?.id;
                        print(environmentId);
                        return Row(
                          children: [
                            SizedBox(
                              width: _width,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Ink(
                                            child: InkWell(
                                              child: const Icon(Icons.add_box),
                                              onTap: () {
                                                _homeViewModel.addEnvironment();
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: _width - 60,
                                            height: 30,
                                            child: CustomTextFormField(
                                                _searchEnviromentTextEditCtrl),
                                          )
                                        ]),
                                  ),
                                  Expanded(
                                    child: environments != null
                                        ? ListView.separated(
                                            itemBuilder: (_, index) {
                                              final environment =
                                                  environments[index];
                                              return Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        left: BorderSide(
                                                            color: environmentId ==
                                                                    environment
                                                                        .id
                                                                ? Colors.blue
                                                                : Colors
                                                                    .transparent,
                                                            width: 4))),
                                                child: ListTile(
                                                  title: Text(environment.title,
                                                      maxLines: 1),
                                                  subtitle: Text(
                                                      environment.description,
                                                      maxLines: 1),
                                                  onTap: () {
                                                    final paths =
                                                        environment.paths;
                                                    final path =
                                                        paths.isNotEmpty
                                                            ? paths.first
                                                            : null;
                                                    final responses =
                                                        path?.responses;
                                                    final response = (responses
                                                                ?.isNotEmpty ??
                                                            false)
                                                        ? responses?.first
                                                        : null;
                                                    _homeViewModel
                                                        .setMockTerData(
                                                            ActionsMockTerData
                                                                .selectMockTer,
                                                            environment:
                                                                environment,
                                                            path: path,
                                                            response: response);
                                                  },
                                                ),
                                              );
                                            },
                                            separatorBuilder: (_, __) =>
                                                const Divider(height: 2),
                                            itemCount: environments.length,
                                          )
                                        : const SizedBox(),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onPanUpdate: (DragUpdateDetails details) {
                                setState(() {
                                  _width += details.delta.dx;
                                  _width = _width.clamp(_minWidth,
                                      _maxWidth); // Limita el rango de ancho
                                });
                              },
                              child: MouseRegion(
                                onEnter: (_) {
                                  setState(() {
                                    _isHovering = true;
                                  });
                                },
                                onExit: (_) {
                                  setState(() {
                                    _isHovering = false;
                                  });
                                },
                                child: Container(
                                  width: _isHovering ? 6 : 4,
                                  color: _isHovering
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ),
                            Expanded(
                                child: DefaultTabController(
                                    length: 3,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(width: 14),
                                            StreamBuilder<Server?>(
                                                stream: _homeViewModel
                                                    .serverRunningOutput,
                                                builder: (_, snapshot) {
                                                  final server = snapshot.data;
                                                  return Ink(
                                                    child: InkWell(
                                                      customBorder:
                                                          const CircleBorder(),
                                                      child: Icon(
                                                        server != null
                                                            ? Icons.stop
                                                            : Icons.play_arrow,
                                                        color: server != null
                                                            ? Colors.red
                                                            : Colors.green,
                                                      ),
                                                      onTap: () {
                                                        if (server != null) {
                                                          _homeViewModel
                                                              .stopServer();
                                                        } else {
                                                          if (environmentId !=
                                                              null) {
                                                            _homeViewModel
                                                                .startServer(
                                                                    Server(
                                                              environmentName:
                                                                  environmentName ??
                                                                      '',
                                                              environmentId:
                                                                  environmentId,
                                                              host: mockTer
                                                                      ?.host ??
                                                                  '127.0.0.1',
                                                              port: mockTer
                                                                      ?.port ??
                                                                  7001,
                                                            ));
                                                          } else {
                                                            showErrorDialog(
                                                                context,
                                                                description:
                                                                    'No se pudo iniciar el servidor');
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  );
                                                }),
                                            const SizedBox(width: 14),
                                            Expanded(
                                              child: TabBar(tabs: [
                                                Tab(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Icon(Icons.route_sharp,
                                                          color:
                                                              Colors.black54),
                                                      SizedBox(width: 5),
                                                      Text('Routes',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54))
                                                    ],
                                                  ),
                                                ),
                                                Tab(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Icon(
                                                          Icons.playlist_remove,
                                                          color:
                                                              Colors.black54),
                                                      SizedBox(width: 5),
                                                      Text('Logs',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54))
                                                    ],
                                                  ),
                                                ),
                                                Tab(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Icon(Icons.settings,
                                                          color:
                                                              Colors.black54),
                                                      SizedBox(width: 5),
                                                      Text('Settings',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54))
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                            child: TabBarView(children: [
                                          RoutesPage(_homeViewModel),
                                          LogsPage(_homeViewModel),
                                          SettingsPage(_homeViewModel,
                                              mockTer?.host, mockTer?.port)
                                        ])),
                                      ],
                                    )))
                          ],
                        );
                      }),
                ),
              ],
            );
          }),
    );
  }
}
