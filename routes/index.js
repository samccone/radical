var Schema = null;

exports.set = function(app, schema) {
  Schema = schema;

  app.get('/', homePage);
  app.get('/client', clientExample);
  app.get('/events', getEvents);
  app.post('/events/create', createEvent);

  app.get('/embed/js/:id.js', getJS);
  app.get('/embed/css/:id', getCSS);
}


function getEvents(req, res) {
  Schema.Event.all(function(e, d) {
    res.json(formatEvents(d));
  });
}

function createEvent(req, res) {
  Schema.Calendar.findOne(req.body.calendar_id, function(err, cal) {
    if (cal === null) {
      createCalendar(req.body.calendar_id, function(err, cal) {
        buildAndCreateEvent(cal, req.body, function(err, d) {
          res.json(d);
        });
      });
    } else {
      buildAndCreateEvent(cal, req.body, function(err, d) {
        res.json(d);
      });
    }
  });
}

function getEventById(id, cb) {
  Schema.Event.find({where: {calendar_id: id}}, cb);
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

function buildAndCreateEvent(cal, data, cb) {
  data.date = new Date(parseInt(data.date))
  cal.events.create(data, cb);
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

  var events = [
    { whatever: 'whatever' }
  ]

  var injector = "var events = " + JSON.stringify(events) + ";" + uncompressed + "var css = document.createElement('link'); css.rel = 'stylesheet'; css.href = '/embed/css/" + req.params.id + ".css'; document.head.appendChild(css)";
  res.header('Content-Type', 'application/x-javascript');
  res.send(injector);
}

function getCSS(req, res){

  var config = {
    colors: {
      header: new stylus.nodes.RGBA(245,77,78,1),
      background: new stylus.nodes.RGBA(255,255,255,1),
      hilight: new stylus.nodes.RGBA(10,40,200,1)
    },
    fonts: 'Open Sans'
  }

  // compile main.styl and compress
  var css_path = path.join(__dirname, '../assets/css')
  var styl = fs.readFileSync(path.join(css_path, 'main.styl'), 'utf8');

  stylus(styl)
    .set('compress', true)
    .include(css_path)
    .use(roots_css())
    .define('header-color', config.colors.header)
    .define('background-color', config.colors.background)
    .define('hilight-color', config.colors.hilight)
    .define('fonts', config.fonts)
    .render(function(err, compiled){
      err && console.error(err);
      res.header('Content-Type', 'text/css');
      res.send(compiled);
    });

}

/*
 * GET home page.
 */
function homePage(req, res) {
  res.render('index', { cal_id: 1 });
}

function clientExample(req, res) {
  res.render('client', { title: 'Express' });
}
