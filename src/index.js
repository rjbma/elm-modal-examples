require('./main.css');
require("./menu.css");
var logoPath = require('./logo.svg');
var Elm = require('./Main.elm');

var root = document.getElementById('root');

Elm.Main.embed(root, logoPath);
