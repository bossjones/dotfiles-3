qs = {};

qs.stringify = function(obj, sep, eq) {
  sep = sep || '&';
  eq = eq || '=';

  var keys = Object.keys(obj);
  var fields = [];

  for (var i = 0; i < keys.length; i++) {
    var key = keys[i];
    var value = obj[key];

    if (Array.isArray(value)) {
      for (var j = 0; j < value.length; j++) {
        fields.push(key + eq + encodeURIComponent(value));
      }
    } else {
      fields.push(key + eq + encodeURIComponent(value));
    }
  }

  return fields.join(sep);
}
