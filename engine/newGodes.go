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
			updateX = &aPosX
			updateY = &aPosY


			fmt.Println("puntero inicial : ",*updateX, *updateY)
			feasibleIDs()
			delete(StoreByWeight,0)
			// append last values
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
					0,
				},
			}
			for _, v := range StorePlan {
				test = append(test, v)
			}

			for i := 0; i < len(idPlanTaskOrd); i++ {
				/* Validation tasks elapsed */
				if StoreByWeight != nil {
					//fmt.Println("existe IDs en plan total",StoreByWeight)
					// func evaluate nex ord task (time elapsed && score)
					a := nextPosition(*updateX, *updateY, stepTime)
					if StoreByWeight[a].NewTaskType != 0 {
						nPosX = StoreByWeight[a].LocX
						nPosY = StoreByWeight[a].LocY
						fmt.Println("next post",a, nPosX,nPosY)
						q := runOrdinaryTask(*updateX,*updateY,nPosX,nPosY,stepTime, a)
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
									q[i].Duration,
								},
							}
							for _, v := range StorePlan {
								test = append(test, v)
							}

							stepTime = q[i].TimeElapsed
							updateX = &q[i].LocX
							updateY = &q[i].LocY
							fmt.Println(StorePlan)

							if q[i].LocX <= StoreByWeight[a].LocX && q[i].LocY <= StoreByWeight[a].LocY && q[i].Duration == StoreByWeight[a].NewDuration {
								deleteId = a // note delete may change
							}
						}
						delete(StoreByWeight,deleteId)
						feasibleIDs()
						fmt.Println("delete:  ", deleteId)
						//fmt.Println("saliendo: ",StoreByWeight[deleteId])
						fmt.Println("puntero final : ",*updateX, *updateY)
						fmt.Println("tarea cumplida id: ",a)
					}else {
						fmt.Println("noob")
					}
				}else {
					fmt.Println("ar u stupid?..")
				}
			}
		}else if StoreByWeight[0].NewTaskType == 0 && StoreByWeight[0].NewImportance != 0{
			virtualStartTime = StoreByWeight[0].NewEarliest
			fmt.Println("E task: ", virtualStartTime, "run bictch...",StoreByWeight[0])
		}
		//time.Sleep(time.Microsecond*2000000)
		elapsedTime = stepTime
		stepTime++
		fmt.Println(elapsedTime)
	}
	return
}
func feasibleIDs()  {
	var storeIdOrdNew = make([]int,len(sortByWe))
	var bestWeightNew [1]int
	for k, _ := range StoreByWeight {
		storeIdOrdNew[k] = k
	}
	for i := 0; i < len(StoreByWeight); i++ {
		if storeIdOrdNew[i] == 0 {
			continue
		}else {
			bestWeightNew[0] = storeIdOrdNew[i]
			break
		}
	}
	//fmt.Println("se acabo",storeIdOrdNew)
	return
}
func nextPosition(x1, y1 float64 , et float64) (bestPos int) {
	// ORDINARY TASK 4 NEXT POINTS
	for i := 0; i < len(idPlanTaskEmer); i++ {
		delete(StoreByWeight,idPlanTaskEmer[i])
	}
	// SLICE Store By Weight IDs
	//fmt.Println("evaluar si exite", StoreByWeight[7])
	var storeIdOrd = make([]int,len(sortByWe))
	var bestWeight [1]int

	for k, _ := range StoreByWeight {
		storeIdOrd[k] = k
		//fmt.Println(k)
	}
	for i := 0; i < len(sortByWe); i++ {
		if storeIdOrd[i] == 0 {
			continue
		}else {
			bestWeight[0] = storeIdOrd[i]
			break
		}
	}
	fmt.Println("Lista de IDs tareas Ord por realizar",storeIdOrd)

	// CRITERIA
	xBase := sortByWe[0].LocX
	yBase := sortByWe[0].LocY
	xConsidered := StoreByWeight[bestWeight[0]].LocX
	yConsidered := StoreByWeight[bestWeight[0]].LocY
	distBase := distance(xConsidered,yConsidered,xBase,yBase)
	distNext := distance(x1,y1,xConsidered,yConsidered)
	if et + distBase + distNext + StoreByWeight[bestWeight[0]].NewDuration <= virtualTimeShift - distBase {
		fmt.Println("tiempo transcurrido:   ",et + distBase + StoreByWeight[bestWeight[0]].NewDuration)
		bestPos = bestWeight[0]
		fmt.Println("bestWeight: ", bestPos)
	}else {
		StoreByWeight[0] = NewFormatTasks{
			sortByWe[0].NewIdTask,
			sortByWe[0].NewIdSite,
			sortByWe[0].NewReleasing,
			sortByWe[0].NewEarliest,
			sortByWe[0].NewLatest,
			1,
			sortByWe[0].NewImportance,
			1,
			sortByWe[0].LocX,
			sortByWe[0].LocY,
			sortByWe[0].Frequency,
		}
		bestPos = 0
	}
	//delete(StoreByWeight,8)
	return
}

func runOrdinaryTask(x1, y1 float64, x2, y2 float64, et float64, a int) (newPos []StepPos) {
	idTask := 1
	typeOperationOrd := 2
	typeTravelOrd := 1

	arrDist := distance(x1,y1,x2,y2)
	fmt.Println("wtf: ", x1, y1)
	fmt.Println("tiempo de llegada: ", arrDist)
	for i := 0.0; i < arrDist; i++ {
		var newX2, newY2 float64
		arrDist := distance(x1,y1,x2,y2)
		newX1 := x1
		newY1 := y1
		newX2 = newX1 + (x2 - x1) / arrDist
		newY2 = newY1 + (y2 - y1) / arrDist
		x1 = newX2
		y1 = newY2
		stepDist = distance(newX1,newY1,newX2,newY2)
		idOrd := stepDist + i + et
		StorePos["travelOrd"] = StepPos{
			idOrd,
			idTask,
			typeTravelOrd,
			newX2,
			newY2,
			stepDist,
			i,
		}
		//fmt.Println(StorePos)
		for _, v := range StorePos {
			newPos = append(newPos, v)
		}
	}
	//lastPostStoreX := StorePos["travelOrd"].LocX
	lastPostStoreX := x2
	//lastPostStoreY := StorePos["travelOrd"].LocY
	lastPostStoreY := y2
	lastElapsedTime := StorePos["travelOrd"].TimeElapsed
	//fmt.Println(lastPostStoreX,lastPostStoreY)
	waitTime := StoreByWeight[a].NewDuration
	for i := 1.0; i <= waitTime; i++ {
		//fmt.Println("wait",i)
		lastElapsedTime++
		StorePos["travelOrd"] = StepPos{
			lastElapsedTime,
			idTask,
			typeOperationOrd,
			lastPostStoreX,
			lastPostStoreY,
			0,
			i,
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
