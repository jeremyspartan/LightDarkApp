import 'package:app_clase_7/app_theme.dart';
import 'package:app_clase_7/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'component/wire_draw.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Offset initialPos = const Offset(250, 0);
  Offset switchPos = const Offset(350, 350);
  Offset containerPos = const Offset(350, 350);
  Offset finalPos = const Offset(350, 350);

  @override
  void didChangeDependencies() {
    final Size size = MediaQuery.of(context).size;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    initialPos = Offset(size.width * 0.9, 0);
    containerPos = Offset(size.width * 0.9, size.height * .4);
    finalPos = Offset(size.width * 0.9, size.height * .5 - size.width * .1);
    if (themeProvider.isLightTheme) {
      switchPos = containerPos;
    } else {
      switchPos = finalPos;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(-0.8, -0.3),
          radius: 1,
          colors: themeProvider.themeMode().gradientColors!,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          leftPart(context, size, themeProvider),
          Positioned(
            top: containerPos.dy - size.width * 0.1 / 2 - 5,
            left: containerPos.dx - size.width * 0.1 / 2 - 5,
            child: Container(
              width: size.width * 0.1 + 10,
              height: size.height * 0.1 + 10,
              decoration: BoxDecoration(
                  color: themeProvider.themeMode().switchBgColor!,
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
          Wire(initialPosition: initialPos, toOffset: switchPos),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 0),
            top: switchPos.dy - size.width * 0.1 / 2,
            left: switchPos.dx - size.width * 0.1 / 2,
            child: Draggable(
              feedback: Container(
                width: size.width * .1,
                height: size.width * .1,
                decoration: const BoxDecoration(
                    color: Colors.transparent, shape: BoxShape.circle),
              ),
              onDragEnd: (details) {
                if (themeProvider.isLightTheme) {
                  setState(() {
                    switchPos = containerPos;
                  });
                } else {
                  setState(() {
                    switchPos = finalPos;
                  });
                }
                themeProvider.toggleThemeData();
              },
              onDragUpdate: (details) {
                setState(() {
                  switchPos = details.localPosition;
                });
              },
              child: Container(
                width: size.width * .1,
                height: size.width * .1,
                decoration: BoxDecoration(
                  color: themeProvider.themeMode().thumbColor,
                  border: Border.all(
                      width: 5,
                      color: themeProvider.themeMode().switchBgColor!),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  SafeArea leftPart(
      BuildContext context, Size size, ThemeProvider themeProvider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('j').format(DateTime.now()),
                style: Theme.of(context).textTheme.displayLarge),
            SizedBox(
              width: size.width * .2,
              child: const Divider(
                  height: 0, thickness: 1, color: AppColors.withe),
            ),
            Text(DateFormat('m').format(DateTime.now()),
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(color: AppColors.withe)),
            const Spacer(),
            const Text("Light Dark\nPersonal\nSwitch",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const Spacer(),
            Container(
              width: size.width * .2,
              height: size.width * .2,
              decoration: BoxDecoration(
                  color: themeProvider.themeMode().switchColor,
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.nights_stay_outlined,
                  size: 50, color: AppColors.withe),
            ),
            SizedBox(
              width: size.width * .2,
              child: const Divider(
                  //height: 0,
                  thickness: 1,
                  color: AppColors.withe),
            ),
            Text("30\u00B0C",
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: AppColors.withe)),
            Text("Clear", style: Theme.of(context).textTheme.titleLarge),
            Text(DateFormat('EEEE').format(DateTime.now()),
                style: Theme.of(context).textTheme.titleLarge),
            Text(DateFormat('MMM d').format(DateTime.now()),
                style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
