// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbograft
//= require bootstrap-datepicker
//= require select2
//= require dynamic_table
//= require_tree .

function display_time(selector, secs_left)
{
    if (secs_left > 0) {
        var hours = Math.floor(secs_left / 3600)
        var after_hours_secs = Math.floor(secs_left % 3600)
        var mins = Math.floor(after_hours_secs / 60)
        var secs = Math.floor(after_hours_secs % 60)

        if (hours <= 9) {
            hours = "0" + hours;
        }

        if (mins <= 9) {
            mins = "0" + mins
        }

        if (secs <= 9) {
            secs = "0" + secs
        }

        secs_left = secs_left - 1

        $(selector).html(hours + ":" + mins + ":" + secs)

        return secs_left;
    }
    else {
        $(selector).html("00:00:00")
        return 0
    }
}

function reload_votes()
{
    window.location = window.location.href.replace(/\/elections\/(\d+)\/votes\/(.*)$/, "/elections/$1/votes")
}