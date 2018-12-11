//@@@ Pass from Java when possible
var params = {typ: '', mts: ['m1','m2']};

// @@ Remove when we can pass params direct from Java
function m1(l) {params.typ='m1'; return filterAndTransform(l, JSON.stringify(params));}
function m2(l) {params.typ='m2'; return filterAndTransform(l, JSON.stringify(params));}


// Make sure message type is one of our known list, otherwise error
function checkMessageType(mt, mts) {
  if(mts.indexOf(mt)<0) {
    throw ('Unknown message type: '+mt);
  }
}

function isObject(obj) {
  return obj === Object(obj) && !Array.isArray(obj);
}

function replaceInvalidCharacters(str) {
  return str.replace(/[\W]+/g, "_")
}

function checkAndReplaceInvalidKey(key, inputJSON){
  var newKey = replaceInvalidCharacters(key);
  if(newKey !== key){
    inputJSON[newKey] = inputJSON[key];
    delete inputJSON[key];
  }
}

function fixJSONKeys(inputJSON){
  Object.keys(inputJSON).forEach(function(key){
    if(!isObject(inputJSON[key])) checkAndReplaceInvalidKey(key, inputJSON);
    else fixJSONKeys(inputJSON[key]);
  });
  return inputJSON;
}

// Just flatten _m and adding _p.
function flatten(msg) {
  var m1={};
  Object.keys(msg._m).forEach(function(k){m1[k] = msg._m[k];});
  // Object.keys(msg._p).forEach(function(k){m1[k] = msg._p[k];});  // Remove if _p flatting is not needed
  m1._p = msg._p
  return m1;
}

function filterAndTransform(line, p) {
  var res='';

  // Parse text into object
  var msg = JSON.parse(line);
  var params = JSON.parse(p.split("'").join('"'));

  // Check for invalid message type if I'm filtering for first type
  if(params.typ === params.mts[0]) checkMessageType(msg._m._mt, params.mts);

  // Filter & flatten
  if(msg._m._mt === params.typ) res = JSON.stringify(fixJSONKeys(flatten(msg)));
  return res;
}
