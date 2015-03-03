App.clone = function(array) {
    var newObj = (array instanceof Array) ? [] : {};
    for (i in array) {
	if (i == 'clone') continue;
	if (array[i] && typeof array[i] == "object") {
	    newObj[i] = App.clone(array[i]);
	} else newObj[i] = array[i]
    } return newObj;
};


App.simple_format = function simpleFormat(str) {
    var simpleFormatRE1 = /\r\n?/g;
    var simpleFormatRE2 = /\n\n+/g;
    var simpleFormatRE3 = /([^\n]\n)(?=[^\n])/g;
    var fstr = str;
    fstr = fstr.replace(simpleFormatRE1, "\n")
    fstr = fstr.replace(simpleFormatRE2, "</p>\n\n<p>")
    fstr = fstr.replace(simpleFormatRE3, "$1<br/>")
    fstr = "<p>" + fstr + "</p>";
    return fstr;
};

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