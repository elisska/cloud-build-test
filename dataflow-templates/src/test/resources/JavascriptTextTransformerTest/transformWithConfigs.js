/**
 * A good transform function with configs.
 * @param {string} inJson
 * @return {string} outJson
 */
function transform(inJson, config) {
  var obj = JSON.parse(inJson);
  var conf = JSON.parse(config);
  obj.someConf = conf.someConf;
  return JSON.stringify(obj)
}

