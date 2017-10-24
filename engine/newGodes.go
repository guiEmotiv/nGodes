package engine

import (
	"fmt"
	"io/ioutil"
	"encoding/json"
	"math"
	"sort"
)

func GetNews(v []NewFormatTasks) (test []GetPlan) {

	// SORT by Earliest
	sortByEar := v[:]
	sort.Sort(byEarliest(sortByEar))
	fmt.Println("sort plan by earliest: ",sortByEar)
	//EveryTime := make([]float64,len(sortByEar))

	// Make slice Ordinary && Emergency
	// ordinary tasks assume clock 100 step 1 && guard 1 && 3 state E1 E2 E3

	for i := 0; i < len(v) - 1; i++ {
		vTT = 100
		vTS = sortByEar[0].LocX

		if vTT > vTS {



		}





		//startVirtualTime := sortByEar[0].NewEarliest
		posInicialGlobalX := sortByEar[i].LocX
		posInicialGlobalY := sortByEar[i].LocY
		posFinalGlobalX := sortByEar[i+1].LocX
		posFinalGlobalY := sortByEar[i+1].LocY
		dist := distance(posInicialGlobalX,posInicialGlobalY,posFinalGlobalX,posFinalGlobalY)

		for k := 0.0; k < dist -1; k++ {
			dist := distance(posInicialGlobalX,posInicialGlobalY,posFinalGlobalX,posFinalGlobalY)
			newX1 = posInicialGlobalX
			newY1 = posInicialGlobalY
			newX2 = newX1 + (posFinalGlobalX - posInicialGlobalX) / dist
			newY2 = newY1 + (posFinalGlobalY - posInicialGlobalY) / dist
			posInicialGlobalX = newX2
			posInicialGlobalY = newY2
			distq = distance(newX1,newY1,newX2,newY2)
			//fmt.Println(distq)
			stepTime = stepTime + 1.0
			vTT = vTT - 1.0
			//fmt.Println(virtualTimeTotal)


			for _, v := range StorePlan { test = append(test, v) }
			StorePlan["fe"] = GetPlan{stepTime,vTT,1,StepPos{newX2,newY2,distq},re}
		}

		fmt.Println(StorePlan)
	}
	return
}

func getPoints(x1, y1, x2, y2 float64) (newx2, newy2, q float64) {

	var newx1, newy1 float64
	d := distance(x1,y1,x2,y2)
	//var q float64

	for i := 0.0; i < d; i++ {
		d := distance(x1,y1,x2,y2)
		lenx := (x2 - x1) / d
		leny := (y2 - y1) / d
		newx1 = x1
		newy1 = y1
		newx2 = newx1 + lenx
		newy2 = newy1 + leny
		x1 = newx2
		y1 = newy2

		q = distance(newx1,newy1,newx2,newy2)



		//StorePosortByEar["fe"] = StepPos{newx2,newy2, q}
		//for _, v := range StorePos {
		//	s = append(s, v)
		//}
		//fmt.Println(StorePos)
		//sortByEar[i].NewTaskType
	}
	return
}

func distance(x1, y1, x2, y2 float64) float64 {
	a := math.Pow(math.Pow(x2 - x1,2) + math.Pow(y2 - y1,2),0.5)
	return a
}
func GetJsonDT(s []GetPlan) {
	jsonFile, _ := json.MarshalIndent(s, "","\t")
	err := ioutil.WriteFile("./json/eventsDT.json", jsonFile, 0777)
	if err != nil {
		fmt.Println("error when create JSON file")
	}
}