import 'package:flutter/material.dart';
import 'game_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = "X";
  bool gameOver = false;
  int turn = 0;
  String result = "";
  Game game = Game();
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: MediaQuery.of(context).orientation == Orientation.portrait
              ? Column(
                  children: <Widget>[
                    ...switchAndActivePlayer(),
                    buildSquares(context),
                    ...winnerAndReplay(), // used ... to get the elements of the list
                  ],
                )
              : Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ...switchAndActivePlayer(),
                          ...winnerAndReplay(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: (MediaQuery.of(context).size.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom) *
                          0.95,
                      child: buildSquares(context),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  List<Widget> switchAndActivePlayer() {
    return [
      SwitchListTile.adaptive(
        title: Text(
          "Turn on two players mode",
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        value: isSwitched,
        onChanged: (bool newVal) {
          setState(() {
            isSwitched = newVal;
          });
        },
        activeColor: Theme.of(context).splashColor,
      ),
      Text(
        "it's $activePlayer turn".toUpperCase(),
        style: Theme.of(context).textTheme.headlineLarge,
        textAlign: TextAlign.center,
      ),
    ];
  }

  List<Widget> winnerAndReplay() {
    return [
      Text(
        result,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20),
      Container(
        margin: const EdgeInsets.only(bottom: 40),
        child: ElevatedButton.icon(
          onPressed: () {
            setState(() {
              Player.playerX = [];
              Player.playerO = [];
              activePlayer = "X";
              gameOver = false;
              turn = 0;
              result = "";
            });
          },
          icon: const Icon(Icons.replay),
          label: const Text(
            "Replay",
            textAlign: TextAlign.center,
          ),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).splashColor),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 90, vertical: 15)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
            textStyle: MaterialStateProperty.all(
              const TextStyle(
                fontSize: 20,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  Expanded buildSquares(BuildContext context) {
    return Expanded(
      child: GridView.count(
        // Grid View is 3 * 3 (crossAxis/MainAxis: each = 3)
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.0,
        padding: const EdgeInsets.all(16),
        children: List.generate(
            9,
            (index) => InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: gameOver ? null : () => _onTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).shadowColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        Player.playerX.contains(index)
                            ? 'X'
                            : Player.playerO.contains(index)
                                ? 'O'
                                : '',
                        style: TextStyle(
                          fontSize: 52,
                          color: Player.playerX.contains(index)
                              ? Colors.blue
                              : const Color.fromARGB(255, 255, 0, 85),
                        ),
                      ),
                    ),
                  ),
                )),
      ),
    );
  }

  _onTap(int index) async {
// =========== two players mode ================
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();
    }

// =========== auto play ================
    if (!isSwitched && !gameOver && turn != 9) {
      await game.autoPlay(activePlayer);
      updateState();
    }
  }

  void updateState() {
    return setState(() {
      activePlayer = (activePlayer == 'X') ? 'O' : 'X';
      turn++;

      String winnerPlayer = game.checkWinner();
      if (winnerPlayer != '') {
        gameOver = true;
        result = "$winnerPlayer is the winner";
      } else if (!gameOver && turn == 9) {
        result = "It's Draw";
      }
    });
  }
}
