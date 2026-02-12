import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class NormalGameHubPage extends StatefulWidget {
  const NormalGameHubPage({super.key});

  @override
  State<NormalGameHubPage> createState() => _NormalGameHubPageState();
}

class _NormalGameHubPageState extends State<NormalGameHubPage> {
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
    final completed = _completion.values.where((v) => v).length;

    return Scaffold(
      appBar: AppBar(title: const Text('普通模式：Flame 圖像闖關 10 遊戲')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  '完成進度：$completed / 10',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  '普通模式使用 Flame 開發，圖像化互動更豐富。',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                FlameChallengeCard(
                  index: 1,
                  title: '數字翻牌派對',
                  instruction: '依序翻出 1 到 6，翻錯會重置。',
                  gameFactory: NumberFlipPartyGame.new,
                  onCompletionChanged: (v) => _setCompleted(1, v),
                ),
                FlameChallengeCard(
                  index: 2,
                  title: '顏色翻牌配對',
                  instruction: '兩張一組，找出全部顏色配對。',
                  gameFactory: ColorFlipMatchGame.new,
                  onCompletionChanged: (v) => _setCompleted(2, v),
                ),
                FlameChallengeCard(
                  index: 3,
                  title: '打地鼠',
                  instruction: '地鼠冒出來就點它，達成 8 分過關。',
                  gameFactory: WhackMoleGame.new,
                  onCompletionChanged: (v) => _setCompleted(3, v),
                ),
                FlameChallengeCard(
                  index: 4,
                  title: '氣球爆破',
                  instruction: '點破上升的氣球，累積 10 分過關。',
                  gameFactory: BalloonPopGame.new,
                  onCompletionChanged: (v) => _setCompleted(4, v),
                ),
                FlameChallengeCard(
                  index: 5,
                  title: '接星星',
                  instruction: '拖曳籃子接住掉落星星，8 顆過關。',
                  gameFactory: CatchStarsGame.new,
                  onCompletionChanged: (v) => _setCompleted(5, v),
                ),
                FlameChallengeCard(
                  index: 6,
                  title: '路徑點擊',
                  instruction: '依序點擊 1 到 6 的路徑節點。',
                  gameFactory: PathTraceGame.new,
                  onCompletionChanged: (v) => _setCompleted(6, v),
                ),
                FlameChallengeCard(
                  index: 7,
                  title: '紅綠燈反應',
                  instruction: '紅燈等候，綠燈立刻按下反應鍵。',
                  gameFactory: TrafficReactionGame.new,
                  onCompletionChanged: (v) => _setCompleted(7, v),
                ),
                FlameChallengeCard(
                  index: 8,
                  title: '水果快切',
                  instruction: '點中飛行水果，切到 12 個過關。',
                  gameFactory: FruitSliceGame.new,
                  onCompletionChanged: (v) => _setCompleted(8, v),
                ),
                FlameChallengeCard(
                  index: 9,
                  title: '堆塔節奏',
                  instruction: '抓時機落下方塊，堆 6 層過關。',
                  gameFactory: TowerStackGame.new,
                  onCompletionChanged: (v) => _setCompleted(9, v),
                ),
                FlameChallengeCard(
                  index: 10,
                  title: '顏色記憶燈',
                  instruction: '記住閃爍順序，正確重現即可過關。',
                  gameFactory: SimonLightGame.new,
                  onCompletionChanged: (v) => _setCompleted(10, v),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

typedef FlameGameFactory = NotifyingMiniGame Function();

class FlameChallengeCard extends StatefulWidget {
  const FlameChallengeCard({
    super.key,
    required this.index,
    required this.title,
    required this.instruction,
    required this.gameFactory,
    required this.onCompletionChanged,
  });

  final int index;
  final String title;
  final String instruction;
  final FlameGameFactory gameFactory;
  final ValueChanged<bool> onCompletionChanged;

  @override
  State<FlameChallengeCard> createState() => _FlameChallengeCardState();
}

class _FlameChallengeCardState extends State<FlameChallengeCard> {
  late final NotifyingMiniGame _game;

  @override
  void initState() {
    super.initState();
    _game = widget.gameFactory();
    _game.completed.addListener(_onCompleteChanged);
  }

  @override
  void dispose() {
    _game.completed.removeListener(_onCompleteChanged);
    _game.pauseEngine();
    super.dispose();
  }

  void _onCompleteChanged() {
    widget.onCompletionChanged(_game.completed.value);
  }

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
              '第 ${widget.index} 關：${widget.title}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              widget.instruction,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<bool>(
              valueListenable: _game.completed,
              builder: (_, completed, __) {
                return _NormalStatusLine(
                  completed: completed,
                  text: completed ? '已完成此關卡' : '進行中',
                );
              },
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<String>(
              valueListenable: _game.status,
              builder: (_, status, __) {
                return Text(
                  status,
                  style: Theme.of(context).textTheme.bodyMedium,
                );
              },
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 1,
                child: GameWidget(game: _game),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _game.resetGame,
              style: OutlinedButton.styleFrom(minimumSize: const Size(120, 56)),
              child: const Text('重置本關', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}

class _NormalStatusLine extends StatelessWidget {
  const _NormalStatusLine({required this.completed, required this.text});

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

abstract class NotifyingMiniGame extends FlameGame {
  final ValueNotifier<String> status = ValueNotifier<String>('準備開始');
  final ValueNotifier<bool> completed = ValueNotifier<bool>(false);

  void setStatus(String value) => status.value = value;

  void setCompleted(bool value) {
    if (completed.value != value) {
      completed.value = value;
    }
  }

  void resetGame();
}

class TapRect extends PositionComponent with TapCallbacks {
  TapRect({
    required Vector2 position,
    required Vector2 size,
    required this.label,
    required this.fillColor,
    required this.onPressed,
    this.textColor = Colors.white,
    this.radius = 14,
    this.fontSize = 26,
  }) : super(position: position, size: size);

  String label;
  Color fillColor;
  Color textColor;
  final VoidCallback onPressed;
  double radius;
  final double fontSize;
  bool enabled = true;

  @override
  void render(Canvas canvas) {
    final rect = Offset.zero & Size(size.x, size.y);
    final paint = Paint()..color = fillColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      paint,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: size.x - 8);

    textPainter.paint(
      canvas,
      Offset(
        (size.x - textPainter.width) / 2,
        (size.y - textPainter.height) / 2,
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (enabled) {
      onPressed();
    }
  }
}

class TapCircle extends PositionComponent with TapCallbacks {
  TapCircle({
    required Vector2 center,
    required this.radius,
    required this.fillColor,
    required this.onPressed,
    this.label = '',
    this.textColor = Colors.white,
  }) : super(
         position: center - Vector2.all(radius),
         size: Vector2.all(radius * 2),
       );

  final double radius;
  final VoidCallback onPressed;
  String label;
  Color fillColor;
  Color textColor;
  bool enabled = true;

  @override
  bool containsLocalPoint(Vector2 point) {
    final c = Vector2(radius, radius);
    return point.distanceTo(c) <= radius;
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(radius, radius);
    final paint = Paint()..color = fillColor;
    canvas.drawCircle(center, radius, paint);

    if (label.isNotEmpty) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: radius * 0.8,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(radius - textPainter.width / 2, radius - textPainter.height / 2),
      );
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (enabled) {
      onPressed();
    }
  }
}

class NumberFlipPartyGame extends NotifyingMiniGame {
  final Random _random = Random();
  final List<_NumberCardState> _cards = [];
  final List<TapRect> _buttons = [];
  int _expected = 1;
  double _resetTimer = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    resetGame();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _layout();
  }

  void _layout() {
    if (_buttons.length != 6 || size.x <= 0 || size.y <= 0) {
      return;
    }
    final cardW = (size.x - 56) / 3;
    final cardH = (size.y - 62) / 2;
    for (int i = 0; i < _buttons.length; i++) {
      final row = i ~/ 3;
      final col = i % 3;
      _buttons[i]
        ..position = Vector2(12 + col * (cardW + 16), 12 + row * (cardH + 16))
        ..size = Vector2(cardW, cardH);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_resetTimer > 0) {
      _resetTimer -= dt;
      if (_resetTimer <= 0) {
        _resetProgressOnly();
      }
    }
  }

  @override
  void resetGame() {
    removeAll(children.whereType<TapRect>().toList());
    _buttons.clear();
    _cards
      ..clear()
      ..addAll(List.generate(6, (i) => _NumberCardState(number: i + 1)));
    _cards.shuffle(_random);

    _expected = 1;
    _resetTimer = 0;
    setCompleted(false);
    setStatus('目標：依序翻出 1 到 6。下一張：$_expected');

    for (int i = 0; i < _cards.length; i++) {
      final idx = i;
      final button = TapRect(
        position: Vector2.zero(),
        size: Vector2(60, 60),
        label: '？',
        fillColor: const Color(0xFF1976D2),
        onPressed: () => _onTapCard(idx),
      );
      _buttons.add(button);
      add(button);
    }
    _layout();
  }

  void _onTapCard(int idx) {
    if (completed.value || _resetTimer > 0) {
      return;
    }
    final card = _cards[idx];
    final button = _buttons[idx];

    if (card.revealed) {
      return;
    }

    card.revealed = true;
    button.label = '${card.number}';
    button.fillColor = const Color(0xFF2E7D32);

    if (card.number == _expected) {
      _expected++;
      if (_expected > 6) {
        setCompleted(true);
        setStatus('完成！你成功完成數字翻牌派對。');
      } else {
        setStatus('正確！下一張：$_expected');
      }
      return;
    }

    setStatus('翻錯了，1 秒後重置。');
    _resetTimer = 1;
  }

  void _resetProgressOnly() {
    _expected = 1;
    _resetTimer = 0;
    setCompleted(false);
    setStatus('目標：依序翻出 1 到 6。下一張：$_expected');
    for (int i = 0; i < _cards.length; i++) {
      _cards[i].revealed = false;
      _buttons[i]
        ..label = '？'
        ..fillColor = const Color(0xFF1976D2);
    }
  }
}

class _NumberCardState {
  _NumberCardState({required this.number});

  final int number;
  bool revealed = false;
}

class ColorFlipMatchGame extends NotifyingMiniGame {
  final Random _random = Random();
  final List<_ColorCardState> _cards = [];
  final List<TapRect> _tiles = [];
  final List<int> _picked = [];
  double _flipBack = 0;

  static const _palette = [
    Color(0xFFE53935),
    Color(0xFF43A047),
    Color(0xFF1E88E5),
    Color(0xFFFDD835),
  ];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    resetGame();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _layout();
  }

  void _layout() {
    if (_tiles.length != 8 || size.x <= 0 || size.y <= 0) {
      return;
    }
    final tileW = (size.x - 58) / 4;
    final tileH = (size.y - 46) / 2;
    for (int i = 0; i < _tiles.length; i++) {
      final row = i ~/ 4;
      final col = i % 4;
      _tiles[i]
        ..position = Vector2(10 + col * (tileW + 12), 10 + row * (tileH + 12))
        ..size = Vector2(tileW, tileH);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_flipBack > 0) {
      _flipBack -= dt;
      if (_flipBack <= 0) {
        for (final idx in _picked) {
          final c = _cards[idx];
          if (!c.matched) {
            c.revealed = false;
            _tiles[idx]
              ..fillColor = const Color(0xFF607D8B)
              ..label = '';
          }
        }
        _picked.clear();
      }
    }
  }

  @override
  void resetGame() {
    removeAll(children.whereType<TapRect>().toList());
    _tiles.clear();
    _cards.clear();
    _picked.clear();
    _flipBack = 0;
    setCompleted(false);
    setStatus('翻開兩張一樣顏色即可配對。');

    final pairs = [..._palette, ..._palette]..shuffle(_random);
    for (int i = 0; i < pairs.length; i++) {
      _cards.add(_ColorCardState(color: pairs[i], pairId: pairs[i].toARGB32()));
      final idx = i;
      final tile = TapRect(
        position: Vector2.zero(),
        size: Vector2(50, 50),
        label: '',
        fillColor: const Color(0xFF607D8B),
        onPressed: () => _onTap(idx),
      );
      _tiles.add(tile);
      add(tile);
    }
    _layout();
  }

  void _onTap(int idx) {
    if (completed.value || _flipBack > 0) {
      return;
    }
    final card = _cards[idx];
    if (card.revealed || card.matched) {
      return;
    }

    card.revealed = true;
    _tiles[idx].fillColor = card.color;
    _picked.add(idx);

    if (_picked.length < 2) {
      return;
    }

    final a = _cards[_picked[0]];
    final b = _cards[_picked[1]];
    if (a.pairId == b.pairId) {
      a.matched = true;
      b.matched = true;
      _picked.clear();
      final matchedCount = _cards.where((e) => e.matched).length;
      if (matchedCount == _cards.length) {
        setCompleted(true);
        setStatus('完成！全部顏色配對成功。');
      } else {
        setStatus('配對成功！目前 $matchedCount / ${_cards.length}');
      }
    } else {
      setStatus('不一樣，稍後會翻回去。');
      _flipBack = 0.8;
    }
  }
}

class _ColorCardState {
  _ColorCardState({required this.color, required this.pairId});

  final Color color;
  final int pairId;
  bool revealed = false;
  bool matched = false;
}

class WhackMoleGame extends NotifyingMiniGame {
  final Random _random = Random();
  final List<TapCircle> _holes = [];
  int _activeIndex = 0;
  double _spawnTimer = 0;
  int _score = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    resetGame();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _layout();
  }

  void _layout() {
    if (_holes.length != 9 || size.x <= 0 || size.y <= 0) {
      return;
    }
    final gapX = size.x / 4;
    final gapY = size.y / 4;
    double radius = min(gapX, gapY) * 0.35;
    radius = radius.clamp(20, 38);

    for (int i = 0; i < _holes.length; i++) {
      final row = i ~/ 3;
      final col = i % 3;
      _holes[i]
        ..position = Vector2(
          (col + 1) * gapX - radius,
          (row + 1) * gapY - radius,
        )
        ..size = Vector2.all(radius * 2);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (completed.value) {
      return;
    }
    _spawnTimer -= dt;
    if (_spawnTimer <= 0) {
      _activeIndex = _random.nextInt(9);
      _spawnTimer = 0.7;
      _refreshVisual();
    }
  }

  @override
  void resetGame() {
    removeAll(children.whereType<TapCircle>().toList());
    _holes.clear();
    _score = 0;
    _spawnTimer = 0;
    _activeIndex = 0;
    setCompleted(false);
    setStatus('分數：0 / 8');

    for (int i = 0; i < 9; i++) {
      final idx = i;
      final hole = TapCircle(
        center: Vector2.zero(),
        radius: 30,
        fillColor: const Color(0xFF6D4C41),
        label: '',
        onPressed: () => _tap(idx),
      );
      _holes.add(hole);
      add(hole);
    }
    _layout();
    _refreshVisual();
  }

  void _refreshVisual() {
    for (int i = 0; i < _holes.length; i++) {
      final isMole = i == _activeIndex;
      _holes[i]
        ..fillColor = isMole ? const Color(0xFF3E2723) : const Color(0xFF8D6E63)
        ..label = isMole ? '🐹' : '';
    }
  }

  void _tap(int idx) {
    if (completed.value) {
      return;
    }
    if (idx != _activeIndex) {
      return;
    }
    _score++;
    if (_score >= 8) {
      setCompleted(true);
      setStatus('完成！成功打到 $_score 隻地鼠。');
      return;
    }

    setStatus('分數：$_score / 8');
    _activeIndex = _random.nextInt(9);
    _spawnTimer = 0.6;
    _refreshVisual();
  }
}

class BalloonPopGame extends NotifyingMiniGame {
  final Random _random = Random();
  final List<_Balloon> _balloons = [];
  double _spawn = 0;
  int _score = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    resetGame();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (completed.value) {
      return;
    }

    _spawn -= dt;
    if (_spawn <= 0) {
      _spawn = 0.7;
      _spawnBalloon();
    }

    final toRemove = <_Balloon>[];
    for (final b in _balloons) {
      b.position.y -= b.speed * dt;
      if (b.position.y + b.radius * 2 < 0) {
        toRemove.add(b);
      }
    }
    for (final b in toRemove) {
      _balloons.remove(b);
      b.removeFromParent();
    }
  }

  @override
  void resetGame() {
    for (final b in _balloons) {
      b.removeFromParent();
    }
    _balloons.clear();
    _spawn = 0;
    _score = 0;
    setCompleted(false);
    setStatus('分數：$_score / 10');
  }

  void _spawnBalloon() {
    if (size.x <= 0 || size.y <= 0) {
      return;
    }
    final radius = 22.0 + _random.nextDouble() * 10;
    final x = 20 + _random.nextDouble() * max(40, size.x - 40);
    final color = Colors.primaries[_random.nextInt(Colors.primaries.length)];
    final balloon = _Balloon(
      radius: radius,
      color: color,
      speed: 45 + _random.nextDouble() * 30,
      position: Vector2(x, size.y - 20),
      onPopped: () {
        if (completed.value) {
          return;
        }
        _score++;
        if (_score >= 10) {
          setCompleted(true);
          setStatus('完成！共戳破 $_score 顆氣球。');
        } else {
          setStatus('分數：$_score / 10');
        }
      },
    );
    _balloons.add(balloon);
    add(balloon);
  }
}

class _Balloon extends PositionComponent with TapCallbacks {
  _Balloon({
    required this.radius,
    required this.color,
    required this.speed,
    required Vector2 position,
    required this.onPopped,
  }) : super(
         position: position - Vector2.all(radius),
         size: Vector2.all(radius * 2),
       );

  final double radius;
  final Color color;
  final double speed;
  final VoidCallback onPopped;

  @override
  bool containsLocalPoint(Vector2 point) {
    final center = Vector2(radius, radius);
    return center.distanceTo(point) <= radius;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset(radius, radius), radius, Paint()..color = color);
    canvas.drawLine(
      Offset(radius, radius * 2),
      Offset(radius, radius * 2 + 14),
      Paint()
        ..color = Colors.black45
        ..strokeWidth = 2,
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    onPopped();
    removeFromParent();
  }
}

class CatchStarsGame extends NotifyingMiniGame {
  final Random _random = Random();
  final List<_FallingStar> _stars = [];
  _Basket? _basket;
  double _spawn = 0;
  int _score = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _basket = _Basket();
    add(_basket!);
    resetGame();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (_basket != null && size.x > 0 && size.y > 0) {
      _basket!
        ..size = Vector2(120, 28)
        ..position = Vector2((size.x - 120) / 2, size.y - 40);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (completed.value) {
      return;
    }

    _spawn -= dt;
    if (_spawn <= 0) {
      _spawn = 0.65;
      _spawnStar();
    }

    final toRemove = <_FallingStar>[];
    final basket = _basket;
    if (basket == null) {
      return;
    }
    for (final star in _stars) {
      star.position.y += star.speed * dt;
      if (_overlap(star.toRect(), basket.toRect())) {
        _score++;
        toRemove.add(star);
        if (_score >= 8) {
          setCompleted(true);
          setStatus('完成！接到 $_score 顆星星。');
        } else {
          setStatus('分數：$_score / 8');
        }
      } else if (star.position.y > size.y + 20) {
        toRemove.add(star);
      }
    }

    for (final star in toRemove) {
      _stars.remove(star);
      star.removeFromParent();
    }
  }

  @override
  void resetGame() {
    for (final s in _stars) {
      s.removeFromParent();
    }
    _stars.clear();
    _spawn = 0;
    _score = 0;
    setCompleted(false);
    setStatus('分數：$_score / 8（拖曳籃子）');
  }

  void _spawnStar() {
    if (size.x <= 0 || size.y <= 0) {
      return;
    }
    final x = 15 + _random.nextDouble() * max(10, size.x - 30);
    final star = _FallingStar(
      position: Vector2(x, -10),
      speed: 80 + _random.nextDouble() * 45,
    );
    _stars.add(star);
    add(star);
  }

  bool _overlap(Rect a, Rect b) {
    return a.overlaps(b);
  }
}

class _FallingStar extends PositionComponent {
  _FallingStar({required Vector2 position, required this.speed})
    : super(position: position, size: Vector2(28, 28));

  final double speed;

  @override
  Rect toRect() => Rect.fromLTWH(position.x, position.y, size.x, size.y);

  @override
  void render(Canvas canvas) {
    final p = Paint()..color = const Color(0xFFFFD54F);
    final cx = size.x / 2;
    final cy = size.y / 2;
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final outer = i * 72 * pi / 180 - pi / 2;
      final inner = outer + 36 * pi / 180;
      path.lineTo(cx + cos(outer) * 12, cy + sin(outer) * 12);
      path.lineTo(cx + cos(inner) * 5, cy + sin(inner) * 5);
    }
    path.close();
    canvas.drawPath(path, p);
  }
}

class _Basket extends PositionComponent with DragCallbacks {
  @override
  void render(Canvas canvas) {
    final rect = RRect.fromRectAndRadius(
      Offset.zero & Size(size.x, size.y),
      const Radius.circular(10),
    );
    canvas.drawRRect(rect, Paint()..color = const Color(0xFF455A64));
  }

  @override
  Rect toRect() => Rect.fromLTWH(position.x, position.y, size.x, size.y);

  @override
  void onDragUpdate(DragUpdateEvent event) {
    final g = findGame();
    if (g is! NotifyingMiniGame) {
      return;
    }
    position.x += event.localDelta.x;
    position.x = position.x.clamp(0, max(0, g.size.x - size.x));
  }
}

class PathTraceGame extends NotifyingMiniGame {
  final Random _random = Random();
  final List<TapCircle> _nodes = [];
  final List<Vector2> _nodeCenters = [];
  int _next = 1;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    resetGame();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _layout();
  }

  void _layout() {
    if (_nodes.length != 6 || size.x <= 0 || size.y <= 0) {
      return;
    }
    if (_nodeCenters.length != 6) {
      _randomizeCenters();
    }
    for (int i = 0; i < _nodes.length; i++) {
      _nodes[i]
        ..position = _nodeCenters[i] - Vector2.all(28)
        ..size = Vector2.all(56);
    }
  }

  void _randomizeCenters() {
    if (size.x <= 0 || size.y <= 0) {
      return;
    }

    _nodeCenters.clear();
    const radius = 28.0;
    const minDistance = 70.0;
    final minX = radius + 8;
    final maxX = size.x - radius - 8;
    final minY = radius + 8;
    final maxY = size.y - radius - 8;

    int guard = 0;
    while (_nodeCenters.length < 6 && guard < 600) {
      guard++;
      final candidate = Vector2(
        minX + _random.nextDouble() * max(1, maxX - minX),
        minY + _random.nextDouble() * max(1, maxY - minY),
      );
      final ok = _nodeCenters.every(
        (center) => center.distanceTo(candidate) >= minDistance,
      );
      if (ok) {
        _nodeCenters.add(candidate);
      }
    }

    if (_nodeCenters.length < 6) {
      _nodeCenters
        ..clear()
        ..addAll([
          Vector2(size.x * 0.15, size.y * 0.45),
          Vector2(size.x * 0.3, size.y * 0.2),
          Vector2(size.x * 0.45, size.y * 0.65),
          Vector2(size.x * 0.6, size.y * 0.3),
          Vector2(size.x * 0.75, size.y * 0.6),
          Vector2(size.x * 0.88, size.y * 0.38),
        ]);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_nodes.length != 6) {
      return;
    }

    final p = Paint()
      ..color = const Color(0xFF90A4AE)
      ..strokeWidth = 4;
    for (int i = 0; i < 5; i++) {
      final a = _nodes[i].position + Vector2.all(28);
      final b = _nodes[i + 1].position + Vector2.all(28);
      canvas.drawLine(Offset(a.x, a.y), Offset(b.x, b.y), p);
    }
  }

  @override
  void resetGame() {
    removeAll(children.whereType<TapCircle>().toList());
    _nodes.clear();
    _nodeCenters.clear();
    _next = 1;
    setCompleted(false);
    setStatus('請點節點 1 到 6。下一個：$_next');

    for (int i = 1; i <= 6; i++) {
      final n = i;
      final node = TapCircle(
        center: Vector2.zero(),
        radius: 28,
        fillColor: const Color(0xFF546E7A),
        label: '$n',
        onPressed: () => _tapNode(n),
      );
      _nodes.add(node);
      add(node);
    }
    _layout();
  }

  void _tapNode(int n) {
    if (completed.value) {
      return;
    }
    if (n == _next) {
      _nodes[n - 1].fillColor = const Color(0xFF2E7D32);
      _next++;
      if (_next > 6) {
        setCompleted(true);
        setStatus('完成！路徑點擊成功。');
      } else {
        setStatus('正確，下一個：$_next');
      }
    } else {
      _next = 1;
      for (final node in _nodes) {
        node.fillColor = const Color(0xFF546E7A);
      }
      setStatus('順序錯誤，請重頭開始。下一個：$_next');
    }
  }
}

class TrafficReactionGame extends NotifyingMiniGame {
  final Random _random = Random();
  TapRect? _startBtn;
  TapRect? _tapBtn;

  double _waitTime = 0;
  double _greenElapsed = 0;
  _TrafficState _state = _TrafficState.idle;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _startBtn = TapRect(
      position: Vector2.zero(),
      size: Vector2(140, 58),
      label: '開始',
      fillColor: const Color(0xFF1976D2),
      onPressed: _start,
    );
    _tapBtn = TapRect(
      position: Vector2.zero(),
      size: Vector2(180, 62),
      label: '反應鍵',
      fillColor: const Color(0xFF9E9E9E),
      onPressed: _tap,
    );
    add(_startBtn!);
    add(_tapBtn!);
    resetGame();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (size.x <= 0 || size.y <= 0) {
      return;
    }
    _startBtn?.position = Vector2(14, size.y - 72);
    _tapBtn?.position = Vector2(size.x - 198, size.y - 76);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_state == _TrafficState.waiting) {
      _waitTime -= dt;
      if (_waitTime <= 0) {
        _state = _TrafficState.green;
        _greenElapsed = 0;
        _tapBtn?.fillColor = const Color(0xFF2E7D32);
        setStatus('綠燈！快按反應鍵。');
      }
    } else if (_state == _TrafficState.green) {
      _greenElapsed += dt;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    Color lightColor;
    if (_state == _TrafficState.waiting) {
      lightColor = const Color(0xFFC62828);
    } else if (_state == _TrafficState.green) {
      lightColor = const Color(0xFF2E7D32);
    } else {
      lightColor = const Color(0xFF757575);
    }

    final cx = size.x / 2;
    final cy = size.y * 0.45;
    canvas.drawCircle(
      Offset(cx, cy),
      52,
      Paint()..color = const Color(0xFF263238),
    );
    canvas.drawCircle(Offset(cx, cy), 42, Paint()..color = lightColor);
  }

  @override
  void resetGame() {
    setCompleted(false);
    _state = _TrafficState.idle;
    _waitTime = 0;
    _greenElapsed = 0;
    _tapBtn?.fillColor = const Color(0xFF9E9E9E);
    setStatus('按開始後等綠燈，再按反應鍵。');
  }

  void _start() {
    if (_state == _TrafficState.waiting || _state == _TrafficState.green) {
      return;
    }
    setCompleted(false);
    _state = _TrafficState.waiting;
    _waitTime = 1.2 + _random.nextDouble() * 1.8;
    _tapBtn?.fillColor = const Color(0xFFC62828);
    setStatus('紅燈等待中... 看到綠燈再按。');
  }

  void _tap() {
    if (_state == _TrafficState.waiting) {
      _state = _TrafficState.idle;
      _tapBtn?.fillColor = const Color(0xFF9E9E9E);
      setCompleted(false);
      setStatus('太早按了，請重試。');
      return;
    }

    if (_state != _TrafficState.green) {
      return;
    }

    final ms = (_greenElapsed * 1000).round();
    _state = _TrafficState.idle;
    _tapBtn?.fillColor = const Color(0xFF9E9E9E);
    if (ms <= 1200) {
      setCompleted(true);
      setStatus('完成！反應 ${ms}ms。');
    } else {
      setCompleted(false);
      setStatus('反應 ${ms}ms，需 1200ms 內。');
    }
  }
}

enum _TrafficState { idle, waiting, green }

class FruitSliceGame extends NotifyingMiniGame {
  final Random _random = Random();
  final List<_Fruit> _fruits = [];
  double _spawn = 0;
  int _score = 0;

