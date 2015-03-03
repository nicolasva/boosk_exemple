App.clone = function(array) {
    var newObj = (array instanceof Array) ? [] : {};
    for (i in array) {
	if (i == 'clone') continue;
	if (array[i] && typeof array[i] == "object") {
	    newObj[i] = App.clone(array[i]);
	} else newObj[i] = array[i]
    } return newObj;
};