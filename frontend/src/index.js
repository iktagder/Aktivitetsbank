require('./main.css');
require('file?name=/images/elm.png!../images/elm.png');
require('ace-css/css/ace.css');


var Elm = require('./Main.elm');

var logo = require('file?name=./src/vaf-logo.svg!../src/vaf-logo.svg');

var configuredApiUrl = "#{ApiUrl}";
apiUrl = (configuredApiUrl[0] !== "#") ? configuredApiUrl : API_URL;

var myJSTestApp = Elm.Main.embed(document.getElementById('root'), {
	currentTime: Date.now(),
	apiEndpoint: apiUrl,
	vafLogo: logo
});
