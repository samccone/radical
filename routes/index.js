var Schema = null;

exports.set = function(app, schema) {
  Schema = schema;

  app.get('/', homePage);
  app.get('/client', clientExample);
  app.get('/events', getEvents);
  app.post('/events/create', createEvent);
  app.get('/', homePage);
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

function formatEvents(events) {
  var toReturn = {};
  events.forEach(function(d) {
    _d = d.date;
    toReturn[_d.getFullYear()] = toReturn[_d.getFullYear()] || {};
    toReturn[_d.getFullYear()][_d.getDate()] = toReturn[_d.getFullYear()][_d.getDate()] || [];
    toReturn[_d.getFullYear()][_d.getDate()].push(d);
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

/*
 * GET home page.
 */

function homePage(req, res) {
  res.render('index', { cal_id: 1 });
}

function clientExample(req, res) {
  res.render('client', { title: 'Express' });
}