  static const _emoji = ['🍎', '🍌', '🍉', '🍓', '🍊'];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    resetGame();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (completed.value) {
      return;
    }

    _spawn -= dt;
    if (_spawn <= 0) {
      _spawn = 0.5;
      _spawnFruit();
    }

    final toRemove = <_Fruit>[];
    for (final f in _fruits) {
      f.position += f.velocity * dt;
      if (f.position.x < -30 || f.position.x > size.x + 30) {
        toRemove.add(f);
      }
    }
    for (final f in toRemove) {
      _fruits.remove(f);
      f.removeFromParent();
    }
  }

  @override
  void resetGame() {
    for (final f in _fruits) {
      f.removeFromParent();
    }
    _fruits.clear();
    _spawn = 0;
    _score = 0;
    setCompleted(false);
    setStatus('分數：$_score / 12');
  }

  void _spawnFruit() {
    if (size.x <= 0 || size.y <= 0) {
      return;
    }

    final fromLeft = _random.nextBool();
    final y = 50 + _random.nextDouble() * max(50, size.y - 120);
    final speed = 80 + _random.nextDouble() * 80;
    final x = fromLeft ? -20.0 : size.x + 20.0;
    final vx = fromLeft ? speed : -speed;
    final fruit = _Fruit(
      position: Vector2(x, y),
      velocity: Vector2(vx, 0),
      emoji: _emoji[_random.nextInt(_emoji.length)],
      onSlice: () {
        if (completed.value) {
          return;
        }
        _score++;
        if (_score >= 12) {
          setCompleted(true);
          setStatus('完成！切中 $_score 個水果。');
        } else {
          setStatus('分數：$_score / 12');
        }
      },
    );
    _fruits.add(fruit);
    add(fruit);
  }
}

