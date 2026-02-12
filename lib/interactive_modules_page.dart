import 'dart:math';

import 'package:flutter/material.dart';

class InteractiveModulesPage extends StatefulWidget {
  const InteractiveModulesPage({super.key});

  @override
  State<InteractiveModulesPage> createState() => _InteractiveModulesPageState();
}

class _InteractiveModulesPageState extends State<InteractiveModulesPage> {
  final Map<int, bool> _completion = {for (int i = 1; i <= 4; i++) i: false};

  void _setCompleted(int id, bool completed) {
    if (_completion[id] == completed) {
      return;
    }
    setState(() {
      _completion[id] = completed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final done = _completion.values.where((v) => v).length;
    return Scaffold(
      appBar: AppBar(title: const Text('待確認數位互動模組')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  '確認進度：$done / 4',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '以下為待確認的數位互動模組原型。',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                _ModuleCard(
                  index: 1,
                  title: '健康量測體驗',
                  child: HealthMeasurementModule(
                    onCompletionChanged: (v) => _setCompleted(1, v),
                  ),
                ),
                _ModuleCard(
                  index: 2,
                  title: '媒體識讀',
                  child: MediaLiteracyModule(
                    onCompletionChanged: (v) => _setCompleted(2, v),
                  ),
                ),
                _ModuleCard(
                  index: 3,
                  title: 'Bingo 連線',
                  child: BingoModule(
                    onCompletionChanged: (v) => _setCompleted(3, v),
                  ),
                ),
                _ModuleCard(
                  index: 4,
                  title: '消消樂',
                  child: MatchEliminateModule(
                    onCompletionChanged: (v) => _setCompleted(4, v),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
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
              '$index. $title',
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

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.completed, required this.text});

  final bool completed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          completed ? Icons.check_circle : Icons.radio_button_unchecked,
          color: completed ? Colors.green : Colors.grey,
          size: 28,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}

class HealthMeasurementModule extends StatefulWidget {
  const HealthMeasurementModule({super.key, required this.onCompletionChanged});

  final ValueChanged<bool> onCompletionChanged;

  @override
  State<HealthMeasurementModule> createState() =>
      _HealthMeasurementModuleState();
}

class _HealthMeasurementModuleState extends State<HealthMeasurementModule> {
  int _step = 0;
  bool _complete = false;
  String _message = '請先完成示範流程。';

  void _setComplete(bool value) {
    if (_complete == value) {
      return;
    }
    _complete = value;
    widget.onCompletionChanged(value);
  }

  void _answer(String value) {
    if (_step < 3) {
      return;
    }
    setState(() {
      if (value == '記錄') {
        _setComplete(true);
        _message = '答對了，完整流程理解完成。';
      } else {
        _setComplete(false);
        _message = '再想一下：量測後要先做哪一步？';
      }
    });
  }

  void _reset() {
    setState(() {
      _step = 0;
      _setComplete(false);
      _message = '請先完成示範流程。';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '步驟式導覽任務（圖卡/短片 + 1 題確認題）',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            _GuideChip(icon: Icons.favorite, text: '圖卡：血壓量測姿勢'),
            _GuideChip(icon: Icons.play_circle, text: '短片：30 秒示範'),
            _GuideChip(icon: Icons.note_alt, text: '圖卡：紀錄欄位'),
          ],
        ),
        const SizedBox(height: 10),
        _StatusLine(completed: _complete, text: _complete ? '已完成模組' : _message),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton(
              onPressed: _step == 0
                  ? () => setState(() {
                      _step = 1;
                      _message = '已完成：量測';
                    })
                  : null,
              child: const Text('完成量測'),
            ),
            ElevatedButton(
              onPressed: _step == 1
                  ? () => setState(() {
                      _step = 2;
                      _message = '已完成：記錄';
                    })
                  : null,
              child: const Text('完成記錄'),
            ),
            ElevatedButton(
              onPressed: _step == 2
                  ? () => setState(() {
                      _step = 3;
                      _message = '已完成：查看結果，請回答確認題';
                    })
                  : null,
              child: const Text('查看結果'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text('確認題：量測之後，下一步是？', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            OutlinedButton(
              onPressed: _step >= 3 ? () => _answer('查看') : null,
              child: const Text('直接看結果', style: TextStyle(fontSize: 20)),
            ),
            OutlinedButton(
              onPressed: _step >= 3 ? () => _answer('記錄') : null,
              child: const Text('先做記錄', style: TextStyle(fontSize: 20)),
            ),
            OutlinedButton(
              onPressed: _step >= 3 ? () => _answer('重測') : null,
              child: const Text('馬上重測', style: TextStyle(fontSize: 20)),
            ),
            OutlinedButton(
              onPressed: _reset,
              child: const Text('重置', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ],
    );
  }
}

class _GuideChip extends StatelessWidget {
  const _GuideChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 22),
      label: Text(text, style: const TextStyle(fontSize: 18)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    );
  }
}

class MediaLiteracyModule extends StatefulWidget {
  const MediaLiteracyModule({super.key, required this.onCompletionChanged});

  final ValueChanged<bool> onCompletionChanged;

  @override
  State<MediaLiteracyModule> createState() => _MediaLiteracyModuleState();
}

class _MediaLiteracyModuleState extends State<MediaLiteracyModule> {
  final List<int?> _answers = [null, null, null];
  int _score = 0;
  bool _complete = false;

  static const _correct = [1, 2, 0];

  void _setComplete(bool value) {
    if (_complete == value) {
      return;
    }
    _complete = value;
    widget.onCompletionChanged(value);
  }

  void _submit() {
    if (_answers.any((e) => e == null)) {
      return;
    }
    int score = 0;
    for (int i = 0; i < _answers.length; i++) {
      if (_answers[i] == _correct[i]) {
        score++;
      }
    }
    setState(() {
      _score = score;
      _setComplete(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('閱讀短文後完成 3 題互動。', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            '【短文】某社群貼文聲稱「喝鹽水可預防所有感冒」，並附上未標示來源的圖片。\n'
            '建議閱讀時先檢查：來源、日期、是否有醫療機構或專業單位佐證。',
            style: TextStyle(fontSize: 20, height: 1.4),
          ),
        ),
        const SizedBox(height: 10),
        _QuestionBlock(
          title: 'Q1. 第一個要做的是？',
          options: const ['直接轉傳', '先查來源', '先留言回覆'],
          value: _answers[0],
          onChanged: (v) => setState(() => _answers[0] = v),
        ),
        _QuestionBlock(
          title: 'Q2. 下列哪個資訊最能提高可信度？',
          options: const ['截圖數量多', '按讚數高', '公衛單位公告'],
          value: _answers[1],
          onChanged: (v) => setState(() => _answers[1] = v),
        ),
        _QuestionBlock(
          title: 'Q3. 看到聳動標題時較好的做法是？',
          options: const ['先停一下再查證', '馬上分享給家人', '先罵再說'],
          value: _answers[2],
          onChanged: (v) => setState(() => _answers[2] = v),
        ),
        const SizedBox(height: 8),
        _StatusLine(
          completed: _complete,
          text: _complete ? '已完成 3 題，得分：$_score / 3' : '請完成 3 題後送出',
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton(onPressed: _submit, child: const Text('送出作答')),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _answers.setAll(0, [null, null, null]);
                  _score = 0;
                  _setComplete(false);
                });
              },
              child: const Text('重置', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuestionBlock extends StatelessWidget {
  const _QuestionBlock({
    required this.title,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final List<String> options;
  final int? value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (int i = 0; i < options.length; i++)
                ChoiceChip(
                  label: Text(options[i], style: const TextStyle(fontSize: 18)),
                  selected: value == i,
                  onSelected: (_) => onChanged(i),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class BingoModule extends StatefulWidget {
  const BingoModule({super.key, required this.onCompletionChanged});

  final ValueChanged<bool> onCompletionChanged;

  @override
  State<BingoModule> createState() => _BingoModuleState();
}

class _BingoModuleState extends State<BingoModule> {
  final Random _random = Random();
  late List<int> _numbers;
  late List<int> _drawPool;
  int? _currentCalled;
  final Set<int> _selected = {};
  final Set<int> _calledNumbers = {};
  bool _complete = false;
  String _message = '按「開下一球」開始單人 Bingo。';

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _setComplete(bool value) {
    if (_complete == value) {
      return;
    }
    _complete = value;
    widget.onCompletionChanged(value);
  }

  void _reset() {
    _numbers = List.generate(75, (i) => i + 1)..shuffle(_random);
    _numbers = _numbers.take(25).toList();
    _drawPool = List.generate(75, (i) => i + 1)..shuffle(_random);
    _currentCalled = null;
    _calledNumbers.clear();
    _selected.clear();
    _message = '按「開下一球」開始單人 Bingo。';
    _setComplete(false);
  }

  bool _isBingo() {
    bool line(int a, int b, int c, int d, int e) =>
        _selected.contains(a) &&
        _selected.contains(b) &&
        _selected.contains(c) &&
        _selected.contains(d) &&
        _selected.contains(e);

    for (int r = 0; r < 5; r++) {
      if (line(r * 5, r * 5 + 1, r * 5 + 2, r * 5 + 3, r * 5 + 4)) {
        return true;
      }
    }
    for (int c = 0; c < 5; c++) {
      if (line(c, c + 5, c + 10, c + 15, c + 20)) {
        return true;
      }
    }
    if (line(0, 6, 12, 18, 24) || line(4, 8, 12, 16, 20)) {
      return true;
    }
    return false;
  }

  void _tap(int index) {
    setState(() {
      final value = _numbers[index];
      if (!_calledNumbers.contains(value)) {
        _message = '只能標記已開出的號碼：$value 尚未開出。';
        return;
      }
      if (_selected.contains(index)) {
        _selected.remove(index);
      } else {
        _selected.add(index);
      }
      _setComplete(_isBingo());
      if (_complete) {
        _message = 'BINGO！你已連成一線。';
      } else {
        _message = '已開出 ${_calledNumbers.length} 球，持續連線中。';
      }
    });
  }

  void _drawNext() {
    if (_drawPool.isEmpty || _complete) {
      return;
    }
    setState(() {
      _currentCalled = _drawPool.removeLast();
      _calledNumbers.add(_currentCalled!);
      if (_numbers.contains(_currentCalled)) {
        _message = '開出 $_currentCalled，牌面上有這個數字，可點選標記。';
      } else {
        _message = '開出 $_currentCalled，牌面上沒有。';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('連成任一橫線、直線或斜線即過關。', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        _StatusLine(
          completed: _complete,
          text: _complete ? 'BINGO！' : _message,
        ),
        const SizedBox(height: 8),
        Text(
          '目前球號：${_currentCalled ?? '-'}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 10),
        AspectRatio(
          aspectRatio: 1,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 25,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemBuilder: (_, i) {
              final selected = _selected.contains(i);
              return InkWell(
                onTap: () => _tap(i),
                child: Container(
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.lightGreen
                        : Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${_numbers[i]}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton(onPressed: _drawNext, child: const Text('開下一球')),
            OutlinedButton(
              onPressed: () => setState(_reset),
              child: const Text('重新洗牌', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ],
    );
  }
}

class MatchEliminateModule extends StatefulWidget {
  const MatchEliminateModule({super.key, required this.onCompletionChanged});

  final ValueChanged<bool> onCompletionChanged;

  @override
  State<MatchEliminateModule> createState() => _MatchEliminateModuleState();
}

class _MatchEliminateModuleState extends State<MatchEliminateModule> {
  final Random _random = Random();
  static const int _size = 6;
  late List<List<int>> _board;
  (int, int)? _selectedCell;
  Set<(int, int)> _flashCells = {};
  bool _flashOn = false;
  Set<(int, int)> _errorCells = {};
  bool _isAnimating = false;
  int _score = 0;
  bool _complete = false;

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _setComplete(bool value) {
    if (_complete == value) {
      return;
    }
    _complete = value;
    widget.onCompletionChanged(value);
  }

  void _initBoard() {
    _board = List.generate(
      _size,
      (_) => List.generate(_size, (_) => _random.nextInt(5)),
    );
    _score = 0;
    _selectedCell = null;
    _flashCells = {};
    _flashOn = false;
    _errorCells = {};
    _isAnimating = false;
    _setComplete(false);
  }

  String _emoji(int value) {
    const values = ['🍎', '🍋', '🍇', '🍉', '🍒'];
    return values[value];
  }

  List<(int, int)> _connectedGroup(int row, int col) {
    final target = _board[row][col];
    final visited = <(int, int)>{};
    final queue = <(int, int)>[(row, col)];

    while (queue.isNotEmpty) {
      final current = queue.removeLast();
      if (visited.contains(current)) {
        continue;
      }
      visited.add(current);

      final (r, c) = current;
      final neighbors = [(r - 1, c), (r + 1, c), (r, c - 1), (r, c + 1)];
      for (final (nr, nc) in neighbors) {
        if (nr < 0 || nr >= _size || nc < 0 || nc >= _size) {
          continue;
        }
        if (_board[nr][nc] == target && !visited.contains((nr, nc))) {
          queue.add((nr, nc));
        }
      }
    }
    return visited.toList();
  }

  Future<void> _tap(int row, int col) async {
    if (_isAnimating || _complete) {
      return;
    }

    final current = (row, col);
    final first = _selectedCell;
    if (first == null) {
      setState(() {
        _selectedCell = current;
        _errorCells = {};
        _flashCells = {};
        _flashOn = false;
      });
      return;
    }

    if (first == current) {
      setState(() {
        _selectedCell = null;
        _errorCells = {};
      });
      return;
    }

    final isAdjacent =
        (first.$1 - current.$1).abs() + (first.$2 - current.$2).abs() == 1;
    final sameType =
        _board[first.$1][first.$2] == _board[current.$1][current.$2];

    if (!isAdjacent || !sameType) {
      setState(() {
        _errorCells = {first, current};
      });
      await Future<void>.delayed(const Duration(milliseconds: 420));
      if (!mounted) {
        return;
      }
      setState(() {
        _selectedCell = null;
        _errorCells = {};
      });
      return;
    }

    _isAnimating = true;
    final groupSet = _connectedGroup(first.$1, first.$2).toSet();
    setState(() {
      _selectedCell = first;
      _errorCells = {};
      _flashCells = groupSet;
      _flashOn = true;
    });

    for (int i = 0; i < 4; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 140));
      if (!mounted) {
        return;
      }
      setState(() {
        _flashOn = !_flashOn;
      });
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _score += groupSet.length;
      for (final (r, c) in groupSet) {
        _board[r][c] = _random.nextInt(5);
      }
      _selectedCell = null;
      _flashCells = {};
      _flashOn = false;
      if (_score >= 30) {
        _setComplete(true);
      }
    });
    _isAnimating = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '點擊相鄰且同圖示的群組（2 個以上）即可消除，累積 30 分過關。',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        _StatusLine(
          completed: _complete,
          text: _complete ? '完成！分數：$_score' : '目前分數：$_score / 30（先點兩顆相鄰同圖示）',
        ),
        const SizedBox(height: 10),
        AspectRatio(
          aspectRatio: 1,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _size * _size,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _size,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemBuilder: (_, i) {
              final r = i ~/ _size;
              final c = i % _size;
              final cell = (r, c);
              final selected = _selectedCell == cell;
              final flash = _flashCells.contains(cell) && _flashOn;
              final error = _errorCells.contains(cell);

              final borderColor = flash
                  ? Colors.green
                  : error
                  ? Colors.red
                  : selected
                  ? Colors.deepOrange
                  : Colors.orange.shade200;
              final double borderWidth = flash
                  ? 3.6
                  : error
                  ? 3
                  : selected
                  ? 3
                  : 1.2;

              return InkWell(
                onTap: _complete ? null : () => _tap(r, c),
                child: Container(
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.amber.shade200
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor, width: borderWidth),
                    boxShadow: flash
                        ? [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 0.35),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      _emoji(_board[r][c]),
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => setState(_initBoard),
          child: const Text('重玩', style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }
}
