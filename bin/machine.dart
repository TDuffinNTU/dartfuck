import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'instruction.dart';

const int kMemoryDefault = 30_000;

class Machine {
  Machine({required String input}){
    program = Uint16List.fromList(input.codeUnits);
  }

  Uint8List memory = Uint8List(kMemoryDefault);
  
  /// The ROM.
  late Uint16List program;

  /// Current location of the instruction pointer, indexed into the program ROM.
  int instructionPointer = 0;

  /// Current location of the data pointer, indexed into memory.
  int dataPointer = 0;

  /// Largest cell written to, for convenience when debugging.
  int largestAddress = 0;

  /// Stack of return addresses for loops.
  List<int> returnStack = [];

  /// The current instruction being fetched/executed.
  int get currentInstruction => program[instructionPointer];

  /// Gets and Sets the value at [dataPointer].
  int get data => memory[dataPointer];
  set data(int value) {
    memory[dataPointer] = value;
    largestAddress = max(largestAddress, dataPointer);
  }

  /// Iterate through the [program] until out of instructions.
  void run(){
    while(instructionPointer < program.length)
    {
      Instruction.process(this);
    }

    // Otherwise next print() will start on same line as output.
    stdout.writeln();
  }

  @override
  String toString(){
    // Returns the largest memory addr written to.
    return memory.getRange(0, largestAddress+1).toString();
  }  
}
