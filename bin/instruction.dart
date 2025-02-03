import 'dart:io';

import 'machine.dart';

/// Implementation of machine instructions.
class Instruction {
  // Instruction values in ASCII.
  static const int increment = 62;
  static const int decrement = 60;
  static const int add = 43;
  static const int sub = 45;
  static const int output = 46;
  static const int input = 44;
  static const int startLoop = 91;
  static const int endLoop = 93;

  /// Fetch, Execute, Increment IP.
  static void process(Machine machine) {
    switch (machine.currentInstruction) {
      case increment:
        dataPointerIncrementImpl(machine);
        break;
      case decrement:
        dataPointerDecrementImpl(machine);
        break;
      case add:
        dataIncrementImpl(machine);
        break;
      case sub:
        dataDecrementImpl(machine);
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
        // Unimplemented/do nothing.
        break;
    }
    machine.instructionPointer++;
  }

  /// Move data ptr right one index.
  static void dataPointerIncrementImpl(Machine machine) {
    machine.dataPointer++;
  }

  /// Move data ptr back one index.
  static void dataPointerDecrementImpl(Machine machine) {
    machine.dataPointer--;
  }

  /// Increment data ptr contents;
  static void dataIncrementImpl(Machine machine) {
    machine.data++;
  }

  /// Decrement data ptr contents;
  static void dataDecrementImpl(Machine machine) {
    machine.data--;
  }

  /// Writes current data ptr content to stdout (converted to ASCII).
  static void outputImpl(Machine machine) {
    //stdout.write(machine.data);
    stdout.writeCharCode(machine.data);
  }

  /// Reads one byte from stdin, writing to current data ptr.
  static void inputImpl(Machine machine) {
    machine.data = stdin.readByteSync();
  }

  /// BZE to *matching* close bracket (`]`) + 1.
  static void startLoopImpl(Machine machine) {
    machine.returnStack.add(machine.instructionPointer);
    if (machine.data == 0) {
      final nextEndLoop = machine.program
          .indexWhere((inst) => inst == endLoop, machine.instructionPointer);
      if (nextEndLoop != -1) {
        machine.instructionPointer = nextEndLoop;
      }
    }
  }

  /// BNZ to *matching* open bracket (`[`)+ 1.
  static void endLoopImpl(Machine machine) {
    final returnAddress = machine.returnStack.removeLast();
    if (machine.data != 0) {
      machine.instructionPointer = returnAddress - 1;
    }
  }
}
