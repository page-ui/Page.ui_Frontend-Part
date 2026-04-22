import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pageui/config/routes/on_generate_routes.dart';

class TrainView extends StatelessWidget {
  const TrainView({super.key});
  static String routeName = "TrainView";
  @override
  Widget build(BuildContext context) {
    return const SlOriginalCommand();
  }
}

class SlOriginalCommand extends StatefulWidget {
  const SlOriginalCommand({super.key});

  @override
  State<SlOriginalCommand> createState() => _SlOriginalCommandState();
}

class _SlOriginalCommandState extends State<SlOriginalCommand>
    with SingleTickerProviderStateMixin {
  late final AnimationController _moveController;
  late Animation<double> _moveAnimation;
  Timer? _ticker;
  int _pattern = 0;
  final List<_SlSmoke> _smokeStack = [];

  final List<String> _d51str = [
    r"      ====        ________                ___________ ",
    r"  _D _|  |_______/        \__I_I_____===__|_________| ",
    r"   |(_)---  |   H\________/ |   |        =|___ ___|   ",
    r"   /     |  |   H  |  |     |   |         ||_| |_||   ",
    r"  |      |  |   H  |__--------------------| [___] |   ",
    r"  | ________|___H__/__|_____/[][]~\_______|       |   ",
    r"  |/ |   |-----------I_____I [][] []  D   |=======|__ ",
  ];

  final List<List<String>> _d51wheel = [
    [
      r"__/ =| o |=-~~\  /~~\  /~~\  /~~\ ____Y___________|__ ",
      r" |/-=|___|=    ||    ||    ||    |_____/~\___/        ",
      r"  \_/      \O=====O=====O=====O_/      \_/            ",
    ],
    [
      r"__/ =| o |=-~~\  /~~\  /~~\  /~~\ ____Y___________|__ ",
      r" |/-=|___|=O=====O=====O=====O   |_____/~\___/        ",
      r"  \_/      \__/  \__/  \__/  \__/      \_/            ",
    ],
    [
      r"__/ =| o |=-O=====O=====O=====O \ ____Y___________|__ ",
      r" |/-=|___|=    ||    ||    ||    |_____/~\___/        ",
      r"  \_/      \__/  \__/  \__/  \__/      \_/            ",
    ],
    [
      r"__/ =| o |=-~O=====O=====O=====O\ ____Y___________|__ ",
      r" |/-=|___|=    ||    ||    ||    |_____/~\___/        ",
      r"  \_/      \__/  \__/  \__/  \__/      \_/            ",
    ],
    [
      r"__/ =| o |=-~~\  /~~\  /~~\  /~~\ ____Y___________|__ ",
      r" |/-=|___|=    O=====O=====O=====O|_____/~\___/        ",
      r"  \_/      \__/  \__/  \__/  \__/      \_/            ",
    ],
    [
      r"__/ =| o |=-~~\  /~~\  /~~\  /~~\ ____Y___________|__ ",
      r" |/-=|___|=    ||    ||    ||    |_____/~\___/        ",
      r"  \_/      \_O=====O=====O=====O/      \_/            ",
    ],
  ];

  final List<String> _coal = [
    r"                              ",
    r"                              ",
    r"    _________________         ",
    r"   _|                \_____A  ",
    r"  =|                       |  ",
    r"  -|                       |  ",
    r" __|_______________________|_ ",
    r"|__________________________|_ ",
    r"   |_D__D__D_|  |_D__D__D_|   ",
    r"    \_/   \_/    \_/   \_/    ",
  ];

  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..forward();
    _moveController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        AppRoutes.pushHomeView(context);
      }
    });
    _moveController.forward();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;
      setState(() {
        _pattern = (_pattern + 1) % 6;
        _updateSmoke();
      });
    });
  }

  void _updateSmoke() {
    if (_pattern % 2 == 0) {
      _smokeStack.add(_SlSmoke(x: 75, y: -15));
    }
    for (var s in _smokeStack) {
      s.age++;
      s.y -= 10;
      s.x += 8;
    }
    _smokeStack.removeWhere((s) => s.age > 20);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _moveAnimation = Tween<double>(
      begin: MediaQuery.of(context).size.width,
      end: -1300,
    ).animate(CurvedAnimation(parent: _moveController, curve: Curves.linear));
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _moveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.7),
      body: AnimatedBuilder(
        animation: _moveAnimation,
        builder: (context, _) {
          double x = _moveAnimation.value;
          double y = MediaQuery.of(context).size.height * 0.4;

          return Stack(
            children: [
              ..._smokeStack.map(
                (s) => Positioned(
                  left: x + s.x,
                  top: y + s.y,
                  child: Text(
                    s.getSymbol(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Positioned(
                left: x,
                top: y,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(10, (i) {
                    String engine = (i < 7)
                        ? _d51str[i]
                        : _d51wheel[_pattern][i - 7];
                    String trainLine = engine + _coal[i];
                    return Text(
                      trainLine,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.1,
                        letterSpacing: 0,
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SlSmoke {
  double x, y;
  int age = 0;
  _SlSmoke({required this.x, required this.y});

  String getSymbol() {
    if (age < 4) return "( )";
    if (age < 8) return "(oo)";
    if (age < 12) return "(OO)";
    return "(  )";
  }
}
