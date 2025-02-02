import 'dart:io';

import 'parser.dart';

class Instruction {
  static const int increment = 62;
  static const int decrement = 60;
  static const int add = 43;
  static const int subtract = 45;
  static const int output = 46;
  static const int input = 44;
  static const int startLoop = 91;
  static const int endLoop = 93;

  static void process(Machine machine) {
    switch (machine.program[machine.instructionPointer]) {
      case increment:
        dataPointerIncrement(machine);
        break;
      case decrement:
        dataPointerDecrement(machine);
        break;
      case add:
        dataIncrement(machine);
        break;
      case subtract:
        dataDecrement(machine);
        break;
      case output:
        outputImpl(machine);
        break;
      case input:
        inputImpl(machine);
        break;
      case startLoop:
        startLoopImpl(machine);
        break;
      case endLoop:
        endLoopImpl(machine);
        break;
      case _:
        // Unimplemented - do nothing!
        break;
    }
    machine.instructionPointer++;
  }

  static void dataPointerIncrement(Machine machine) {
    machine.dataPointer++;
  }

  static void dataPointerDecrement(Machine machine) {
    machine.dataPointer--;
  }

  static void dataIncrement(Machine machine) {
    machine.data++;
  }

  static void dataDecrement(Machine machine) {
    machine.data--;
  }

  static void outputImpl(Machine machine) {
    print(String.fromCharCode(machine.data));
  }

  static void inputImpl(Machine machine) {
    machine.data = stdin.readByteSync();
  }

  static void startLoopImpl(Machine machine) {
    if (machine.data == 0) {
      final nextEndLoop = machine.program
          .indexWhere((inst) => inst == endLoop, machine.dataPointer);
      if (nextEndLoop != -1) {
        machine.returnAddress = machine.instructionPointer;
        machine.instructionPointer = nextEndLoop;
      }
    }
  }

  static void endLoopImpl(Machine machine) {
    if (machine.data != 0) {
    } else {
      machine.instructionPointer = machine.returnAddress;
      machine.returnAddress = 0;
    }
  }
}
