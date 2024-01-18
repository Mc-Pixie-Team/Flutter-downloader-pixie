import 'dart:io';
import 'package:path/path.dart' as path;

class Utils {
  static Future<void> copyDirectory({required Directory source, required Directory destination}) async {
    
    if(!(await destination.exists())) {
              await destination.create();
          }

      final fileitems = source.list();

      fileitems.listen((fileEntity) async{ 
        final newPath = destination.path + Platform.pathSeparator + path.basename(fileEntity.path);
        if(fileEntity is File) {
         await copyFile( source: fileEntity,  destination: File( newPath));
        }else if(fileEntity is Directory) {
          await copyDirectory(source: fileEntity, destination: Directory(newPath));
        }
      });
  }



    static Future<void> copyFile({required File source, required File destination}) async {
    
          if(!(await destination.exists())) {
              await destination.create();
          }

          if(source.path == destination.path) throw "destination and source have the same path: ${destination.path}";

        final dataStream = destination.openWrite();
        await dataStream.addStream(source.openRead());

        await dataStream.close();
     
  }
}