package engine

import (
	"fmt"
	"io/ioutil"
	"encoding/json"
	"math"
	"sort"
)

func GetNews(v []NewFormatTasks) (test []GetPlan, PA float64) {
	fmt.Println("---------------------- START SIMULADOR DE EVENTOS DISCRETOS ----------------------")
	// ARRAY scores total
	lenAllTaskIDs = len(v)
	var sumScore = make([]float64,lenAllTaskIDs)
	// SORT by Weight (slice struct type)
	sortByWe = v[:]
	sort.Sort(sortByWeight(sortByWe))

	// convert SORT by Weight to map
	for k, v := range sortByWe {
		StoreByWeight[k] = v
		fmt.Println("# Total Tasks: ", len(sortByWe), " -  Task Generated: ", StoreByWeight[k])
	}
	// IDs task ordinary && task Emergency
	for k, v := range sortByWe {
		//fmt.Println(" ",sortByWe[k].NewEarliest)
		if v.NewTaskType == 1 { idPlanTaskOrd = append(idPlanTaskOrd,k) }else { idPlanTaskEmer = append(idPlanTaskEmer,k)}
	}
	fmt.Println("ORDINARY TASK IDs: ", idPlanTaskOrd, " -  EMERGENCY TASK IDs: ", idPlanTaskEmer)
	// convert Sort by Emergency to map
	for i := 0; i < len(idPlanTaskEmer); i++ {
		StoreEmergency[i] = StoreByWeight[idPlanTaskEmer[i]]
		fmt.Printf("RELEASE EMERGENCY: %g \n", StoreEmergency[i].NewEarliest)
	}
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
			fmt.Printf("POINTER POS INICIAL X:%g  Y:%g \n", *updateX, *updateY)

			feasibleIDs()
			delete(StoreByWeight,0)
			// append last values
			StorePlan["Time Elapsed"] = GetPlan{
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

			for g := 0; g < len(idPlanTaskOrd); g++ {
				/* Validation tasks elapsed */
				if StoreByWeight != nil {
					// func evaluate next ord task (time elapsed && score)
					a := nextPosition(*updateX, *updateY, stepTime)
					if StoreByWeight[a].NewTaskType != 0 {
						nPosX = StoreByWeight[a].LocX
						nPosY = StoreByWeight[a].LocY
						fmt.Printf("NEXT POSITION By BEST WEIGHT X:%g Y:%g \n", nPosX,nPosY)
						fmt.Println("relax: ", StoreByWeight[idPlanTaskOrd[a]])
						fmt.Printf("\n")
						fmt.Println("--- REMEMBER RELEASE ALARM TIME: ", float64(int64(StoreEmergency[bestEmergency[0]].NewEarliest)))
						fmt.Println("---------- INICIO DE ORDINARY ------------")
						q := runOrdinaryTask(*updateX,*updateY,nPosX,nPosY,stepTime, a)

						for i := 0; i < len(q); i++ {

							for w := len(idPlanTaskEmer); w >= 0 ; w-- {
								if StoreEmergency[w].NewEarliest == 0 {
									continue
								}else {
									bestEmergency[0] = w
								}
							}

							if float64(int64(q[i].TimeElapsed)) == float64(int64(StoreEmergency[bestEmergency[0]].NewEarliest)){
								break
							}

							StorePlan["Time Elapsed"] = GetPlan{
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
							if q[i].TimeElapsed == 99 {
								break
							}
							if q[i].LocX <= StoreByWeight[a].LocX && q[i].LocY <= StoreByWeight[a].LocY && q[i].Duration == StoreByWeight[a].NewDuration && q[i].Dist == 0{
								deleteId = a // note delete may change
							}
						}
						fmt.Println("---------- FIN DE ORDINARY ------------")
						fmt.Printf("\n")
						delete(StoreByWeight,deleteId)
						if deleteId == selectScore {
							sumScore[deleteId] = acScore
							fmt.Printf("TASK ACCOMPLISHED (Delete ID # %d) \n", deleteId)
						}else {
							fmt.Println("--- WARNING UNFULFILLED TASK")
						}
						fmt.Println("LIST SCORES ACCOMPLISHED By ID: ", sumScore)
						fmt.Printf("\n")
						fmt.Printf("POINTER POS FINAL AFTER LAST TASK X:%g Y:%g \n",*updateX, *updateY)
						fmt.Println("ELAPSED TIME AFTER LAST TASK: ", stepTime)
						t := acumulativeScore(sumScore)

						if stepTime + 1 == float64(int64(StoreEmergency[bestEmergency[0]].NewEarliest)) {
							if StoreEmergency == nil{
								break
							}
							fmt.Printf("\n")
							fmt.Println("---------- INICIO DE EMERGENCIA ------------")
							emerPosX := updateX
							emerPosY := updateY
							emerX := StoreEmergency[bestEmergency[0]].LocX
							emerY := StoreEmergency[bestEmergency[0]].LocY
							//fmt.Printf("LAST POS X:%g Y:%g - NEXT POS X:%g Y:%g \n", *emerPosX,*emerPosY,emerX,emerY)
							fmt.Printf("ID: %d \n", idPlanTaskEmer[bestEmergency[0]])
							e := runEmergencyTask(*emerPosX,*emerPosY,emerX,emerY,stepTime)
							for i := 0; i < len(e); i++ {

								StorePlan["Time Elapsed"] = GetPlan{
									e[i].TimeElapsed,
									e[i].TimeElapsed,
									1,
									StepPos{
										e[i].TimeElapsed,
										e[i].IdTask,
										e[i].TypeStatus,
										e[i].LocX,
										e[i].LocY,
										e[i].Dist,
										e[i].Duration,
									},
								}
								for _, v := range StorePlan {
									test = append(test, v)
								}

								stepTime = e[i].TimeElapsed
								updateX = &e[i].LocX
								updateY = &e[i].LocY
								fmt.Println(StorePlan)
								if e[i].Dist == 0 && e[i].Duration == StoreEmergency[bestEmergency[0]].NewDuration {
									break
								}
								delete(StoreEmergency,bestEmergency[0])
								sumScore[idPlanTaskEmer[bestEmergency[0]]] = 100
							}
							fmt.Println("---------- FIN DE EMERGENCIA ------------")
							fmt.Printf("\n")
							fmt.Printf("ELAPSED TIME AFTER LAST TASK: %g - X:%g Y:%g - ACCOMPLISHED ID: %d ", stepTime,*updateX,*updateY, idPlanTaskEmer[bestEmergency[0]])
						}
						fmt.Printf("\n")
						fmt.Println("ACTUALIZACION SCORE ------ : ",t)
						fmt.Printf("\n")
						PA = t
					}else {
						break
						//fmt.Println("Return To Base")
					}
				}else {
					fmt.Println("ar u stupid?..")
				}
			}
		}else if StoreByWeight[0].NewTaskType == 0 && StoreByWeight[0].NewImportance == 100{
			virtualStartTime = StoreByWeight[0].NewEarliest
			fmt.Println("E task: ", virtualStartTime, "run bictch...",StoreByWeight[0])
		}
		//time.Sleep(time.Microsecond*2000000)
		elapsedTime = stepTime
		stepTime++
		fmt.Println(elapsedTime)
	}
	fmt.Println("---------------------- END SIMULADOR DE EVENTOS DISCRETOS ----------------------")
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
	var m = make(map[int]float64)
	var t = make([]float64,20)
	for k, _ := range StoreByWeight {
		storeIdOrd[k] = k
		//fmt.Println(k)
	}
	for k, v := range storeIdOrd {

		if k == 0 {continue}
		lastExecTime := et
		xAddressOld := x1
		yAddressOld := y1
		xAddressConsidered := StoreByWeight[v].LocX
		yAddressConsidered := StoreByWeight[v].LocY
		consideredEarliest := StoreByWeight[v].NewEarliest
		consideredLastest := StoreByWeight[v].NewLatest
		consideredDuration := StoreByWeight[v].NewDuration
		consideredDistance := distance(xAddressOld,yAddressOld,xAddressConsidered,yAddressConsidered)

		if lastExecTime+consideredDistance < consideredEarliest {
			consideredStartExecTime = consideredEarliest
		}else {
			consideredStartExecTime = lastExecTime + consideredDistance
		}

		xBase := sortByWe[0].LocX
		yBase := sortByWe[0].LocY
		distanceToBase := distance(xAddressConsidered,yAddressConsidered,xBase,yBase)

		if baseReturn == true {
			if consideredStartExecTime <= virtualTimeShift - distanceToBase - consideredDuration {
				criteriados = true
			}else {
				criteriados = false
			}
		}else {
			if consideredStartExecTime <= virtualTimeShift - consideredDuration {
				criteriados = true
			}else {
				criteriados = false
			}
		}

		if lastExecTime + consideredDistance < consideredLastest && criteriados == true {

			weightConsidered := StoreByWeight[v].NewImportance
			timeSinceConsidered = consideredStartExecTime + consideredDuration - LastExecTime

			if runMode == 4 {
				smoothedWeight = math.Log(-(meanRateAlarmsperShift / virtualTimeShift) * (consideredStartExecTime - 0.0001))
				m[k] = math.Pow((weightConsidered * smoothedWeight)/timeSinceConsidered,3)
			}else {
				if len(StoreByWeight) > 9 {
					xxx = GetRandom()
					if xxx > 0.5 {
						m[k] = math.Pow(timeSinceConsidered/(100/12),3)
					}else {
						m[k] = math.Pow(weightConsidered/timeSinceConsidered,3)
					}
				}else {
					m[k] = math.Pow(weightConsidered/timeSinceConsidered,3)
				}
			}

		}
	}

	for k, v := range m {
		t[k] = v
	}
	fmt.Println("WEIGHT By SITE: ", m)
	//fmt.Println("CONVERT To SLICE: ", t)
	sort.Sort(sort.Reverse(sort.Float64Slice(t)))
	fmt.Println("SORT By BEST WEIGHT: ", t)
	for i := 0; i < len(storeIdOrd); i++ {
		if m[i] == t[0] {
			bestWeight[0] = i // send key
			break
		}
	}
	fmt.Printf("BEST WEIGHT: ID %d \n",bestWeight)
	bestPos = bestWeight[0]
	selectScore = bestWeight[0]
	acScore = t[0]

	//for i := 0; i < len(sortByWe); i++ {
	//	if storeIdOrd[i] == 0 {
	//		continue
	//	}else {
	//		bestWeight[0] = storeIdOrd[i]
	//		break
	//	}
	//}

	fmt.Println("UPDATE FEASIBLES ORDINARY TASKS: ",storeIdOrd)

	return
}

