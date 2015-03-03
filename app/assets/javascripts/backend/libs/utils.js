App.clone = function(array) {
  var newObj = (array instanceof Array) ? [] : {};
  for (i in array) {
    if (i == 'clone') continue;
    if (array[i] && typeof array[i] == "object") {
      newObj[i] = App.clone(array[i]);
    } else newObj[i] = array[i]
  }
  return newObj;
};

(function($) {
  $.fn.removeClassRegEx = function(regex) {
    var classes = $(this).attr('class');
    if(!classes || !regex) return false;
    var classArray = [];
    classes = classes.split(' ');
    for(var i=0, len=classes.length; i<len; i++)
      if(!classes[i].match(regex)) classArray.push(classes[i])
    $(this).attr('class', classArray.join(' '));
  };
})(jQuery);

function getUrlVars()
{
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}
