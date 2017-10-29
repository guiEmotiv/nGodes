package engine

import (
	"fmt"
	"io/ioutil"
	"encoding/json"
	"math"
	"sort"
)

func GetNews(v []NewFormatTasks) (test []GetPlan) {

	// SORT by Earliest (slice struct type)
	sortByWe = v[:]
	sort.Sort(sortByWeight(sortByWe))

	// convert SORT by earliest to map
	//fmt.Println(sortByWe[13])
	for k, v := range sortByWe {
		StoreByWeight[k] = v
	}
	//fmt.Println(StoreByWeight[12])
	// fmt.Println(sortByWe[3])
	// IDs task ordinary && task Emergency
	for k, v := range sortByWe {
		//fmt.Println(" ",sortByWe[k].NewEarliest)
		if v.NewTaskType == 1 { idPlanTaskOrd = append(idPlanTaskOrd,k) }else { idPlanTaskEmer = append(idPlanTaskEmer,k)}
	}
	fmt.Println("idPlanTaskOrd && idPlanTaskEmer: ",idPlanTaskOrd, idPlanTaskEmer)

	// ordinary tasks assume clock 100 step 1 && guard 1 && 3 state E1 E2 E3
	elapsedTime = 0
	for virtualTimeShift > elapsedTime {

		if StoreByWeight[0].NewTaskType == 1 {
			/* init values */
			stepTime = elapsedTime
			virtualStartTime = StoreByWeight[0].NewEarliest
			aPosX = StoreByWeight[0].LocX
			aPosY = StoreByWeight[0].LocY
			idtaskrelease := 0
			delete(StoreByWeight,idtaskrelease)
			StorePlan["fa"] = GetPlan{
				0,
				0,
				1,
				StepPos{
					0,
					0,
					1,
					aPosX,
					aPosY,
					0,
				},
			}
			for _, v := range StorePlan {
				test = append(test, v)
			}

			/* Validation tasks elapsed */
			if StoreByWeight != nil {
				//fmt.Println("existe IDs en plan total",StoreByWeight)
				// func evaluate nex ord task (time elapsed && score)
				a := nextPosition(aPosX, aPosY, stepTime)
				if StoreByWeight[a].NewTaskType == 1 {
					nPosX = StoreByWeight[a].LocX
					nPosY = StoreByWeight[a].LocY
					fmt.Println("next post",a, nPosX,nPosY)
					q := runOrdinaryTask(aPosX,aPosY,nPosX,nPosY,stepTime, a)
					for i := 0; i < len(q); i++ {
						//fmt.Println(q[i].LocX)
						StorePlan["fa"] = GetPlan{
							q[i].TimeElapsed,
							q[i].TimeElapsed,
							1,
							StepPos{
								q[i].TimeElapsed,
								q[i].IdTask,
								q[i].TypeStatus,
								q[i].LocX,
								q[i].LocY,
								q[i].Dist,
							},
						}
						for _, v := range StorePlan {
							test = append(test, v)
						}

						stepTime = q[i].TimeElapsed
						lastPosOrdX = q[i].LocX
						lastPosOrdY = q[i].LocX
						fmt.Println(StorePlan)
					}
					//fmt.Println(stepTime)
					//fmt.Println(lastPosOrdX)

					fmt.Println("cumpli a: ",a)
				}else {
					fmt.Println("noob")
				}
			}else {
				fmt.Println("ar u stupid?..")
			}
		}else if StoreByWeight[0].NewTaskType == 0 && StoreByWeight[0].NewImportance != 0{
			virtualStartTime = StoreByWeight[0].NewEarliest
			fmt.Println("E task: ", virtualStartTime, "run bictch...",StoreByWeight[0])
		}

		//newaPosX, newaPosY, newnPosX, newnPosY = &aPosX, &aPosY, &nPosX, &nPosY
		//for i := 0; i< len(idPlanTaskOrd)-1; i++ {
		//
		//	//aPosX, aPosY, nPosX, nPosY = sortByWe[idPlanTaskOrd[i]].LocX, sortByWe[idPlanTaskOrd[i]].LocY, sortByWe[idPlanTaskOrd[i+1]].LocX, sortByWe[idPlanTaskOrd[i+1]].LocY
		//	d := distance(aPosX, aPosY, nPosX, nPosY)
		//	fmt.Println("d: ",d)
		//	arrTime = sortByWe[1].NewEarliest
		//	fmt.Println("arr", arrTime)
		//	dur := sortByWe[1].NewDuration
		//	fmt.Println("dur", dur)
		//	fmt.Println(i)
		//	w := 9
		//	if i == w {
		//		break
		//	}
		//	//fmt.Println(*newaPosX)
		//}
		//time.Sleep(time.Microsecond*2000000)
		elapsedTime++
		//fmt.Println(elapsedTime)

	}

	return
}

