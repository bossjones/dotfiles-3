function github(query, opts) {
  opts = opts || {};
  opts.url = opts.url || 'https://github.com';

  var q = [];
  var l;
  var type;

  query.split(/\s+/).forEach(function(value) {
    var m = value.trim().match(/^(.+)\:(.*)$/);
    var k = m && m[1];
    var v = m && m[2];

    if (k == 'lang') {
      l = v;
    } else if (k == 'type') {
      type = v == 'repo' ? 'Repositories' : v;
    } else {
      q.push(value);
    }
  });

  var url = opts.url + '/search?utf8=%E2%9C%93';
  url += '&q=' + encodeURIComponent(q.join(' '));
  if (type) url += '&type=' + encodeURIComponent(type);
  if (l) url += '&l=' + encodeURIComponent(l);

  return url;
}
