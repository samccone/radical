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
    headerColor: { type: String, default: '[249,84,85]' },
    backgroundColor: { type: String, default: '[255,255,255]' },
    highlightColor: { type: String, default: '[230,243,255]' },
    fonts: String
  });

  cb(null, {
    Calendar: Calendar,
    Event: Event
  });
}
