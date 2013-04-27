var Schema = null;
exports.set = function(app, schema) {
  Schema = schema;

  app.get('/', homePage);
  app.post('/events/create', createEvent);
}

function createEvent(req, res) {
  Schema.Calendar.findOne(req.body.calendar_id, function(err, cal) {
    if (cal === null) {
      createCalendar(function(err, cal) {
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

function buildAndCreateEvent(cal, data, cb) {
  data.duration = +data.from - +data.to;
  cal.events.create(data, cb);
}

function createCalendar(cb) {
  Schema.Calendar.create(cb);
}

/*
 * GET home page.
 */
function homePage(req, res) {
  res.render('index', { title: 'Express' });
}
