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

    // COLOR BASE
    var c = color(100);
    fill(c);
    if (client) {
        for (var i = 0; i < 100; i++) {
            noStroke();
            ellipse(client[i].LocX*35,client[i].LocY*35,10,10);
            fill(c);
            textSize(12);
            text(str(client[i].NewIdTask),client[i].LocX*35+5,client[i].LocY*35);
        }
    }
}

function Test() {

    timer.html(counter);

    console.log("-------- RUN GUARD --------");
    console.log(data[counter].score);

    var newc =  color(0, 164, 178);
    push();
    fill(newc);
    this.x = data[counter].loc_x*35;
    this.y = data[counter].loc_y*35;
    ellipse(this.x,this.y,5,5);
    pop();

    this.r = data[counter].score*35;
    fill(0, 164, 178,100);
    noStroke();
    ellipse(this.x,this.y,this.r,this.r);

    counter++;


}

