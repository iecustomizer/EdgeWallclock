self.addEventListener('message', function (e) {
    var data = e.data;
    switch (data.cmd) {
        case 'start':
            init();//self.postMessage('WORKER STARTED: ' + data.msg);
            break;
        case 'stop':
            self.postMessage('WORKER STOPPED: ' + data.msg +
                             '. (buttons will no longer work)');
            self.close(); // Terminates the worker.
            break;
        default:
            init();//PostTick();
            //init();//self.postMessage('Unknown command: ' + data.msg);
    };
}, false);


var Now = new Date();
var Start = Now;
var SecondsCount = 0;
var Seconds = Now.getSeconds();
var Minutes = Now.getMinutes();
var Hours = Now.getHours() + Minutes / 60;
function PostTick() {
    Now = new Date();
    if (Start == 0) { Start = Now; }
    SecondsCount += 1;
    Seconds = Now.getSeconds();
    Minutes = Now.getMinutes();
    Hours = Now.getHours() + Minutes / 60;
    var tick = {};
    tick.starttime = Start;
    tick.secondscount = SecondsCount;
    tick.seconds = Seconds;
    tick.minutes = Minutes;
    tick.hours = Hours;
    postMessage(tick);
}
function init() {
    setTimeout(PostTick(), 1000);

}

