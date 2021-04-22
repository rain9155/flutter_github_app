import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/utils/log_util.dart';
import 'callback.dart';
import 'constant.dart';

const tag = 'method';

Future runBlockCaught(Function block, {
  ErrorCallback onError
}) async{
  try{
    return await block?.call();
  }on ApiException catch(e, stack){
    LogUtil.printString(tag, 'runBlockCaught: e = $e, stack = $stack');
    return onError?.call(e.code, e.msg);
  } catch(e, stack){
    LogUtil.printString(tag, 'runBlockCaught: e = $e, stack = $stack');
    return onError?.call(CODE_UNKNOWN_ERROR, e.toString());
  }
}