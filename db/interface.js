var Schema    = require('jugglingdb').Schema;
var db        = null;
var colors    = require('colors');

exports.connect = function(cb) {
  db = new Schema('mongodb', {
    url: process.env['DB'] || 'mongodb://localhost/db'
  });

  db.on('connected', function() {
    console.log("º DB Connected".green);
    getAndSetSchemas(cb);
  });
}

function getAndSetSchemas(cb) {
  var Event = db.define("Event", {
    location: String,
    name: String,
    from: String,
    to: String,
    date: {type: Date, default: Date.now},
    calendar_id: String
  });

  var Calendar = db.define("Calendar", {
    headerColor: String,
    backgroundColor: String,
    highlightColor: String,
    fonts: String
  });

  cb(null, {
    Calendar: Calendar,
    Event: Event
  });
}
