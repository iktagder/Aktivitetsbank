require('./main.css')
require('file?name=/images/elm.png!../images/elm.png')
require('ace-css/css/ace.css')

var Elm = require('./Main.elm')

var configuredLogo = '#{Logo}'
var logo = (configuredLogo[0] !== '#') ? configuredLogo : './src/vaf-logo.png'

var configuredApiUrl = '#{ApiUrl}'
var apiUrl = (configuredApiUrl[0] !== '#') ? configuredApiUrl : API_URL

Elm.Main.embed(document.getElementById('root'), {
  currentTime: Date.now(),
  apiEndpoint: apiUrl,
  vafLogo: logo
})