class _Fruit extends PositionComponent with TapCallbacks {
  _Fruit({
    required Vector2 position,
    required this.velocity,
    required this.emoji,
    required this.onSlice,
  }) : super(position: position, size: Vector2(46, 46));

  final Vector2 velocity;
  final String emoji;
  final VoidCallback onSlice;

  @override
  bool containsLocalPoint(Vector2 point) {
    final c = Vector2(size.x / 2, size.y / 2);
    return c.distanceTo(point) <= size.x / 2;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      Paint()..color = const Color(0xFFFFF8E1),
    );
    final tp = TextPainter(
      text: TextSpan(text: emoji, style: const TextStyle(fontSize: 30)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset((size.x - tp.width) / 2, (size.y - tp.height) / 2));
  }

  @override
  void onTapDown(TapDownEvent event) {
    onSlice();
    removeFromParent();
  }
}

class TowerStackGame extends NotifyingMiniGame {
  final List<_TowerBlock> _stack = [];
  TapRect? _dropBtn;

  static const _controlAreaHeight = 84.0;
  double _movingX = 20;
  double _dir = 1;
  static const _blockW = 90.0;
  static const _blockH = 24.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _dropBtn = TapRect(
      position: Vector2.zero(),
      size: Vector2(160, 60),
      label: '放下方塊',
      fillColor: const Color(0xFF1976D2),
      onPressed: _drop,
    );
    add(_dropBtn!);
    resetGame();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _dropBtn?.position = Vector2((size.x - 160) / 2, size.y - 70);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (completed.value) {
      return;
    }
    _movingX += _dir * 110 * dt;
    final maxX = max(20.0, size.x - _blockW - 20);
    if (_movingX <= 20) {
      _movingX = 20;
      _dir = 1;
    }
    if (_movingX >= maxX) {
      _movingX = maxX;
      _dir = -1;
    }
  }

  @override
  void render(Canvas canvas) {
    final baseY = size.y - _controlAreaHeight;
    final bg = Paint()..color = const Color(0xFFB0BEC5);
    canvas.drawRect(Rect.fromLTWH(8, baseY, size.x - 16, 8), bg);

    for (int i = 0; i < _stack.length; i++) {
      final block = _stack[i];
      final y = baseY - (i + 1) * (_blockH + 2);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(block.x, y, _blockW, _blockH),
          const Radius.circular(4),
        ),
        Paint()..color = const Color(0xFF455A64),
      );
    }

    final movingY = baseY - (_stack.length + 1) * (_blockH + 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_movingX, movingY, _blockW, _blockH),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF42A5F5),
    );

    super.render(canvas);
  }

  @override
  void resetGame() {
    _stack.clear();
    _movingX = 20;
    _dir = 1;
    setCompleted(false);
    setStatus('堆塔：0 / 6');
  }

  void _drop() {
    if (completed.value) {
      return;
    }

    if (_stack.isEmpty) {
      _stack.add(_TowerBlock(x: _movingX));
      setStatus('堆塔：1 / 6');
      return;
    }

    final topX = _stack.last.x;
    final overlap = _blockW - (_movingX - topX).abs();
    if (overlap >= _blockW * 0.45) {
      _stack.add(_TowerBlock(x: _movingX));
      if (_stack.length >= 6) {
        setCompleted(true);
        setStatus('完成！成功堆到 ${_stack.length} 層。');
      } else {
        setStatus('堆塔：${_stack.length} / 6');
      }
    } else {
      _stack.clear();
      setCompleted(false);
      setStatus('沒對齊，塔倒了，重新開始。');
    }
  }
}

