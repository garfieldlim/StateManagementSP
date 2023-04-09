import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    debugShowCheckedModeBanner: true,
    home: const HomePage(),
  ));
}

class SliderData extends ChangeNotifier {
  double _value = 0.0;
  double get value => _value;
  set value(double newValue) {
    if (newValue != value) {
      _value = newValue;
      notifyListeners();
    }
  }
}

final sliderData = SliderData();

class SliderInheritedNotifier extends InheritedNotifier<SliderData> {
  const SliderInheritedNotifier(
      {Key? key, required SliderData sliderData, required Widget child})
      : super(
          key: key,
          notifier: sliderData,
          child: child,
        );

  static double of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<SliderInheritedNotifier>()
          ?.notifier
          ?.value ??
      0.0;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home Page'),
      ),
      body: SliderInheritedNotifier(
        sliderData: sliderData,
        child: Builder(
          builder: (context) {
            return Column(
              children: [
                Slider(
                    value: SliderInheritedNotifier.of(context),
                    onChanged: (value) {
                      sliderData.value = value;
                    }),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Opacity(
                      opacity: SliderInheritedNotifier.of(context),
                      child: Container(
                        color: Colors.yellow,
                        height: 200,
                      ),
                    ),
                    Opacity(
                      opacity: SliderInheritedNotifier.of(context),
                      child: Container(
                        color: Colors.blue,
                        height: 200,
                      ),
                    )
                  ].expandEqually().toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

extension ExpandEqually on Iterable<Widget> {
  Iterable<Widget> expandEqually() => map((w) => Expanded(
        child: w,
      ));
}
