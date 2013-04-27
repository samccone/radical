var Schema = null;

exports.set = function(app, schema) {
  Schema = schema;

  app.get('/events', getEvents);
  app.post('/events/create', createEvent);
  app.get('/', homePage);
}


function getEvents(req, res) {
  Schema.Event.all(function(e, d) {
    res.json(d);
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

function buildAndCreateEvent(cal, data, cb) {
  data.duration = {form: data.from,  to: data.to};
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
