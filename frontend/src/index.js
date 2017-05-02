require('./main.css');
require('file?name=/images/elm.png!../images/elm.png');

var Elm = require('./Main.elm');

var myJSTestApp = Elm.Main.embed(document.getElementById('root'), {
	currentTime: Date.now(),
	apiEndpoint: API_URL
});
