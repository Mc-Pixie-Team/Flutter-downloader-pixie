import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as path;

typedef Cfunc = Int32 Function(Int32, Int32);
typedef Dartfunc = int Function(int, int);


class DC {

int at() {

  print("Opening.....");
  final lib = DynamicLibrary.open(path.join(Directory.current.path, 'bin', 'dc_sdk',  'NativeLibrary.dll'));

  print("Associating.....");
  Pointer<NativeFunction<Cfunc>> cadd = lib.lookup<NativeFunction<Cfunc>>('add');
  Dartfunc add = cadd.asFunction<Dartfunc>();

  print("Calling.....");
  final result = add(5, 3);
    if (result == 8)
    {
        print("Hoorah! the result is $result, this is correct");
    }
    else
    {
        print("Oops something is wrong the result is $result");
    }

 return 0;

}

}
