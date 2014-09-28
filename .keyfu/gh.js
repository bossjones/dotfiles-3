this.link = function(url, queryUrl) {
  if (query) {
    if (!queryUrl) {
      throw new Error('skip');
    }
    this.location = queryUrl.replace(/%s/g, encodeURIComponent(query));
  } else if (url) {
    this.location = url;
  } else {
    throw new Error('skip');
  }
};

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

this.location = 'https://github.com/search?utf8=%E2%9C%93';
this.location += '&q=' + encodeURIComponent(q.join(' '));
if (type) this.location += '&type=' + encodeURIComponent(type);
if (l) this.location += '&l=' + encodeURIComponent(l);
