import 'package:context_menu_macos/context_menu_macos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: ContextMenuExample(),
      ),
    );
  }
}

class ContextMenuExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onSecondaryTapDown: (details) {
              showMacosContextMenu(
                context: context,
                globalPosition: details.globalPosition,
                children: [
                  MacosContextMenuItem(
                    content: Text('Copy'),
                    trailing: Text('⌘ C'),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  MacosContextMenuItem(
                    content: Text('Paste'),
                    trailing: Text('⌘ V'),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  MacosContextMenuItem(
                    content: Text('Select All'),
                    trailing: Text('⌘ A'),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  MacosContextMenuDivider(),
                  MacosContextMenuItem(
                    content: Text('Clear'),
                    trailing: Text('⌘ K'),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  MacosContextMenuDivider(),
                  MacosContextMenuItem(
                    content: Text('Kill'),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            },
            child: Container(
              width: 100,
              height: 70,
              color: Colors.blue,
              child: Text('click me'),
            ),
          ),
        ],
      ),
    );
  }
}