func nextPosition(x1, y1, et float64) (bestPos int) {
	//delete(StoreByWeight,1)
	// ORDINARY TASK 4 NEXT POINTS
	for i := 0; i < len(idPlanTaskEmer); i++ {
		delete(StoreByWeight,idPlanTaskEmer[i])
	}
	// SLICE Store By Weight IDs
	//fmt.Println("evaluar si exite", StoreByWeight[2])
	var storeIdOrd = make([]int,len(sortByWe))
	var bestWeight [1]int

	for k, _ := range StoreByWeight {
		storeIdOrd[k] = k
	}
	for i := 0; i < len(StoreByWeight); i++ {
		if storeIdOrd[i] == 0 {
			continue
		}else {
			bestWeight[0] = storeIdOrd[i]
			break
		}
	}
	fmt.Println("Lista de IDs tareas Ord por realizar",storeIdOrd)
	fmt.Println("bestWeight", bestWeight)

	// CRITERIA
	xBase := StoreByWeight[0].LocX
	yBase := StoreByWeight[0].LocY
	xConsidered := StoreByWeight[bestWeight[0]].LocY
	yConsidered := StoreByWeight[bestWeight[0]].LocY
	distBase := distance(xConsidered,yConsidered,xBase,yBase)
	if et + distBase + StoreByWeight[bestWeight[0]].NewDuration < virtualTimeShift {
		baseReturn = false
		bestPos = bestWeight[0]
	}else {
		bestPos = 0
		baseReturn = true
	}
	return
}

func runOrdinaryTask(x1, y1, x2, y2 float64, et float64, a int) (newPos []StepPos) {
	idTask := 1
	typeOperationOrd := 2
	typeTravelOrd := 1

	arrDist := distance(x1,y1,x2,y2)
	fmt.Println("wtf: ", x1, y1)
	fmt.Println("tiempo de llegada: ", arrDist)
	for i := 0.0; i <= arrDist; i++ {
		arrDist = distance(x1,y1,x2,y2)
		newX1 := x1
		newY1 := y1
		newX2 := newX1 + (x2 - x1) / arrDist
		newY2 := newY1 + (y2 - y1) / arrDist
		x1 = newX2
		y1 = newY2
		stepDist = distance(newX1,newY1,newX2,newY2)
		idOrd := stepDist + i + et
		//fmt.Println(stepDist, newX2, newY2)
		StorePos["travelOrd"] = StepPos{
			idOrd,
			idTask,
			typeTravelOrd,
			newX2,
			newY2,
			stepDist,
		}
		//fmt.Println(StorePos)
		for _, v := range StorePos {
			newPos = append(newPos, v)
		}
	}
	//fmt.Println("last task ord points: ", StorePos)
	// Waiting Time
	lastPostStoreX := StorePos["travelOrd"].LocX
	lastPostStoreY := StorePos["travelOrd"].LocY
	lastElapsedTime := StorePos["travelOrd"].TimeElapsed
	//fmt.Println(lastPostStoreX,lastPostStoreY)
	waitTime := StoreByWeight[a].NewDuration
	for i := 1.0; i < waitTime; i++ {
		//fmt.Println("wait",i)
		lastElapsedTime++
		StorePos["travelOrd"] = StepPos{
			lastElapsedTime,
			idTask,
			typeOperationOrd,
			lastPostStoreX,
			lastPostStoreY,
			0,
		}
		//fmt.Println(StorePos)
		for _, v := range StorePos {
			newPos = append(newPos, v)
		}
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