class _TowerBlock {
  _TowerBlock({required this.x});

  final double x;
}

class SimonLightGame extends NotifyingMiniGame {
  final Random _random = Random();
  final List<TapRect> _pads = [];
  final List<int> _sequence = [];
  int _showIndex = 0;
  int _inputIndex = 0;
  double _showTimer = 0;
  int _highlight = -1;
  bool _showing = true;

  static const _colors = [
    Color(0xFFE53935),
    Color(0xFF43A047),
    Color(0xFF1E88E5),
    Color(0xFFFDD835),
  ];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    for (int i = 0; i < 4; i++) {
      final idx = i;
      final pad = TapRect(
        position: Vector2.zero(),
        size: Vector2(60, 60),
        label: '',
        fillColor: _colors[i],
        onPressed: () => _tap(idx),
      );
      _pads.add(pad);
      add(pad);
    }
    resetGame();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final w = (size.x - 40) / 2;
    final h = (size.y - 40) / 2;
    for (int i = 0; i < _pads.length; i++) {
      final row = i ~/ 2;
      final col = i % 2;
      _pads[i]
        ..position = Vector2(12 + col * (w + 16), 12 + row * (h + 16))
        ..size = Vector2(w, h);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_showing || completed.value) {
      return;
    }

    _showTimer -= dt;
    if (_showTimer > 0) {
      return;
    }

