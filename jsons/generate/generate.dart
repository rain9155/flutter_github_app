import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

const TAG="\$";
const JSON_SRC="jsons/"; //json目录
const MODEL_DEST="lib/beans/"; //输出model目录
const TEMPLATE_FILE="jsons/generate/template.dart"; //模版路径

//遍历JSON目录生成模板
void walk() {
  var files = new Directory(JSON_SRC).listSync();
  var template = new File(TEMPLATE_FILE).readAsStringSync();
  files.forEach((f) {
    if (FileSystemEntity.isFileSync(f.path)) {
      File file = new File(f.path);
      var paths = path.basename(f.path).split(".");
      String name = paths.first;
      if(paths.last.toLowerCase() != "json"|| name.startsWith("_")){
        return ;
      }
      //下面生成模板
      var map = json.decode(file.readAsStringSync());
      //为了避免重复导入相同的包，我们用Set来保存生成的import语句。
      var set = new Set<String>();
      StringBuffer attrs = new StringBuffer();
      (map as Map<String, dynamic>).forEach((key, value) {
        if(key.startsWith("_")){
          return ;
        }
        attrs.write('@JsonKey(name: \'$key\')');
        attrs.writeln();
        attrs.write("  ");
        attrs.write(getType(value, set, name));
        attrs.write(" ");
        attrs.write(getName(key));
        attrs.writeln(";");
        attrs.write("  ");
      });
      String className = getClassName(name);
      var dest = format(
          template,
          [name, className, className, attrs.toString(), className, className, className]
      );
      var _import = set.join(";\r\n");
      _import += _import.isEmpty? "" : ";";
      dest = dest.replaceFirst("%t", _import);
      //将生成的模板输出
      new File("$MODEL_DEST$name.dart").writeAsStringSync(dest);
    }
  });
}

//根据json的value获取对应的dart类型
String getType(value, Set<String> set, String current){
  current = current.toLowerCase();
  if(value is bool){
    return "bool";
  }else if(value is int){
    return "int";
  }else if(value is double){
    return "double";
  }else if(value is num){
    return "num";
  }else if(value is Map){
    return "Map<String,dynamic>";
  }else if(value is List){
    return "List<dynamic>";
  }else if(value is String){ //处理特殊标志
    if(value.startsWith("$TAG[]")){
      var className = changeFirstChar(value.substring(3), false);
      if(className.toLowerCase() != current) {
        set.add('import "$className.dart"');
      }
      return "List<${changeFirstChar(className)}>";

    }else if(value.startsWith(TAG)){
      var fileName = changeFirstChar(value.substring(1), false);
      if(fileName.toLowerCase() != current) {
        set.add('import "$fileName.dart"');
      }
      return changeFirstChar(fileName);
    }
    return "String";
  }else{
    return "String";
  }
}

//把json的key转化为骆驼命名法字符串
String getName(String key){
  List<String> splits = key.split('_');
  StringBuffer name = StringBuffer();
  for(int i = 0; i < splits.length; i++){
    String split = splits[i];
    if(i > 0){
      split = changeFirstChar(split);
    }
    name.write(split);
  }
  return name.toString();
}

//把文件名转换为骆驼命名法字符串
String getClassName(String name){
  List<String> splits = name.split('_');
  StringBuffer className = StringBuffer();
  for(int i = 0; i < splits.length; i++){
    String split = splits[i];
    className.write(changeFirstChar(split));
  }
  return className.toString();
}

//把str的第一个字符变为大写或小写
String changeFirstChar(String str, [bool upper = true]){
  return (upper? str[0].toUpperCase() : str[0].toLowerCase()) + str.substring(1);
}

//替换模板占位符
String format(String fmt, List<Object> params) {
  int matchIndex = 0;
  String replace(Match m) {
    if (matchIndex < params.length) {
      switch (m[0]) {
        case "%s":
          return params[matchIndex++].toString();
      }
    } else {
      throw new Exception("Missing parameter for string format");
    }
    throw new Exception("Invalid format string: " + m[0].toString());
  }
  return fmt.replaceAllMapped("%s", replace);
}

void main(){
  walk();
}