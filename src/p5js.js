var data;
var spaceData;
function setup() {
    createCanvas(600,600);
    // var url = "http://localhost:3000/areaA";
    var url = "http://localhost:8080/totalEvent";
    loadJSON(url, gotData);
    console.log(gotData);
    console.log("------ INICIANDO SIMULADOR ------");

    button = createButton("RUN");
    button.mousePressed(toggleRun);

}

function toggleRun() {
    console.log("entre");
    // console.log(spaceData[1].cov_by_ids);
    test = str(spaceData[1].cov_by_ids);
    fill(200,220,0);
    textSize(12);
    text(test,300,300);
    text("hola",300,300);

}

function draw() {
    background(240,248,255);
    fill(200,220,0);
    toggleRun();
    // if (spaceData) {
    //     // test = str(spaceData[1].cov_by_ids);
    //     // text(test,300,300);
    // }

}
function gotData(data) {
    // console.log(data[1].cov_by_ids);
    // var s = str(data[1].cov_by_ids);
    spaceData = data;
}



