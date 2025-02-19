import 'package:flutter/material.dart';
import 'package:my_bus_new/pages/settings.dart';
import 'package:my_bus_new/pages/station.dart';
import 'package:my_bus_new/settings_handler.dart';
import 'package:my_bus_new/widgets/next_bus.dart';
import 'package:my_bus_new/widgets/tab_controler.dart';
import 'package:my_bus_new/stations.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StationLoader.loadStations();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/settings': (context) => const Settings(),
        // Add more routes as needed
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
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

        colorScheme: ColorScheme(
            brightness: Brightness.dark,
            primary: Colors.blue.shade800,
            secondary: Colors.blueGrey.shade800,
            background: Colors.blueGrey.shade900,
            onPrimary: Colors.white,
            onBackground: Colors.white,
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            onSurface: Colors.white,
            onErrorContainer: Colors.red.shade800,
            onInverseSurface: Colors.black,
            onPrimaryContainer: Colors.white,
            onSecondaryContainer: Colors.blueGrey.shade700,
            onSurfaceVariant: Colors.white,
            onTertiary: Colors.white,
            onTertiaryContainer: Colors.blueGrey.shade500,
            outline: Colors.blue,
            outlineVariant: Colors.blue,
            surface: Colors.blueGrey.shade700),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  NextBus fromHome = NextBus(label: "home", line: "3G", key: const Key("home"));
  NextBus fromWork = NextBus(label: "work", line: "3G", key: const Key("work"));
  String line = StationLoader.lines[0];
  Stations stations = Stations(
    key: const Key("stations"),
    station: StationLoader.stations.first,
  );
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      line = await SettingsHandler.get("line") ?? StationLoader.lines[0];
      fromHome = NextBus(label: "home", line: line, key: const Key("home"));
      fromWork = NextBus(label: "work", line: line, key: const Key("work"));

      setState(() {
        fromHome = fromHome;
        fromWork = fromWork;
        line = line;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: DefaultTabControllerListener(
        onTabSelected: (index) async {},
        child: Scaffold(
          appBar: AppBar(
            title: const Text("My Bus"),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, "/settings");
                },
              ),
            ],
            backgroundColor: Colors.blueGrey.shade900,
          ),
          bottomNavigationBar: const TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.work)),
              Tab(icon: Icon(Icons.bus_alert)),
            ],
          ),
          body: TabBarView(
            children: [fromHome, fromWork, stations],
          ),
        ),
      ),
    );
  }
}
