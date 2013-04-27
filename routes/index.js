var Schema = null;
exports.set = function(app, schema) {
  Schema = schema;

  app.get('/', homePage);
  app.post('/events/create', createEvent);
}

function createEvent(req, res) {
  console.log(Schema.Event);
  console.log(req.body);
  buildData = req.body;
  buildData.duration = +req.body.from - +req.body.to
  Schema.Event.create(req.body, function(err, d) {
    res.json(d);
  });
}

/*
 * GET home page.
 */
function homePage(req, res) {
  res.render('index', { title: 'Express' });
}
