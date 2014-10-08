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

  var query = { q: q.join(' ') };
  if (type) query.type = type;
  if (l) query.l = l;

  return opts.url + '/search?' + qs.stringify(query);
}
