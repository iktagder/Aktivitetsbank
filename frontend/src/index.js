require('./main.css');
require('file?name=/images/elm.png!../images/elm.png');
require('ace-css/css/ace.css');

var Elm = require('./Main.elm');

var configuredApiUrl = "#{ApiUrl}";
apiUrl = (configuredApiUrl[0] !== "#") ? configuredApiUrl : API_URL;

var myJSTestApp = Elm.Main.embed(document.getElementById('root'), {
	currentTime: Date.now(),
	apiEndpoint: apiUrl
});
