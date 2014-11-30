{
  var options = arguments[2];
  if(!(options && options.isParseOptions))
    throw new Error("Parser require ParseOptions instance as 3rd argument");

  function safeMergeObject(target, src, resolveCallback) {
    for(var name in src) {
      if(typeof target[name] === 'undefined') {
        target[name] = src[name];
      } else {
        var result;
        if(resolveCallback) {
          result = resolveCallback(name, target[name], src[name]);
          if(typeof result === 'undefined')
            throw new Error('Ambiguous property '+name);
          target[name] = result;
        } else {
          throw new Error('Ambiguous property '+name);
        }
      }
    }
  }

  function merge(dst, src) {
    if (dst == null) dst = {};
    if (src == null) return dst;
    for (var k in src) {
      dst[k] = src[k];
    }
    return dst;
  }

}


START
  = STATEMENTS

