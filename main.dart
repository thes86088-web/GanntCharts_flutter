import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CPU Scheduling Simulator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

// ─────────────────────────────────────────────
// Models
// ─────────────────────────────────────────────

class ProcessData {
  int processId;
  int arrivalTime;
  int burstTime;

  ProcessData({
    required this.processId,
    required this.arrivalTime,
    required this.burstTime,
  });

  factory ProcessData.init(int id) =>
      ProcessData(processId: id, arrivalTime: 0, burstTime: 1);
}

class GanttData {
  final List<int> ganttList; // processId per time unit (-1 = idle)
  final List<int> uniqueProcessIds;

  GanttData({required this.ganttList, required this.uniqueProcessIds});
}

// ─────────────────────────────────────────────
// Main Screen (top-level navigator)
// ─────────────────────────────────────────────

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // "input" | "result"
  String current = "input";

  List<ProcessData> processes = [];
  String selectedAlgo = "FCFS";

  void goToResult(List<ProcessData> data, String algo) {
    setState(() {
      processes = List.from(data);
      selectedAlgo = algo;
      current = "result";
    });
  }

  void restart() {
    setState(() {
      current = "input";
      processes = [];
      selectedAlgo = "FCFS";
    });
  }

  @override
  Widget build(BuildContext context) {
    if (current == "result") {
      return ResultScreen(
        processes: processes,
        algo: selectedAlgo,
        onRestart: restart,
      );
    }
    return InputFlow(onFinish: goToResult);
  }
}

// ─────────────────────────────────────────────
// Input Flow (Num → Data → Selection)
// ─────────────────────────────────────────────

class InputFlow extends StatefulWidget {
  final void Function(List<ProcessData>, String) onFinish;

  const InputFlow({super.key, required this.onFinish});

  @override
  State<InputFlow> createState() => _InputFlowState();
}

class _InputFlowState extends State<InputFlow> {
  // "num" | "data" | "selection"
  String step = "num";

  int processCount = 3;
  List<ProcessData> processes = [];
  String selectedAlgo = "FCFS";

  void goToData() {
    setState(() {
      processes = List.generate(
        processCount,
        (i) => ProcessData.init(i),
      );
      step = "data";
    });
  }

  void goToSelection() {
    setState(() => step = "selection");
  }

  void finish() {
    widget.onFinish(processes, selectedAlgo);
  }

