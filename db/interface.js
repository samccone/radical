var Schema    = require('jugglingdb').Schema;
var db        = null;
var colors    = require('colors');

exports.connect = function(cb) {
  db = new Schema('mongodb', {
    url: process.env['db'] || 'mongodb://localhost/db'
  });

  db.on('connected', function() {
    console.log("º DB Connected".green);
    getAndSetSchemas(cb);
  });
}

function getAndSetSchemas(cb) {
  var Event = db.define("Event", {
    location: String,
    info: String,
    date: {type: Date, default: Date.now}
  });

  var Calendar = db.define("Calendar", {});
  Calendar.hasMany(Event, {as: "events", foreignKey: "calendar_id"});

  cb(null, {
    Calendar: Calendar,
    Event: Event
  });
}
