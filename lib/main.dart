import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_games_demo/normal_games_page.dart';

void main() {
  runApp(const SeniorGamesApp());
}

class SeniorGamesApp extends StatelessWidget {
  const SeniorGamesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '長者趣味闖關',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 22, height: 1.4),
          bodyMedium: TextStyle(fontSize: 20, height: 1.35),
          labelLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(150, 60),
            textStyle: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      home: const DifficultyHomePage(),
    );
  }
}

class DifficultyHomePage extends StatelessWidget {
  const DifficultyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('長者趣味闖關')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '請先選擇難度',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  '簡易：現有的基礎闖關。普通：圖像化 Flame 小遊戲。',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const GameHubPage()),
                    );
                  },
                  child: const Text('簡易模式'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const NormalGameHubPage(),
                      ),
                    );
                  },
                  child: const Text('普通模式'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GameHubPage extends StatefulWidget {
  const GameHubPage({super.key});

  @override
  State<GameHubPage> createState() => _GameHubPageState();
}

class _GameHubPageState extends State<GameHubPage> {
  final Map<int, bool> _completion = {for (int i = 1; i <= 10; i++) i: false};

  void _setCompleted(int gameId, bool isCompleted) {
    if (_completion[gameId] == isCompleted) {
      return;
    }
    setState(() {
      _completion[gameId] = isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int completed = _completion.values.where((v) => v).length;

    return Scaffold(
      appBar: AppBar(title: const Text('長者趣味闖關：10 小遊戲')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  '完成進度：$completed / 10',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '每一關都很簡單，適合手機與平板闖關。',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                GameCard(
                  index: 1,
                  title: '連續點擊 10 下',
                  child: TapCounterGame(
                    onCompletionChanged: (v) => _setCompleted(1, v),
                  ),
                ),
                GameCard(
                  index: 2,
                  title: '數字排序 1 到 5',
                  child: NumberOrderGame(
                    onCompletionChanged: (v) => _setCompleted(2, v),
                  ),
                ),
                GameCard(
                  index: 3,
                  title: '顏色配對',
                  child: ColorMatchGame(
                    onCompletionChanged: (v) => _setCompleted(3, v),
                  ),
                ),
                GameCard(
                  index: 4,
                  title: '表情記憶',
                  child: EmojiMemoryGame(
                    onCompletionChanged: (v) => _setCompleted(4, v),
                  ),
                ),
                GameCard(
                  index: 5,
                  title: '滑桿對準目標',
                  child: SliderTargetGame(
                    onCompletionChanged: (v) => _setCompleted(5, v),
                  ),
                ),
                GameCard(
                  index: 6,
                  title: '找出不同',
                  child: OddOneOutGame(
                    onCompletionChanged: (v) => _setCompleted(6, v),
                  ),
                ),
                GameCard(
                  index: 7,
                  title: '是非題 3 連勝',
                  child: YesNoQuizGame(
                    onCompletionChanged: (v) => _setCompleted(7, v),
                  ),
                ),
                GameCard(
                  index: 8,
                  title: '簡單加法',
                  child: QuickMathGame(
                    onCompletionChanged: (v) => _setCompleted(8, v),
                  ),
                ),
                GameCard(
                  index: 9,
                  title: '呼吸節奏：吸氣 / 吐氣',
                  child: BreathingGame(
                    onCompletionChanged: (v) => _setCompleted(9, v),
                  ),
                ),
                GameCard(
                  index: 10,
                  title: '反應力測試',
                  child: ReactionGame(
                    onCompletionChanged: (v) => _setCompleted(10, v),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.index,
    required this.title,
    required this.child,
  });

  final int index;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '第 $index 關：$title',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class StatusLine extends StatelessWidget {
  const StatusLine({super.key, required this.completed, required this.text});

  final bool completed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          completed ? Icons.check_circle : Icons.radio_button_unchecked,
          color: completed ? Colors.green : Colors.grey,
          size: 30,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}

class TapCounterGame extends StatefulWidget {
  const TapCounterGame({super.key, required this.onCompletionChanged});

  final ValueChanged<bool> onCompletionChanged;

  @override
  State<TapCounterGame> createState() => _TapCounterGameState();
}

class _TapCounterGameState extends State<TapCounterGame> {
  int _count = 0;
  bool _complete = false;

  void _updateComplete(bool value) {
    if (_complete == value) {
      return;
    }
    _complete = value;
    widget.onCompletionChanged(value);
  }

  void _tap() {
    setState(() {
      _count++;
      _updateComplete(_count >= 10);
    });
  }

  void _reset() {
    setState(() {
      _count = 0;
      _updateComplete(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('目標：按下按鈕 10 次', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        StatusLine(completed: _complete, text: '目前 $_count / 10'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton(onPressed: _tap, child: const Text('按一下')),
            OutlinedButton(
              onPressed: _reset,
              style: OutlinedButton.styleFrom(minimumSize: const Size(120, 60)),
              child: const Text('重來', style: TextStyle(fontSize: 22)),
            ),
          ],
        ),
      ],
    );
  }
}

class NumberOrderGame extends StatefulWidget {
  const NumberOrderGame({super.key, required this.onCompletionChanged});

  final ValueChanged<bool> onCompletionChanged;

  @override
  State<NumberOrderGame> createState() => _NumberOrderGameState();
}

class _NumberOrderGameState extends State<NumberOrderGame> {
  final Random _random = Random();
  List<int> _numbers = [1, 2, 3, 4, 5];
  int _expected = 1;
  bool _complete = false;

  @override
  void initState() {
    super.initState();
    _numbers.shuffle(_random);
  }

  void _setComplete(bool value) {
    if (_complete == value) {
      return;
    }
    _complete = value;
    widget.onCompletionChanged(value);
  }

  void _press(int value) {
    setState(() {
      if (value == _expected) {
        _expected++;
        if (_expected == 6) {
          _setComplete(true);
        }
      } else {
        _expected = 1;
        _setComplete(false);
      }
    });
  }

  void _reset() {
    setState(() {
      _numbers = [1, 2, 3, 4, 5]..shuffle(_random);
      _expected = 1;
      _setComplete(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '請依序點：1 → 2 → 3 → 4 → 5',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        StatusLine(
          completed: _complete,
          text: _complete ? '完成！' : '下一個要點：$_expected',
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final n in _numbers)
              ElevatedButton(
                onPressed: _complete ? null : () => _press(n),
                child: Text('$n'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: _reset,
          style: OutlinedButton.styleFrom(minimumSize: const Size(120, 60)),
          child: const Text('重新排列', style: TextStyle(fontSize: 22)),
        ),
      ],
    );
  }
}

class ColorMatchGame extends StatefulWidget {
  const ColorMatchGame({super.key, required this.onCompletionChanged});

  final ValueChanged<bool> onCompletionChanged;

  @override
  State<ColorMatchGame> createState() => _ColorMatchGameState();
}

class _ColorMatchGameState extends State<ColorMatchGame> {
  final Random _random = Random();
  final Map<String, Color> _colors = {
    '紅色': Colors.red,
    '藍色': Colors.blue,
    '綠色': Colors.green,
    '橘色': Colors.orange,
    '黃色': Colors.yellow,
  };

  late String _target;
  late List<String> _options;
  int _score = 0;
  bool _complete = false;

  @override
  void initState() {
    super.initState();
    _nextRound();
  }

  void _setComplete(bool value) {
    if (_complete == value) {
      return;
    }
    _complete = value;
    widget.onCompletionChanged(value);
  }

  void _nextRound() {
    final keys = _colors.keys.toList();
    _target = keys[_random.nextInt(keys.length)];
    final others = keys.where((k) => k != _target).toList()..shuffle(_random);
    _options = [_target, ...others.take(2)]..shuffle(_random);
  }

  void _choose(String choice) {
    setState(() {
      if (choice == _target) {
        _score++;
      } else {
        _score = max(0, _score - 1);
      }
      if (_score >= 3) {
        _setComplete(true);
      } else {
        _setComplete(false);
        _nextRound();
      }
    });
  }

  void _reset() {
    setState(() {
      _score = 0;
      _setComplete(false);
      _nextRound();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '看色塊，選出正確顏色名稱（累積 3 分）',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        Container(
          width: 180,
          height: 80,
          decoration: BoxDecoration(
            color: _colors[_target],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 8),
        StatusLine(
          completed: _complete,
          text: _complete ? '完成！' : '目前分數：$_score / 3',
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final option in _options)
              ElevatedButton(
                onPressed: _complete ? null : () => _choose(option),
                child: Text(option),
              ),
          ],
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: _reset,
          style: OutlinedButton.styleFrom(minimumSize: const Size(120, 60)),
          child: const Text('重置', style: TextStyle(fontSize: 22)),
        ),
      ],
    );
  }
}

class EmojiMemoryGame extends StatefulWidget {
  const EmojiMemoryGame({super.key, required this.onCompletionChanged});

  final ValueChanged<bool> onCompletionChanged;

  @override
  State<EmojiMemoryGame> createState() => _EmojiMemoryGameState();
}

class _EmojiMemoryGameState extends State<EmojiMemoryGame> {
  final Random _random = Random();
  final List<String> _emojiPool = ['😀', '🐶', '🍎', '🚗', '🌞', '🎈', '🏠'];

  late String _target;
  late List<String> _options;
  bool _showAnswer = true;
  bool _complete = false;
  bool _roundStarted = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _newRound(startTimer: false);
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _setComplete(bool value) {
    if (_complete == value) {
      return;
    }
    _complete = value;
    widget.onCompletionChanged(value);
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _showAnswer = false;
      });
    });
  }

  void _newRound({required bool startTimer}) {
    _emojiPool.shuffle(_random);
    _target = _emojiPool.take(3).join(' ');
    final choices = <String>{_target};
    while (choices.length < 3) {
      _emojiPool.shuffle(_random);
      choices.add(_emojiPool.take(3).join(' '));
    }
    _options = choices.toList()..shuffle(_random);
    _showAnswer = true;
    _roundStarted = startTimer;
    _setComplete(false);
    if (startTimer) {
      _startHideTimer();
    } else {
      _hideTimer?.cancel();
    }
  }

  void _restartRound() {
    setState(() {
      _newRound(startTimer: true);
    });
  }

  void _select(String answer) {
    if (_showAnswer || !_roundStarted) {
      return;
    }
    setState(() {
      if (answer == _target) {
        _setComplete(true);
      } else {
        _newRound(startTimer: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '先記住表情，2 秒後會蓋住，請選正確組合。',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.blueGrey.shade50,
          ),
          child: Text(
            _showAnswer ? _target : '❓ ❓ ❓',
            style: const TextStyle(fontSize: 38),
          ),
        ),
        const SizedBox(height: 8),
        StatusLine(
          completed: _complete,
          text: _complete
              ? '完成！'
              : _showAnswer
              ? (_roundStarted ? '記住圖案中，2 秒後會遮住' : '按「開始記憶」開始本關')
              : '請選出剛剛看到的組合',
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final option in _options)
              ElevatedButton(
                onPressed: _complete ? null : () => _select(option),
                child: Text(option, style: const TextStyle(fontSize: 28)),
              ),
          ],
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: _restartRound,
          style: OutlinedButton.styleFrom(minimumSize: const Size(120, 60)),
          child: Text(
            _roundStarted ? '再玩一次' : '開始記憶',
            style: const TextStyle(fontSize: 22),
          ),
        ),
      ],
    );
  }
}

class SliderTargetGame extends StatefulWidget {
  const SliderTargetGame({super.key, required this.onCompletionChanged});

  final ValueChanged<bool> onCompletionChanged;

  @override
  State<SliderTargetGame> createState() => _SliderTargetGameState();
}

class _SliderTargetGameState extends State<SliderTargetGame> {
  final Random _random = Random();
  double _value = 50;
  late int _target;
  bool _complete = false;

  @override
  void initState() {
    super.initState();
    _target = (_random.nextInt(9) + 1) * 10;
  }

  void _setComplete(bool value) {
    if (_complete == value) {
      return;
    }
    _complete = value;
    widget.onCompletionChanged(value);
  }

  void _check() {
    final diff = (_value - _target).abs();
    setState(() {
      _setComplete(diff <= 5);
    });
  }

  void _reset() {
    setState(() {
      _value = 50;
      _target = (_random.nextInt(9) + 1) * 10;
      _setComplete(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('把滑桿調到接近 $_target。', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        Text(
          '目前值：${_value.round()}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Slider(
          value: _value,
          min: 0,
          max: 100,
          divisions: 20,
          label: _value.round().toString(),
          onChanged: (v) => setState(() => _value = v),
        ),
        StatusLine(completed: _complete, text: _complete ? '完成！' : '誤差 5 內即過關'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton(onPressed: _check, child: const Text('檢查')),
            OutlinedButton(
              onPressed: _reset,
              style: OutlinedButton.styleFrom(minimumSize: const Size(120, 60)),
              child: const Text('重設', style: TextStyle(fontSize: 22)),
            ),
          ],
        ),
      ],
    );
  }
}

class OddOneOutGame extends StatefulWidget {
  const OddOneOutGame({super.key, required this.onCompletionChanged});

  final ValueChanged<bool> onCompletionChanged;

  @override
  State<OddOneOutGame> createState() => _OddOneOutGameState();
}

class _OddOneOutGameState extends State<OddOneOutGame> {
  final Random _random = Random();
  final List<String> _pool = ['🍓', '🍋', '🍇', '🍒', '🍊', '🍉'];
  late String _same;
  late String _odd;
  late int _oddIndex;
  bool _complete = false;

  @override
  void initState() {
    super.initState();
    _newRound();
  }

  void _setComplete(bool value) {
    if (_complete == value) {
      return;
    }
    _complete = value;
    widget.onCompletionChanged(value);
  }

  void _newRound() {
    _pool.shuffle(_random);
    _same = _pool[0];
    _odd = _pool[1];
    _oddIndex = _random.nextInt(6);
    _setComplete(false);
  }

  void _select(int index) {
    setState(() {
      _setComplete(index == _oddIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('找出不同的水果。', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        StatusLine(completed: _complete, text: _complete ? '完成！' : '請點不同的那一個'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (int i = 0; i < 6; i++)
              ElevatedButton(
                onPressed: _complete ? null : () => _select(i),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(90, 70),
                ),
                child: Text(
                  i == _oddIndex ? _odd : _same,
                  style: const TextStyle(fontSize: 34),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: _newRound,
          style: OutlinedButton.styleFrom(minimumSize: const Size(120, 60)),
          child: const Text('下一題', style: TextStyle(fontSize: 22)),
        ),
      ],
    );
  }
}

class YesNoQuizGame extends StatefulWidget {
  const YesNoQuizGame({super.key, required this.onCompletionChanged});

  final ValueChanged<bool> onCompletionChanged;

  @override
  State<YesNoQuizGame> createState() => _YesNoQuizGameState();
}

class _YesNoQuizGameState extends State<YesNoQuizGame> {
  final Random _random = Random();
  final List<_QuizItem> _items = const [
    _QuizItem('太陽會從東邊升起。', true),
    _QuizItem('1 週有 10 天。', false),
    _QuizItem('水在 100°C 會沸騰。', true),
    _QuizItem('貓是植物。', false),
    _QuizItem('一年有 12 個月。', true),
  ];

  late _QuizItem _current;
  int _streak = 0;
  bool _complete = false;

  @override
  void initState() {
    super.initState();
    _current = _items.first;
    _nextQuestion();
  }

  void _setComplete(bool value) {
    if (_complete == value) {
      return;
    }
    _complete = value;
    widget.onCompletionChanged(value);
  }

  void _nextQuestion() {
    _current = _items[_random.nextInt(_items.length)];
  }

  void _answer(bool value) {
    setState(() {
      if (value == _current.answer) {
        _streak++;
      } else {
        _streak = 0;
      }

      if (_streak >= 3) {
        _setComplete(true);
      } else {
        _setComplete(false);
        _nextQuestion();
      }
    });
  }

  void _reset() {
    setState(() {
      _streak = 0;
      _setComplete(false);
      _nextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_current.text, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        StatusLine(
          completed: _complete,
          text: _complete ? '完成！' : '連續答對：$_streak / 3',
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton(
              onPressed: _complete ? null : () => _answer(true),
              child: const Text('是'),
            ),
            ElevatedButton(
              onPressed: _complete ? null : () => _answer(false),
              child: const Text('否'),
            ),
            OutlinedButton(
              onPressed: _reset,
              style: OutlinedButton.styleFrom(minimumSize: const Size(120, 60)),
              child: const Text('重來', style: TextStyle(fontSize: 22)),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuizItem {
  const _QuizItem(this.text, this.answer);

  final String text;
  final bool answer;
}

class QuickMathGame extends StatefulWidget {
  const QuickMathGame({super.key, required this.onCompletionChanged});

  final ValueChanged<bool> onCompletionChanged;

  @override
  State<QuickMathGame> createState() => _QuickMathGameState();
}

class _QuickMathGameState extends State<QuickMathGame> {
  final Random _random = Random();
  int _a = 0;
  int _b = 0;
  int _score = 0;
  bool _complete = false;
  List<int> _options = [];

  @override
  void initState() {
    super.initState();
    _newRound();
  }

  void _setComplete(bool value) {
    if (_complete == value) {
      return;
    }
    _complete = value;
    widget.onCompletionChanged(value);
  }

  void _newRound() {
    _a = _random.nextInt(10) + 1;
    _b = _random.nextInt(10) + 1;
    final correct = _a + _b;

    final values = <int>{correct};
    while (values.length < 3) {
      values.add(correct + _random.nextInt(7) - 3);
    }
    _options = values.where((v) => v > 0).toList();
    while (_options.length < 3) {
      _options.add(correct + _options.length + 1);
    }
    _options.shuffle(_random);
  }

  void _pick(int value) {
    setState(() {
      if (value == _a + _b) {
        _score++;
      } else {
        _score = max(0, _score - 1);
      }
      if (_score >= 3) {
        _setComplete(true);
      } else {
        _setComplete(false);
        _newRound();
      }
    });
  }

  void _reset() {
    setState(() {
      _score = 0;
      _setComplete(false);
      _newRound();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$_a + $_b = ?', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        StatusLine(
          completed: _complete,
          text: _complete ? '完成！' : '分數：$_score / 3',
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final option in _options)
              ElevatedButton(
                onPressed: _complete ? null : () => _pick(option),
                child: Text('$option'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: _reset,
          style: OutlinedButton.styleFrom(minimumSize: const Size(120, 60)),
          child: const Text('重置', style: TextStyle(fontSize: 22)),
        ),
      ],
    );
  }
}

class BreathingGame extends StatefulWidget {
  const BreathingGame({super.key, required this.onCompletionChanged});

  final ValueChanged<bool> onCompletionChanged;

  @override
  State<BreathingGame> createState() => _BreathingGameState();
}

class _BreathingGameState extends State<BreathingGame> {
  final List<String> _pattern = ['吸氣', '吐氣', '吸氣', '吐氣'];
  int _step = 0;
  bool _complete = false;

  void _setComplete(bool value) {
    if (_complete == value) {
      return;
    }
    _complete = value;
    widget.onCompletionChanged(value);
  }

  void _press(String choice) {
    setState(() {
      if (choice == _pattern[_step]) {
        _step++;
        if (_step == _pattern.length) {
          _setComplete(true);
        }
      } else {
        _step = 0;
        _setComplete(false);
      }
    });
  }

  void _reset() {
    setState(() {
      _step = 0;
      _setComplete(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String hint = _complete ? '完成！' : '下一步：${_pattern[_step]}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '按照節奏按：吸氣 → 吐氣 → 吸氣 → 吐氣',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        StatusLine(completed: _complete, text: hint),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton(
              onPressed: _complete ? null : () => _press('吸氣'),
              child: const Text('吸氣'),
            ),
            ElevatedButton(
              onPressed: _complete ? null : () => _press('吐氣'),
              child: const Text('吐氣'),
            ),
            OutlinedButton(
              onPressed: _reset,
              style: OutlinedButton.styleFrom(minimumSize: const Size(120, 60)),
              child: const Text('重來', style: TextStyle(fontSize: 22)),
            ),
          ],
        ),
      ],
    );
  }
}

class ReactionGame extends StatefulWidget {
  const ReactionGame({super.key, required this.onCompletionChanged});

  final ValueChanged<bool> onCompletionChanged;

  @override
  State<ReactionGame> createState() => _ReactionGameState();
}

class _ReactionGameState extends State<ReactionGame> {
  final Random _random = Random();
  Timer? _timer;
  final Stopwatch _stopwatch = Stopwatch();

  bool _ready = false;
  bool _canTap = false;
  bool _complete = false;
  String _message = '按「開始」後等待變綠，再按「點我！」';

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _setComplete(bool value) {
    if (_complete == value) {
      return;
    }
    _complete = value;
    widget.onCompletionChanged(value);
  }

  void _start() {
    _timer?.cancel();
    _stopwatch.reset();
    setState(() {
      _ready = true;
      _canTap = false;
      _message = '等待綠色...';
      _setComplete(false);
    });

    final waitMs = 1000 + _random.nextInt(2000);
    _timer = Timer(Duration(milliseconds: waitMs), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _canTap = true;
        _message = '現在！快按「點我！」';
      });
      _stopwatch
        ..reset()
        ..start();
    });
  }

  void _tap() {
    if (!_ready) {
      return;
    }

    if (!_canTap) {
      setState(() {
        _message = '太早了，請重試。';
        _ready = false;
      });
      _timer?.cancel();
      return;
    }

    _stopwatch.stop();
    final ms = _stopwatch.elapsedMilliseconds;
    setState(() {
      _ready = false;
      _canTap = false;
      if (ms <= 1500) {
        _setComplete(true);
        _message = '反應 $ms 毫秒，過關！';
      } else {
        _setComplete(false);
        _message = '反應 $ms 毫秒，再試一次（1500 毫秒內過關）。';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color buttonColor;
    if (!_ready) {
      buttonColor = Colors.grey;
    } else {
      buttonColor = _canTap ? Colors.green : Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '看到綠色就按，1500 毫秒內過關。',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        StatusLine(completed: _complete, text: _message),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton(onPressed: _start, child: const Text('開始')),
            ElevatedButton(
              onPressed: _ready ? _tap : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(170, 60),
              ),
              child: const Text('點我！'),
            ),
          ],
        ),
      ],
    );
  }
}
