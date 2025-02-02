import 'dart:math';
import 'dart:typed_data';
import 'tokens.dart';

const int kMemoryDefault = 30_000;

class Machine {
  Machine({required String input}){
    program = Uint16List.fromList(input.codeUnits);
  }

  Uint8List memory = Uint8List(kMemoryDefault);
  late Uint16List program;
  int instructionPointer = 0;
  int dataPointer = 0;
  int largestAddress = 0;
  int returnAddress = 0;

  int get currentInstruction => program[instructionPointer];

  int get data => memory[dataPointer];
  set data(int value) {
    memory[dataPointer] = value;
    largestAddress = max(largestAddress, dataPointer);
  }

  void run(){
    while(instructionPointer < program.length)
    {
      Instruction.process(this);
    }
  }

  printMemory(){
    print(memory.getRange(0, largestAddress).toList());
  }
  
}