func runOrdinaryTask(x1, y1 float64, x2, y2 float64, et float64, a int) (newPos []StepPos) {
	idTask := 1
	typeOperationOrd := 2
	typeTravelOrd := 1
	//typeWaitingOrd := 3
	arrDist := distance(x1,y1,x2,y2)
	fmt.Printf("---ORDINARY TASK (LAST POSITION X:%g Y:%g): \n", x1, y1)
	fmt.Println("ORDINARY TASK ARRIVAL TIME: ", arrDist)
	for i := 0.0; i <= arrDist; i++ {
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

		if arrDist == 0 {
			break
		}

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

	lastPostStoreX := x2
	lastPostStoreY := y2
	lastElapsedTime := StorePos["travelOrd"].TimeElapsed
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

func runEmergencyTask(x1, y1, x2, y2 float64, et float64) (newPos []StepPos) {
	idTask := 2
	typeOperationOrd := 2
	typeTravelOrd := 1
	arrDist := distance(x1,y1,x2,y2)
	fmt.Printf("---EMERGENCY TASK (LAST POSITION X:%g Y:%g): \n", x1, y1)
	fmt.Println("EMERGENCY TASK ARRIVAL TIME: ", arrDist)
	for i := 0.0; i <= arrDist; i++ {
		var newX2, newY2 float64
		arrDist := distance(x1,y1,x2,y2)
		newX1 := x1
		newY1 := y1
		newX2 = newX1 + (x2 - x1) / arrDist
		newY2 = newY1 + (y2 - y1) / arrDist
		x1 = newX2
		y1 = newY2
		stepDist = distance(newX1,newY1,newX2,newY2)
		idEmergency := stepDist + i + et

		if arrDist == 0 {
			break
		}

		StorePos["travelOrd"] = StepPos{
			idEmergency,
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
	lastPostStoreX := x2
	lastPostStoreY := y2
	lastElapsedTime := StorePos["travelOrd"].TimeElapsed
	waitTime := StoreEmergency[0].NewDuration
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
	a = float64(int64(a))
	return a
}

func acumulativeScore(s []float64) (scoreTotal float64){
	var sumarScores float64
	for _, v := range s {
		sumarScores += v
		//fmt.Println("VALORES DEL ARRAY SCORES: ",v)
	}
	scoreTotal = sumarScores
	return
}

func GetJsonClock(s []GetPlan) {
	jsonFile, _ := json.MarshalIndent(s, "","\t")
	err := ioutil.WriteFile("./json/ClockEvents.json", jsonFile, 0777)
	if err != nil {
		fmt.Println("error when create JSON file")
	}
	fmt.Println("JSON FILE CREATED /json/ClockEvent.json")
}



