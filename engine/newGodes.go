package engine

import (
	"fmt"
	"io/ioutil"
	"encoding/json"
	"math"
	"sort"
	"strings"
)

func GetNews(v []NewFormatTasks) (test []GetPlan, PA float64) {
	fmt.Println("---------------------- START SIMULADOR DE EVENTOS DISCRETOS ----------------------")
	// ARRAY scores total
	lenAllTaskIDs = len(v)
	var sumScore = make([]float64,lenAllTaskIDs)
	// SORT by Weight (slice struct type)
	sliceAllIdTask = v[:]
	// convert SORT by Weight to map
	for k, v := range sliceAllIdTask {
		mapAllIdTask[k] = v
		fmt.Println("# Total Tasks: ", len(sliceAllIdTask), " -  Task Generated: ", mapAllIdTask[k])
	}
	// IDs task ordinary && task Emergency
	for k, v := range sliceAllIdTask {
		//fmt.Println(" ",sliceAllIdTask[k].NewEarliest)
		if v.NewTaskType == 1 { idPlanTaskOrd = append(idPlanTaskOrd,k) }else { idPlanTaskEmer = append(idPlanTaskEmer,k)}
	}
	fmt.Println("ORDINARY TASK IDs: ", idPlanTaskOrd, " -  EMERGENCY TASK IDs: ", idPlanTaskEmer)
	// convert Sort by Emergency to map
	for i := 0; i < len(idPlanTaskEmer); i++ {
		StoreEmergency[i] = mapAllIdTask[idPlanTaskEmer[i]]
		fmt.Printf("RELEASE EMERGENCY: %g \n", StoreEmergency[i].NewEarliest)
	}
	// ordinary tasks assume clock 100 step 1 && guard 1 && 3 state E1 E2 E3
	elapsedTime = 0
	for virtualTimeShift > elapsedTime {

		if mapAllIdTask[0].NewTaskType == 1 {
			/* init values */
 			stepTime = elapsedTime
			virtualStartTime = mapAllIdTask[0].NewEarliest
			aPosX = mapAllIdTask[0].LocX
			aPosY = mapAllIdTask[0].LocY
			updateX = &aPosX
			updateY = &aPosY
			fmt.Printf("POINTER POS INICIAL X:%g  Y:%g \n", *updateX, *updateY)

			feasibleIDs()
			delete(mapAllIdTask,0)
			// append last values

			StorePlan["Time Elapsed"] = GetPlan{
					0,
					1,
					StepPos{
						0,
						0,
						1,
						0,
						aPosX,
						aPosY,
						0,
						Coverage{
							standardRadius,
							0,
							"nil",
							"nil",
						},
					},
			}

			for _, v := range StorePlan {
				test = append(test, v)
			}

			for g := 0; g < len(idPlanTaskOrd); g++ {
				/* Validation tasks elapsed */
				if mapAllIdTask != nil {
					// func evaluate next ord task (time elapsed && score)
					a := nextPosition(*updateX, *updateY, stepTime)
					if mapAllIdTask[a].NewTaskType != 0 {
						nPosX = mapAllIdTask[a].LocX
						nPosY = mapAllIdTask[a].LocY
						fmt.Printf("NEXT POSITION By BEST WEIGHT X:%g Y:%g \n", nPosX,nPosY)
						fmt.Println("relax: ", mapAllIdTask[idPlanTaskOrd[a]])
						fmt.Printf("\n")
						fmt.Println("****** REMEMBER RELEASE ALARM TIME: ", float64(int64(StoreEmergency[bestEmergency[0]].NewEarliest)))
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
								1,
								StepPos{
									q[i].IdTask,
									q[i].TypeStatus,
									q[i].Duration,
									q[i].Dist,
									q[i].LocX,
									q[i].LocY,
									q[i].TimeElapsed,
									Coverage{
										q[i].Score,
										q[i].ScoreAccumulated,
										q[i].CovByIds,
										q[i].CovByMatrix,
									},
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
							if q[i].LocX <= mapAllIdTask[a].LocX && q[i].LocY <= mapAllIdTask[a].LocY && q[i].Duration == mapAllIdTask[a].NewDuration && q[i].Dist == 0 && q[i].TypeStatus == 3{
								deleteId = a // note delete may change
							}
						}
						fmt.Println("---------- FIN DE ORDINARY ------------")
						fmt.Printf("\n")
						delete(mapAllIdTask,deleteId)
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
						t := scoreGlobal(sumScore)

						if stepTime + 1 == float64(int64(StoreEmergency[bestEmergency[0]].NewEarliest)) {
							if StoreEmergency == nil{
								break
							}
							fmt.Printf("\n")
							fmt.Println("************* INICIO DE EMERGENCIA *************")
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
									1,
									StepPos{
										e[i].IdTask,
										e[i].TypeStatus,
										e[i].Duration,
										e[i].Dist,
										e[i].LocX,
										e[i].LocY,
										e[i].TimeElapsed,
										Coverage{
											e[i].Score,
											e[i].ScoreAccumulated,
											e[i].CovByIds,
											e[i].CovByMatrix,
										},
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

							fmt.Println("************* FIN DE EMERGENCIA *************")
							fmt.Printf("\n")
							fmt.Printf("TIME ELAPSED AFTER LAST TASK: %g - X:%g Y:%g - ACCOMPLISHED TASK ID: %d ", stepTime,*updateX,*updateY, idPlanTaskEmer[bestEmergency[0]])
						}
						fmt.Printf("\n")
						fmt.Println("ACTUALIZACION SCORE ------ : ",t)
						fmt.Printf("\n")
						PA = t
					}else {
						break
					}
				}else {
					fmt.Println("ar u stupid?..")
				}
			}
		}else if mapAllIdTask[0].NewTaskType == 0 && mapAllIdTask[0].NewImportance == 100{
			virtualStartTime = mapAllIdTask[0].NewEarliest
			fmt.Println("E task: ", virtualStartTime, "run bictch...",mapAllIdTask[0])
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
	var storeIdOrdNew = make([]int,len(sliceAllIdTask))
	var bestWeightNew [1]int
	for k, _ := range mapAllIdTask {
		storeIdOrdNew[k] = k
	}
	for i := 0; i < len(mapAllIdTask); i++ {
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
		delete(mapAllIdTask,idPlanTaskEmer[i])
	}
	// SLICE Store By Weight IDs
	//fmt.Println("evaluar si exite", mapAllIdTask[7])
	var storeIdOrd = make([]int,len(sliceAllIdTask))
	var bestWeight [1]int
	var m = make(map[int]float64)
	var t = make([]float64,20)
	for k, _ := range mapAllIdTask {
		storeIdOrd[k] = k
	}

	for k, v := range storeIdOrd {
		if k == 0 { continue }
		if v == 0 { continue }
		lastExecTime := et
		xAddressOld := x1
		yAddressOld := y1
		xAddressConsidered := mapAllIdTask[v].LocX
		yAddressConsidered := mapAllIdTask[v].LocY
		consideredEarliest := mapAllIdTask[v].NewEarliest
		consideredLastest := mapAllIdTask[v].NewLatest
		consideredDuration := mapAllIdTask[v].NewDuration
		consideredDistance := distance(xAddressOld,yAddressOld,xAddressConsidered,yAddressConsidered)

		if lastExecTime+consideredDistance < consideredEarliest {
			consideredStartExecTime = consideredEarliest
		}else {
			consideredStartExecTime = lastExecTime + consideredDistance
		}

		xBase := sliceAllIdTask[0].LocX
		yBase := sliceAllIdTask[0].LocY
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

			weightConsidered := mapAllIdTask[v].NewImportance
			timeSinceConsidered = consideredStartExecTime + consideredDuration - LastExecTime

			if runMode == 4 {
				smoothedWeight = math.Log(-(meanRateAlarmsperShift / virtualTimeShift) * (consideredStartExecTime - 0.0001))
				m[k] = math.Pow((weightConsidered * smoothedWeight)/timeSinceConsidered,3)
			}else {
				if len(mapAllIdTask) > 9 {
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

	//for i := 0; i < len(sliceAllIdTask); i++ {
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
	typeTravelOrd := 1
	typeWaitingOrd := 2
	typeOperationOrd := 3

	arrDist := distance(x1,y1,x2,y2)

	fmt.Printf("---ORDINARY TASK (LAST POSITION X:%g Y:%g): \n", x1, y1)
	fmt.Println("ORDINARY TASK ARRIVAL TIME: ", arrDist)

	fmt.Println("aqui estoy",arrDist)

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

		if arrDist == 0 { break }

		coverageRadius = standardRadius
		MC1, MC2, MC3 := matrixCoverage(newX2, newY2, idOrd, coverageRadius)

		StorePos["travelOrd"] = StepPos{
			idTask,
			typeTravelOrd,
			i,
			stepDist,
			newX2,
			newY2,
			idOrd,
			Coverage{
				coverageRadius,
				MC1,
				MC2,
				MC3,
			},
		}
		//fmt.Println(StorePos)
		for _, v := range StorePos {
			newPos = append(newPos, v)
		}
	}

	if et < mapAllIdTask[a].NewEarliest {
		coverageRadius = standardRadius
		lastPostStoreXWaiting := x2
		lastPostStoreYWaiting := y2
		lastElapsedTimeWaiting := StorePos["travelOrd"].TimeElapsed
		waitingTime := mapAllIdTask[a].NewEarliest - lastElapsedTimeWaiting
		for i := 0.0; i< waitingTime; i++ {
			lastElapsedTimeWaiting++
			MC1, MC2, MC3 := matrixCoverage(lastPostStoreXWaiting, lastPostStoreYWaiting, lastElapsedTimeWaiting, coverageRadius)
			StorePos["travelOrd"] = StepPos{
				idTask,
				typeWaitingOrd,
				i,
				0,
				lastPostStoreXWaiting,
				lastPostStoreYWaiting,
				lastElapsedTimeWaiting,
				Coverage{
					coverageRadius,
					MC1,
					MC2,
					MC3,
				},
			}
			//fmt.Println(StorePos)
			for _, v := range StorePos {
				newPos = append(newPos, v)
			}
		}
	}

	lastPostStoreX := x2
	lastPostStoreY := y2
	lastElapsedTime := StorePos["travelOrd"].TimeElapsed
	operationTime := mapAllIdTask[a].NewDuration
	for i := 0.0; i <= operationTime; i++ {
		coverageRadius = standardRadius - (operationTime - i)
		//fmt.Println("wait",i)
		MC1, MC2, MC3 := matrixCoverage(lastPostStoreX, lastPostStoreY, lastElapsedTime, coverageRadius)
		lastElapsedTime++
		StorePos["travelOrd"] = StepPos{
			idTask,
			typeOperationOrd,
			i,
			0,
			lastPostStoreX,
			lastPostStoreY,
			lastElapsedTime,
			Coverage{
				coverageRadius,
				MC1,
				MC2,
				MC3,
			},
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

		if arrDist == 0 { break }

		if standardRadius < i {
			coverageRadius = 0
		}else {
			coverageRadius = standardRadius - i
		}

		MC1, MC2, MC3 := matrixCoverage(newX2, newY2, idEmergency, coverageRadius)

		StorePos["travelOrd"] = StepPos{
			idTask,
			typeTravelOrd,
			i,
			stepDist,
			newX2,
			newY2,
			idEmergency,
			Coverage{
				coverageRadius,
				MC1,
				MC2,
				MC3,
			},
		}
		//fmt.Println(StorePos)
		for _, v := range StorePos {
			newPos = append(newPos, v)
		}
	}
	lastPostStoreX := x2
	lastPostStoreY := y2
	lastElapsedTime := StorePos["travelOrd"].TimeElapsed
	operationTime := StoreEmergency[0].NewDuration // 7.5

	for i := 0.0; i <= operationTime; i++ {
		coverageRadius = standardRadius - (operationTime - i)
		//fmt.Println("wait",i)
		MC1, MC2, MC3 := matrixCoverage(lastPostStoreX, lastPostStoreY, lastElapsedTime, coverageRadius)
		lastElapsedTime++
		StorePos["travelOrd"] = StepPos{
			idTask,
			typeOperationOrd,
			i,
			0,
			lastPostStoreX,
			lastPostStoreY,
			lastElapsedTime,
			Coverage{
				coverageRadius,
				MC1,
				MC2,
				MC3,
			},
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

func scoreGlobal(s []float64) (scoreTotal float64){
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
	//jsonFile, _ := json.Marshal(s)
	err := ioutil.WriteFile("./json/clockEvents.json", jsonFile, 0777)
	if err != nil {
		fmt.Println("error when create JSON file")
	}
	fmt.Println("JSON FILE CREATED /json/ClockEvent.json")
}

func matrixCoverage(x2, y2 float64, et float64, cov float64) (covFeasibleIDs float64, covDetails, covDetailsMatrix string) {

	for i := 0; i < len(idPlanTaskEmer); i++ {
		delete(mapAllIdTask,idPlanTaskEmer[i])
	}

	//virtualTimeStep = 1
	//startVirtualTimeL1 = 0.001
	//survivalProbability = math.Exp(-(meanRateAlarmsperShift) * 1.0)

	var sliceMatrix = make([]int,len(sliceAllIdTask))
	var sliceMatrixCoverage = make([]int,len(sliceAllIdTask))
	var sliceMatrixFeasible = make([]float64,len(sliceAllIdTask))
	for k, _ := range mapAllIdTask {
		sliceMatrixCoverage[k] = k
	}
	for k, v := range sliceMatrixCoverage {

		if v == 0 { continue }
		if k == 0 { continue }

		siteRelFreq = mapAllIdTask[v].Frequency
		probAlarmDeltaSite = 1 - math.Exp(-meanRateAlarmsperShift * siteRelFreq * 1.0)

		xCoveredSiteCoordinate = mapAllIdTask[v].LocX
		yCoveredSiteCoordinate = mapAllIdTask[v].LocY
		xBaseCoordinate = sliceAllIdTask[0].LocX
		yBaseCoordinate = sliceAllIdTask[0].LocY
		coverageDistance = distance(xCoveredSiteCoordinate,yCoveredSiteCoordinate,x2,y2)
		localDistance = distance(xCoveredSiteCoordinate,yCoveredSiteCoordinate,xBaseCoordinate,yBaseCoordinate)

		reservedTime = emergencyDeterministicDuration - cov

		if et < virtualTimeShift-coverageDistance-reservedTime-localDistance-emergencyDeterministicDuration {
			if coverageDistance < cov {
				sliceMatrix[k] = 1
			}else {
				sliceMatrix[k] = 0
			}
		}else {
			sliceMatrix[k] = 0
		}
		probNoAlarm = math.Exp(-meanRateAlarmsperShift * (et-0.0001))

		sliceMatrixFeasible[k] = float64(sliceMatrix[k]) * probAlarmDeltaSite * probNoAlarm
	}
	for k, v := range sliceMatrixFeasible {
		if v == 0 { continue }
		if k == 0 { continue }
		accumulatedCoverageSite += v
	}
	covFeasibleIDs = accumulatedCoverageSite
	//fmt.Println(covFeasibleIDs)
	fmt.Println(sliceMatrixFeasible)
	fmt.Println(sliceMatrixCoverage)
	fmt.Println(sliceMatrix)
	covDetails = arrayToString(sliceMatrixCoverage,", ")
	covDetailsMatrix = arrayToString(sliceMatrix,", ")
	return
}

func arrayToString(a []int, delim string) string {
	return strings.Trim(strings.Replace(fmt.Sprint(a), " ", delim, -1), "[]")
	//return strings.Trim(strings.Join(strings.Split(fmt.Sprint(a), " "), delim), "[]")
	//return strings.Trim(strings.Join(strings.Fields(fmt.Sprint(a)), delim), "[]")

}


