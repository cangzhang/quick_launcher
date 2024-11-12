import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:skeletonizer/skeletonizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Launcher',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'App List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<AppInfo> _apps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getApps();
  }

  Future<void> getApps() async {
    List<AppInfo> apps = await InstalledApps.getInstalledApps(false, true);
    setState(() {
      _apps = apps;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Skeletonizer(
        enabled: _isLoading,
        child: ListView.builder(
          itemCount: _isLoading ? 10 : _apps.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: _isLoading
                    ? CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 25,
                      )
                    : _apps[index].icon != null
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Image.memory(
                              _apps[index].icon!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                            ),
                          )
                        : const Icon(
                            Icons.android,
                            size: 50,
                            color: Colors.grey,
                          ),
                title: Text(_isLoading ? 'App Name' : _apps[index].name),
                subtitle: Text(
                    _isLoading ? 'Package Name' : _apps[index].packageName),
                onTap: () async {
                  // Launch the app when tapped
                  final app = _apps[index];
                  await InstalledApps.startApp(app.packageName);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
