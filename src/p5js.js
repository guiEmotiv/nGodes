var data;
var client;
var timer;
var counter = 0;
var speed = 1000; // ms
var buttonStart;
var buttonPause;
var buttonStop;
var interval;
var cnv;
var coverage;

function centerCanvas() {
    var x = (windowWidth - width) / 2;
    var y = (windowHeight - height) / 2;
    cnv.position(x, y);
}

function windowResized() {
    centerCanvas();
}

function preload() {
    var url = 'http://localhost:8080/totalEvent';
    data = loadJSON(url);
    console.log(data);

    var urlClient = 'http://localhost:8080/client';
    client = loadJSON(urlClient);
    console.log(client);
}

function startTimer() {
    interval = setInterval(Test, speed);
}

function pauseTimer() {
    clearInterval(interval);
}

function stopTimer() {
    redraw();
}

function setup() {
    cnv = createCanvas(600,600);
    centerCanvas();

    noLoop();

    console.log("------ INICIANDO SIMULADOR ------");

    buttonStart = createButton("START");
    buttonStart.mousePressed(startTimer);

    buttonPause = createButton("PAUSE");
    buttonPause.mousePressed(pauseTimer);

    buttonStop = createButton("STOP");
    buttonStop.mousePressed(stopTimer);

    timer = createP('Counter : [0-100]');
    coverage = createP('Radius Coverage : [0-7.5]');


}

function draw() {
    // background(175,248,255);
    background(200);
    console.log(client);
    console.log(data[1].loc_x,data[1].loc_y);

    var cBase = color(9,113,178);
    fill(cBase);
    text("BASE",client[0].LocX*35-15,client[0].LocY*35-10);

    var c = color(100);
    fill(c);

    if (client) {
        for (var i = 0; i < 100; i++) {
            var textX = client[i].LocX*35-10;
            var variableX = client[i].LocX*35+10;

            if (i < 13) {

                noStroke();
                ellipse(client[i].LocX*35,client[i].LocY*35,10,10);

                var point = str(client[i].NewIdTask);
                fill(c);
                textSize(15);
                text(point,client[i].LocX*35+5,client[i].LocY*35+5);

                var early = str(client[i].NewEarliest);
                fill(c);
                textSize(10);
                text("ear: ",textX,client[i].LocY*35+15);
                text(early,variableX,client[i].LocY*35+15);

                var duration = str(client[i].NewDuration);
                fill(c);
                textSize(10);
                text("dur: ",textX,client[i].LocY*35+25);
                text(duration,variableX,client[i].LocY*35+25);
            }else {
                var alarm = str(int(client[i].NewEarliest));
                var cAlarm = color(178,18,18);
                fill(cAlarm);
                textSize(10);
                text("alr: ",textX,client[i].LocY*35+35);
                text(alarm,variableX,client[i].LocY*35+35);

                var alarmDuration = str(int(client[i].NewDuration));
                var cAlarmDuration = color(178,18,18);
                fill(cAlarmDuration);
                textSize(10);
                text("alr: ",textX,client[i].LocY*35+45);
                text(alarmDuration,variableX,client[i].LocY*35+45);
            }
        }
    }
}

function Test() {

    timer.html(counter);

    console.log("-------- RUN GUARD --------");
    console.log(data[counter].score);

    var evaluate = data[counter].id_task;
    if (evaluate == 1) {
        var newc =  color(0, 164, 178);
        fill(newc);
        this.x = data[counter].loc_x*35;
        this.y = data[counter].loc_y*35;
        ellipse(this.x,this.y,5,5);
    }else if (evaluate == 2) {
        var newcE =  color(255, 0, 0);
        fill(newcE);
        this.x = data[counter].loc_x*35;
        this.y = data[counter].loc_y*35;
        ellipse(this.x,this.y,5,5);
    }






    // this.r = data[counter].score*35;
    // fill(0, 164, 178,100);
    // noStroke();
    // ellipse(this.x,this.y,this.r,this.r);

    counter++;


}

