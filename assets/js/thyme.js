// Generated by CoffeeScript 1.5.0
(function() {
  var Thyme;

  Thyme = (function() {

    function Thyme(node) {
      if (typeof node === "undefined") {
        throw "you must pass a dom node";
      }
      this.node = node;
      this.currentDate = moment(new Date);
      this.render();
    }

    Thyme.prototype.getDay = function(day) {
      return this.node.getElementsByTagName("td")[this.monthShift() + day - 1];
    };

    Thyme.prototype.renderedMonth = function() {
      return {
        month: this.currentDate.month(),
        year: this.currentDate.year()
      };
    };

    Thyme.prototype.nextMonth = function() {
      this.currentDate = this.currentDate.add('months', 1);
      return this.render();
    };

    Thyme.prototype.prevMonth = function() {
      this.currentDate = this.currentDate.subtract('months', 1);
      return this.render();
    };

    Thyme.prototype.monthShift = function() {
      return moment("" + (this.currentDate.year()) + "-" + (this.currentDate.month() + 1) + "-1").day();
    };

    Thyme.prototype._buildMonthHeader = function() {
      var monthHeader, row1;
      monthHeader = document.createElement('th');
      monthHeader.setAttribute('colspan', "7");
      monthHeader.innerHTML = this.currentDate.format("MMMM");
      row1 = document.createElement('tr');
      prev = document.createElement('div');
      prev.className = 'prev';
      prev.innerHTML = '&laquo;'
      next = document.createElement('div');
      next.className = 'next';
      next.innerHTML = '&raquo;'
      monthHeader.appendChild(prev);
      monthHeader.appendChild(next);
      row1.appendChild(monthHeader);
      row1.className = 'month';
      return row1;
    };

    Thyme.prototype._buildDayOfWeekHeader = function() {
      var dow, dowHeader, row2, _i, _len, _ref;
      row2 = document.createElement('tr');
      _ref = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        dow = _ref[_i];
        dowHeader = document.createElement('th');
        dowHeader.innerHTML = dow;
        row2.className = 'days';
        row2.appendChild(dowHeader);
      }
      return row2;
    };

    Thyme.prototype.render = function() {
      var cell, day, dayOfWeek, days, row, table, week, _i, _j, _k, _ref, _ref1, _results;
      table = document.createElement("table");
      table.appendChild(this._buildMonthHeader());
      table.appendChild(this._buildDayOfWeekHeader());
      days = (function() {
        _results = [];
        for (var _i = 1, _ref = this.currentDate.daysInMonth() + 1; 1 <= _ref ? _i < _ref : _i > _ref; 1 <= _ref ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this);
      for (week = _j = 1, _ref1 = this.currentDate.daysInMonth() + this.monthShift() + 1; _j < _ref1; week = _j += 7) {
        row = document.createElement("tr");
        for (day = _k = 0; _k < 7; day = ++_k) {
          cell = document.createElement("td");
          dayOfWeek = moment("" + (this.currentDate.year()) + "-" + (this.currentDate.month() + 1) + "-" + days[0]).day();
          if (dayOfWeek === day) {
            cell.innerHTML = days.shift();
          }
          row.appendChild(cell);
        }
        table.appendChild(row);
      }
      this.node.innerHTML = "";
      this.node.appendChild(table);
      return this;
    };

    return Thyme;

  })();

  if (typeof module !== "undefined") {
    module.exports = Thyme;
  } else {
    this.Thyme = Thyme;
  }

}).call(this);