    if (_highlight == -1) {
      if (_showIndex >= _sequence.length) {
        _showing = false;
        _inputIndex = 0;
        setStatus('請依序點擊顏色。');
        return;
      }
      _highlight = _sequence[_showIndex];
      _showTimer = 0.55;
      _refreshPadColors();
    } else {
      _highlight = -1;
      _showIndex++;
      _showTimer = 0.25;
      _refreshPadColors();
    }
  }

  @override
  void resetGame() {
    _sequence
      ..clear()
      ..addAll(List.generate(4, (_) => _random.nextInt(4)));
    _showIndex = 0;
    _inputIndex = 0;
    _showTimer = 0.35;
    _showing = true;
    _highlight = -1;
    setCompleted(false);
    setStatus('觀察閃爍順序...');
    _refreshPadColors();
  }

  void _tap(int idx) {
    if (_showing || completed.value) {
      return;
    }
    if (idx == _sequence[_inputIndex]) {
      _inputIndex++;
      if (_inputIndex >= _sequence.length) {
        setCompleted(true);
        setStatus('完成！順序完全正確。');
      } else {
        setStatus('正確，繼續輸入第 ${_inputIndex + 1} 步。');
      }
    } else {
      setCompleted(false);
      setStatus('順序錯誤，重新播放。');
      _showing = true;
      _showIndex = 0;
      _inputIndex = 0;
      _highlight = -1;
      _showTimer = 0.4;
    }
  }

  void _refreshPadColors() {
    for (int i = 0; i < _pads.length; i++) {
      final c = _colors[i];
      _pads[i].fillColor = i == _highlight ? c : c.withValues(alpha: 0.7);
    }
  }
}