  void updateProcess(int index, int at, int bt) {
    setState(() {
      processes[index] = ProcessData(
        processId: index,
        arrivalTime: at,
        burstTime: bt,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (step) {
      case "data":
        return DataScreen(
          processes: processes,
          onUpdate: updateProcess,
          onNext: goToSelection,
        );
      case "selection":
        return SelectionScreen(
          selectedAlgo: selectedAlgo,
          onAlgoChanged: (v) => setState(() => selectedAlgo = v),
          onNext: finish,
        );
      default:
        return NumScreen(
          count: processCount,
          onCountChanged: (v) => setState(() => processCount = v),
          onNext: goToData,
        );
    }
  }
}

// ─────────────────────────────────────────────
// Num Screen
// ─────────────────────────────────────────────

class NumScreen extends StatelessWidget {
  final int count;
  final ValueChanged<int> onCountChanged;
  final VoidCallback onNext;

  const NumScreen({
    super.key,
    required this.count,
    required this.onCountChanged,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Number of Processes")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$count",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            Slider(
              value: count.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: count.toString(),
              onChanged: (v) => onCountChanged(v.round()),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onNext,
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Data Screen
// ─────────────────────────────────────────────

class DataScreen extends StatelessWidget {
  final List<ProcessData> processes;
  final void Function(int index, int at, int bt) onUpdate;
  final VoidCallback onNext;

  const DataScreen({
    super.key,
    required this.processes,
    required this.onUpdate,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Process Data (AT / BT)"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.icon(
              onPressed: onNext,
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Confirm"),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: processes.length,
        itemBuilder: (context, index) {
          return ProcessCard(
            process: processes[index],
            onSave: (at, bt) => onUpdate(index, at, bt),
          );
        },
      ),
    );
  }
}

class ProcessCard extends StatefulWidget {
  final ProcessData process;
  final void Function(int at, int bt) onSave;

  const ProcessCard({
    super.key,
    required this.process,
    required this.onSave,
  });

  @override
  State<ProcessCard> createState() => _ProcessCardState();
}

class _ProcessCardState extends State<ProcessCard> {
  late int at;
  late int bt;

  @override
  void initState() {
    super.initState();
    at = widget.process.arrivalTime;
    bt = widget.process.burstTime;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "P${widget.process.processId}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                IconButton.filled(
                  icon: const Icon(Icons.check),
                  onPressed: () => widget.onSave(at, bt),
                  tooltip: "Save values",
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text("Arrival Time: $at"),
            Slider(
              value: at.toDouble(),
              min: 0,
              max: 20,
              divisions: 20,
              label: at.toString(),
              onChanged: (v) => setState(() => at = v.round()),
            ),
            Text("Burst Time: $bt"),
            Slider(
              value: bt.toDouble(),
              min: 1,
              max: 20,
              divisions: 19,
              label: bt.toString(),
              onChanged: (v) => setState(() => bt = v.round()),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Selection Screen
// ─────────────────────────────────────────────

class SelectionScreen extends StatelessWidget {
  final String selectedAlgo;
  final ValueChanged<String> onAlgoChanged;
  final VoidCallback onNext;

  const SelectionScreen({
    super.key,
    required this.selectedAlgo,
    required this.onAlgoChanged,
    required this.onNext,
  });

  static const algos = [
    "FCFS",
    "SJF",
    "SRTF",
    "LJF",
    "HRRN",
    "RoundRobin (QT=2)",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Algorithm")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownMenu<String>(
              initialSelection: selectedAlgo,
              onSelected: (v) {
                if (v != null) onAlgoChanged(v);
              },
              dropdownMenuEntries: algos
                  .map((a) => DropdownMenuEntry(value: a, label: a))
                  .toList(),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onNext,
              icon: const Icon(Icons.play_arrow),
              label: const Text("Run Simulation"),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Result Screen + Algorithms
// ─────────────────────────────────────────────
// ─────────────────────────────────────────────
// Result Screen + All Algorithms
// ─────────────────────────────────────────────

class ResultScreen extends StatelessWidget {
  final List<ProcessData> processes;
  final String algo;
  final VoidCallback onRestart;

  const ResultScreen({
    super.key,
    required this.processes,
    required this.algo,
    required this.onRestart,
  });

  static GanttData? run(String algo, List<ProcessData> data) {
    switch (algo) {
      case "FCFS":
        return fcfs(data);
      case "SJF":
        return sjf(data);
      case "SRTF":
        return srtf(data);
      case "LJF":
        return ljf(data);
      case "HRRN":
        return hrrn(data);
      case "RoundRobin (QT=2)":
        return roundRobin(data, quantum: 2);
      default:
        return null;
    }
  }

  // ─── Helpers ────────────────────────────────

  static List<ProcessData> _sortedByArrival(List<ProcessData> original) {
    final list = List<ProcessData>.from(original);
    list.sort((a, b) {
      final cmp = a.arrivalTime.compareTo(b.arrivalTime);
      return cmp != 0 ? cmp : a.processId.compareTo(b.processId);
    });
    return list;
  }

  // ─── FCFS ───────────────────────────────────

  static GanttData fcfs(List<ProcessData> original) {
    if (original.isEmpty) {
      return GanttData(ganttList: [], uniqueProcessIds: []);
    }

    final procs = _sortedByArrival(original);
    final gantt = <int>[];
    int currentTime = 0;
    final unique = <int>{};

    for (final p in procs) {
      if (currentTime < p.arrivalTime) {
        final idle = p.arrivalTime - currentTime;
        for (int i = 0; i < idle; i++) {gantt.add(-1);}
        currentTime = p.arrivalTime;
      }

      for (int i = 0; i < p.burstTime; i++) {
        gantt.add(p.processId);
      }
      currentTime += p.burstTime;
      unique.add(p.processId);
    }

    return GanttData(
      ganttList: gantt,
      uniqueProcessIds: unique.toList()..sort(),
    );
  }

  // ─── SJF (Non-preemptive) ───────────────────

  static GanttData sjf(List<ProcessData> original) {
    if (original.isEmpty) {
      return GanttData(ganttList: [], uniqueProcessIds: []);
    }

    final remaining = List<ProcessData>.from(original);
    final gantt = <int>[];
    int currentTime = 0;
    final unique = <int>{};

    while (remaining.isNotEmpty) {
      // Processes that have arrived by currentTime
      final ready = remaining
          .where((p) => p.arrivalTime <= currentTime)
          .toList();

      if (ready.isEmpty) {
        // Jump to next arrival
        final nextArrival =
            remaining.map((p) => p.arrivalTime).reduce((a, b) => a < b ? a : b);
        final idle = nextArrival - currentTime;
        for (int i = 0; i < idle; i++) {gantt.add(-1);}
        currentTime = nextArrival;
        continue;
      }

      // Pick shortest burst time (tie → lowest PID)
      ready.sort((a, b) {
        final cmp = a.burstTime.compareTo(b.burstTime);
        return cmp != 0 ? cmp : a.processId.compareTo(b.processId);
      });
      final chosen = ready.first;

      for (int i = 0; i < chosen.burstTime; i++) {
        gantt.add(chosen.processId);
      }
      currentTime += chosen.burstTime;
      unique.add(chosen.processId);
      remaining.remove(chosen);
    }

    return GanttData(
      ganttList: gantt,
      uniqueProcessIds: unique.toList()..sort(),
    );
  }

  // ─── SRTF (Preemptive SJF) ──────────────────

  static GanttData srtf(List<ProcessData> original) {
    if (original.isEmpty) {
      return GanttData(ganttList: [], uniqueProcessIds: []);
    }

    // remaining burst times
    final rem = <int, int>{};
    for (final p in original) {
      rem[p.processId] = p.burstTime;
    }

    final gantt = <int>[];
    int currentTime = 0;
    final unique = <int>{};
    final totalBurst = original.fold<int>(0, (s, p) => s + p.burstTime);

    while (gantt.length < totalBurst || rem.values.any((v) => v > 0)) {
      // Ready processes at currentTime
      final ready = original
          .where((p) =>
              p.arrivalTime <= currentTime && (rem[p.processId] ?? 0) > 0)
          .toList();

      if (ready.isEmpty) {
        // Find next arrival of any unfinished process
        final future = original
            .where((p) =>
                p.arrivalTime > currentTime && (rem[p.processId] ?? 0) > 0)
            .map((p) => p.arrivalTime)
            .toList();
        if (future.isEmpty) break;

        final next = future.reduce((a, b) => a < b ? a : b);
        final idle = next - currentTime;
        for (int i = 0; i < idle; i++){ gantt.add(-1);}
        currentTime = next;
        continue;
      }

      // Shortest remaining time (tie → lowest PID)
      ready.sort((a, b) {
        final ra = rem[a.processId]!;
        final rb = rem[b.processId]!;
        final cmp = ra.compareTo(rb);
        return cmp != 0 ? cmp : a.processId.compareTo(b.processId);
      });
      final chosen = ready.first;
      final pid = chosen.processId;

      gantt.add(pid);
      rem[pid] = rem[pid]! - 1;
      unique.add(pid);
      currentTime++;
    }

    return GanttData(
      ganttList: gantt,
      uniqueProcessIds: unique.toList()..sort(),
    );
  }

  // ─── LJF (Non-preemptive) ───────────────────

  static GanttData ljf(List<ProcessData> original) {
    if (original.isEmpty) {
      return GanttData(ganttList: [], uniqueProcessIds: []);
    }

    final remaining = List<ProcessData>.from(original);
    final gantt = <int>[];
    int currentTime = 0;
    final unique = <int>{};

    while (remaining.isNotEmpty) {
      final ready = remaining
          .where((p) => p.arrivalTime <= currentTime)
          .toList();

      if (ready.isEmpty) {
        final nextArrival =
            remaining.map((p) => p.arrivalTime).reduce((a, b) => a < b ? a : b);
        final idle = nextArrival - currentTime;
        for (int i = 0; i < idle; i++) {gantt.add(-1);}
        currentTime = nextArrival;
        continue;
      }

      // Longest burst time (tie → lowest PID)
      ready.sort((a, b) {
        final cmp = b.burstTime.compareTo(a.burstTime); // reverse
        return cmp != 0 ? cmp : a.processId.compareTo(b.processId);
      });
      final chosen = ready.first;

      for (int i = 0; i < chosen.burstTime; i++) {
        gantt.add(chosen.processId);
      }
      currentTime += chosen.burstTime;
      unique.add(chosen.processId);
      remaining.remove(chosen);
    }

    return GanttData(
      ganttList: gantt,
      uniqueProcessIds: unique.toList()..sort(),
    );
  }

  // ─── HRRN (Highest Response Ratio Next) ─────

  static GanttData hrrn(List<ProcessData> original) {
    if (original.isEmpty) {
      return GanttData(ganttList: [], uniqueProcessIds: []);
    }

    final remaining = List<ProcessData>.from(original);
    final gantt = <int>[];
    int currentTime = 0;
    final unique = <int>{};

    while (remaining.isNotEmpty) {
      final ready = remaining
          .where((p) => p.arrivalTime <= currentTime)
          .toList();

      if (ready.isEmpty) {
        final nextArrival =
            remaining.map((p) => p.arrivalTime).reduce((a, b) => a < b ? a : b);
        final idle = nextArrival - currentTime;
        for (int i = 0; i < idle; i++) {gantt.add(-1);}
        currentTime = nextArrival;
        continue;
      }

      // Response Ratio = (Waiting Time + Burst Time) / Burst Time
      // Waiting Time = currentTime - arrivalTime
      ready.sort((a, b) {
        final waitA = currentTime - a.arrivalTime;
        final waitB = currentTime - b.arrivalTime;
        final rrA = (waitA + a.burstTime) / a.burstTime;
        final rrB = (waitB + b.burstTime) / b.burstTime;
        final cmp = rrB.compareTo(rrA); // highest first
        return cmp != 0 ? cmp : a.processId.compareTo(b.processId);
      });
      final chosen = ready.first;

      for (int i = 0; i < chosen.burstTime; i++) {
        gantt.add(chosen.processId);
      }
      currentTime += chosen.burstTime;
      unique.add(chosen.processId);
      remaining.remove(chosen);
    }

    return GanttData(
      ganttList: gantt,
      uniqueProcessIds: unique.toList()..sort(),
    );
  }

  // ─── Round Robin (Quantum = 2) ──────────────

  static GanttData roundRobin(List<ProcessData> original, {int quantum = 2}) {
    if (original.isEmpty) {
      return GanttData(ganttList: [], uniqueProcessIds: []);
    }

    // remaining burst
    final rem = <int, int>{};
    for (final p in original) {
      rem[p.processId] = p.burstTime;
    }

    final gantt = <int>[];
    int currentTime = 0;
    final unique = <int>{};

    // Ready queue (FIFO)
    final queue = <int>[]; // process IDs
    final arrived = <int>{};

    // Helper to add newly arrived processes
    void addArrived() {
      for (final p in original) {
        if (p.arrivalTime <= currentTime &&
            !arrived.contains(p.processId) &&
            (rem[p.processId] ?? 0) > 0) {
          queue.add(p.processId);
          arrived.add(p.processId);
        }
      }
    }

    addArrived();

    while (rem.values.any((v) => v > 0)) {
      if (queue.isEmpty) {
        // Jump to next arrival
        final future = original
            .where((p) =>
                p.arrivalTime > currentTime && (rem[p.processId] ?? 0) > 0)
            .map((p) => p.arrivalTime)
            .toList();
        if (future.isEmpty) break;

        final next = future.reduce((a, b) => a < b ? a : b);
        final idle = next - currentTime;
        for (int i = 0; i < idle; i++) {gantt.add(-1);}
        currentTime = next;
        addArrived();
        continue;
      }

      final pid = queue.removeAt(0);
      final runTime = (rem[pid]! < quantum) ? rem[pid]! : quantum;

      for (int i = 0; i < runTime; i++) {
        gantt.add(pid);
        currentTime++;
        rem[pid] = rem[pid]! - 1;
        unique.add(pid);

        // Check for new arrivals during this quantum
        addArrived();
      }

      // If still has remaining time → put back at end of queue
      if (rem[pid]! > 0) {
        queue.add(pid);
      }
    }

    return GanttData(
      ganttList: gantt,
      uniqueProcessIds: unique.toList()..sort(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = run(algo, processes);

    return Scaffold(
      appBar: AppBar(
        title: Text("Result – $algo"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.icon(
              onPressed: onRestart,
              icon: const Icon(Icons.restart_alt),
              label: const Text("Restart"),
            ),
          ),
        ],
      ),
      body: result == null
          ? const Center(
              child: Text(
                "Unknown algorithm.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : GanttChart(data: result),
    );
  }
}
// ─────────────────────────────────────────────
// Gantt Chart UI
// ─────────────────────────────────────────────

class GanttChart extends StatelessWidget {
  final GanttData data;
  static const scale = 18.0;

  static final colorMap = <int, Color>{
    -1: Colors.grey.shade300, // idle
    0: Colors.blue,
    1: Colors.red,
    2: Colors.green,
    3: Colors.purple,
    4: Colors.brown,
    5: Colors.lime,
    6: Colors.pink,
    7: Colors.cyan,
    8: Colors.orange,
    9: Colors.amber,
  };

  const GanttChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final length = data.ganttList.length;
    if (length == 0) {
      return const Center(child: Text("No data to display"));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Legend
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  ...data.uniqueProcessIds.map((id) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20,
                          height: 14,
                          color: colorMap[id] ?? Colors.black,
                        ),
                        const SizedBox(width: 6),
                        Text("P$id"),
                      ],
                    );
                  }),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 20,
                        height: 14,
                        color: colorMap[-1],
                      ),
                      const SizedBox(width: 6),
                      const Text("Idle"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Process bars
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bars
                Row(
                  children: data.ganttList.map((id) {
                    return Container(
                      width: scale,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colorMap[id] ?? Colors.black,
                        border: Border.all(color: Colors.black12, width: 0.5),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 4),
                // Time markers (every unit)
                Row(
                  children: List.generate(length + 1, (t) {
                    return SizedBox(
                      width: scale,
                      child: Text(
                        "$t",
                        style: const TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Total time units: $length",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
