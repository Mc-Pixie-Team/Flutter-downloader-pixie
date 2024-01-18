import 'dart:convert';
import 'dart:io';

import 'package:fldownloaderpixie/src/discord.dart';
import 'package:fldownloaderpixie/src/downloader.dart';
import 'package:fldownloaderpixie/src/utils.dart';
import 'package:fldownloaderpixie/src/zip.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:markdown_widget/markdown_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Downloader _downloader = Downloader(
      "https://cdn.azul.com/zulu/bin/zulu17.44.53-ca-jdk17.0.8.1-win_x64.zip",
      "C:\\Users\\joshi\\Documents\\PixieLauncherInstances\\download.zip");

  void _incrementCounter() async {
    print('starting donwload');
    //  await _downloader.startDownload(onProgress: (p0) => print(p0),);
    //  await _downloader.unzipSingleFile(entryname: "zulu17.44.53-ca-jdk17.0.8.1-win_x64/Welcome.html");
    //   await _downloader.unzip(deleteOld: true);
    await Utils.copyDirectory(
        destination: Directory(
            "C:\\Users\\joshi\\Documents\\PixieLauncherInstances\\new"),
        source: Directory(
            "C:\\Users\\joshi\\Documents\\PixieLauncherInstances\\instance"));
    print("done downloading");
    // await Utils.copyFile(source: File("C:\\Users\\joshi\\Documents\\PixieLauncherInstances\\Welcome.html"), destination: File("C:\\Users\\joshi\\Documents\\PixieLauncherInstances\\Welcome2.html"));
    //DC().at();
  }

  RectTween _createRectTween(Rect? begin, Rect? end) {
    return MaterialRectArcTween(begin: begin, end: end);
  }
      Future<Map<String, dynamic>> _getModpack(String id) async {
    var res = await http.get(Uri.parse('https://api.modrinth.com/v2/project/$id'));
    return jsonDecode(utf8.decode(res.bodyBytes));
  }
  Future<String> getData() async{
    Map versions = await _getModpack("1KVo5zza");
    return versions["body"];
  }

  late BuildContext innercontext;

  Navigator _getNavigator(BuildContext context) {
    return Navigator(
      observers: [HeroController(createRectTween: _createRectTween)],
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) {
          innercontext = context;
          return Center(
              child: Column(children: [
            TextButton(
                onPressed: () {
                  Navigator.of(innercontext)
                      .push(CustomPageRoute(builder: (context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Flippers Page'),
                      ),
                      body: Container(
                          // Set background to blue to emphasize that it's a new route.
                       
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.topLeft,
                          child:  FutureBuilder(future: getData(), builder: (context, snapshot) => snapshot.data != null ? MarkdownWidget(
                                data: snapshot.data!) : Container()
                          ),
                    ));
                  }));
                },
                child: Text("test")),
            PhotoHero(
              photo: 'assets/images/flippers-alpha.png',
              width: 300.0,
              onTap: () {},
            )
          ]));
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_downloader.getDir()),
      ),
      body: _getNavigator(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class PhotoHero extends StatelessWidget {
  const PhotoHero({
    super.key,
    required this.photo,
    this.onTap,
    required this.width,
  });

  final String photo;
  final VoidCallback? onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.asset(
              photo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomPageRoute extends MaterialPageRoute {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 1000);

  CustomPageRoute({builder}) : super(builder: builder);
}
