var rgbHelper = require("../util/rgb-helpers");

var Schema = null;

exports.set = function(app, schema) {
  Schema = schema;

  app.get('/auth', loginPage);

  app.get('/', generateCal);

  app.get("/cal/edit/:id", homePage);
  app.post("/cal/edit/:id", updateCalStyles);

  app.get('/client', clientExample);
  app.get('/events', getEvents);
  app.get('/events/:id', getAllEventsById);

  app.post('/events/create', createEvent);

  app.get('/embed/js/:id.js', getJS);
  app.get('/embed/css/:id.css', getCSS);
}

function updateCalStyles(req, res) {
  Schema.Calendar.find(req.params.id, function (e, d) {
    d.updateAttributes(req.body, function(e, d) {
      res.json(d);
    });
  });
}

function getCalInfo(id, cb){
  Schema.Calendar.all({where: {id: id}}, cb);
}

function generateCal(req, res) {
  Schema.Calendar.create(function(e, d) {
    res.redirect("/cal/edit/"+d._id);
  });
};

function getEvents(req, res) {
  Schema.Event.all(function(e, d) {
    res.json(formatEvents(d));
  });
}

function getAllEventsById(req, res) {
  Schema.Event.all({where: {calendar_id: req.params.id}}, function(e, d) {
    res.json(formatEvents(d));
  });
}

function createEvent(req, res) {
  buildAndCreateEvent(req.body, function(err, d) {
    res.json(d);
  });
}

function getEventsById(id, cb) {
  Schema.Event.all({where: {calendar_id: id}}, cb);
}

function formatEvents(events) {
  var toReturn = {};
  events.forEach(function(d) {
    _d = d.date;
    toReturn[_d.getFullYear()] = toReturn[_d.getFullYear()] || {};
    toReturn[_d.getFullYear()][_d.getMonth()] = toReturn[_d.getFullYear()][_d.getMonth()] || [];
    toReturn[_d.getFullYear()][_d.getMonth()].push(d);
  });

  return toReturn;
}

function buildAndCreateEvent(data, cb) {
  data.date = new Date(parseInt(data.date))
  Schema.Event.create(data, cb);
}

function createCalendar(cb) {
  console.log("creating new cal".yellow);
  Schema.Calendar.create(cb);
}

var path = require('path'),
    fs = require('fs'),
    stylus = require('stylus'),
    Snockets = require('snockets'),
    roots_css = require('roots-css'),
    jsp = require("uglify-js").parser,
    pro = require("uglify-js").uglify;

function getJS(req, res){

  // compile javascript
  var snockets = new Snockets();
  var coffee_file = path.join(__dirname, '../assets/js/client.coffee')
  var uncompressed = snockets.getConcatenation(coffee_file, { async: false });

  // compress it
  // CANT DO THIS BECAUSE OF WRONG DOCS WTF
  // var ast = jsp.parse(uncompressed);
  // ast = pro.ast_mangle(ast);
  // ast = pro.ast_squeeze(ast);
  // var compressed_js = pro.gen_code(ast);

  getEventsById(req.params.id, function(err, events){
    events = formatEvents(events);
    var injector = "window.events = " + JSON.stringify(events) + ";" + uncompressed + "var css = document.createElement('link'); css.rel = 'stylesheet'; css.href = 'http://jenius-radical.jit.su/embed/css/" + req.params.id + ".css'; document.head.appendChild(css)";
    res.header('Content-Type', 'application/x-javascript');
    res.send(injector);
  });

}

function getCSS(req, res){

  var config = {
    colors: {
      header: new stylus.nodes.RGBA(245,77,78,1),
      background: new stylus.nodes.RGBA(255,255,255,1),
      hilight: new stylus.nodes.RGBA(230,243,255,1)
    },
    fonts: 'Open Sans'
  }

  getCalInfo(req.params.id, function(err, config){

    // compile main.styl and compress
    var css_path = path.join(__dirname, '../assets/css')
    var styl = fs.readFileSync(path.join(css_path, 'client.styl'), 'utf8');

    stylus(styl)
      .set('compress', true)
      .include(css_path)
      .use(roots_css())
      .define('header-color', transform(config[0].headerColor))
      .define('background-color', transform(config[0].backgroundColor))
      .define('hilight-color', transform(config[0].highlightColor))
      .define('fonts', config[0].fonts)
      .render(function(err, compiled){
        err && console.error(err);
        res.header('Content-Type', 'text/css');
        res.send(compiled);
      });

  });

  function transform(a){
    var b = JSON.parse(a).concat([1])
    return new stylus.nodes.RGBA(b[0], b[1], b[2], b[3])
  }

}

/*
 * GET home page.
 */
function homePage(req, res) {
  Schema.Calendar.all({where: {id: req.params.id}}, function(e, d) {
    res.render('index', {
      cal_id: req.params.id,
      headerColor: rgbHelper.rgbToHex(d[0].headerColor),
      backgroundColor: rgbHelper.rgbToHex(d[0].backgroundColor),
      highlightColor: rgbHelper.rgbToHex(d[0].highlightColor),
      fonts: d[0].fonts
    });
  });
}

function clientExample(req, res) {
  res.render('client', { title: 'Express' });
}

function loginPage(req, res) {
  res.render('login', { title: 'Express' });
}
