package engine
//
//import (
//	"fmt"
//	"math"
//)
//
//func ConsiderTemptativePlans(e []NewFormatTasks, SVTL1 float64, IDAVTask []int)  {
//
//	mLiberationTimePrev := e[0].NewReleasing
//	mSimXPosPrev := e[0].LocX
//	mSimYPosNext := e[0].LocX
//
//
//	for j := 1; j < len(IDAVTask); j++ {
//		if mLastTask > 1 {
//			mTemPlanEntries[tempPlanFinishTaskExec] = float64(mLastTask)
//			LastExecTime = float64(mTemPlanEntries[tempPlanFinishTaskExec])
//		}else {
//			if mLiberationTimePrev > currAlarmTime + 0.0001 {
//				LastExecTime = mLiberationTimePrev
//			}else {
//				LastExecTime = currAlarmTime
//			}
//		}
//		mTemPlanEntries[idTempPlanTask] = float64(mLastTask)
//		LastTaskId := mTemPlanEntries[idTempPlanTask]
//		newLastTaskId := int(LastTaskId)
//		siteAddressOld := e[newLastTaskId].NewIdSite
//
//		if mLastTask > 1 {
//			xAddressOld = e[siteAddressOld].LocX
//			yAddressOld = e[siteAddressOld].LocY
//		}else {
//			xAddressOld = mSimXPosPrev
//			yAddressOld = mSimYPosNext
//		}
//
//		considerTaskID := e[IDAVTask[j]].NewIdSite
//		xAddressConsider := e[considerTaskID].LocX
//		yAddressConsider := e[considerTaskID].LocY
//
//		considerEarliest := e[IDAVTask[j]].NewEarliest
//		considerLatest := e[IDAVTask[j]].NewLatest
//		considerDuration := e[IDAVTask[j]].NewDuration
//
//		considerDistance := math.Pow(math.Pow(xAddressConsider - xAddressOld,2) +
//							math.Pow(yAddressConsider - yAddressOld,2),0.5)
//
//		if LastExecTime+considerDistance < considerEarliest {
//			considerStartExecTime = considerEarliest
//		}else {
//			considerStartExecTime = LastExecTime + considerDistance
//		}
//
//		xBase := e[0].LocX
//		yBase := e[0].LocY
//
//		distanceToBase := math.Pow(math.Pow(xBase - xAddressConsider,2) +
//						  math.Pow(yBase - yAddressConsider,2),0.5)
//
//		if baseReturn == true {
//			if considerStartExecTime <= timeShift - distanceToBase - considerDuration {
//				criteriaDos = true
//			}else {
//				criteriaDos = false
//			}
//		}else {
//			if considerStartExecTime <= timeShift - considerDuration {
//				criteriaDos = true
//			}else {
//				criteriaDos = false
//			}
//		}
//
//		if LastExecTime+considerDistance < considerLatest && criteriaDos == true {
//			weightConsidered := e[IDAVTask[j]].NewImportance
//			timeSinceConsidered := considerStartExecTime + considerDuration - LastExecTime
//			if runMode == 4 {
//				smoWeight = math.Exp(-(meanRateAlarmShift / timeShift)*(considerStartExecTime - SVTL1))
//				desirabilityScore = math.Pow((weightConsidered*smoWeight) / timeSinceConsidered,3)
//			}else {
//				if	len(IDAVTask) > 9 {
//					xxx := GetRandom()
//					if xxx > 0.5 {
//						desirabilityScore = math.Pow(timeSinceConsidered / (100/12),3)
//					}else {
//						desirabilityScore = math.Pow(weightConsidered / timeSinceConsidered,3)
//					}
//				}else {
//					desirabilityScore = math.Pow(weightConsidered / timeSinceConsidered, 3)
//				}
//				feasibleTaskId[k] = IDAVTask[j]
//				feasibleScore[k] = desirabilityScore
//				trueIndicator++
//				k++
//			}
//		}
//	}
//
//	if len(IDAVTask) > 10 {
//		topBest = 6
//	}else {
//		topBest = 4
//	}
//
//	if trueIndicator > 0 {
//		mGuardIterationFea = true
//		if trueIndicator < topBest {
//			bestPosition = trueIndicator
//		}else {
//			bestPosition = topBest
//		}
//		if bestPosition == 0 {
//			fmt.Println("best position is zero")
//		}
//		k = 1
//		for i := 1; i < trueIndicator; i++ {
//			if feasibleScore[i] > minimun {
//				bestArrayScore[minPos] = feasibleScore[i]
//				bestArrayId[minPos] = feasibleTaskId[i]
//				minPos++
//				if i < bestPosition {
//					bestPositionNow = i
//				}else {
//					bestPositionNow = bestPosition
//				}
//				for z := 0; z < bestPositionNow; z++ {
//					if i == 1 {
//						minimun = bestArrayScore[minPos - 1]
//					}else {
//						if bestArrayScore[z] < minimun {
//							minimun = bestArrayScore[minPos - 1]
//						}
//					}
//				}
//			}
//		}
//
//	//	new line
//
//		var newcum [100]float64
//		cumSum := newcum[0:bestPosition]
//		cumSum[0] = 0
//
//		for gCount := 1; gCount < bestPosition; gCount++ {
//			cumSum[gCount] = cumSum[gCount - 1] + bestArrayScore[gCount]
//		}
//
//		selector := GetRandom()
//
//		if cumSum[bestPosition] == 0 {
//			selectedIdTask = bestArrayId[1]
//		}else {
//			for gCount := 1; gCount<bestPosition; gCount++ {
//				if selector < cumSum[gCount] / cumSum[bestPosition] {
//					selectedIdTask = bestArrayId[gCount]
//				}
//			}
//		}
//
//		selectedTaskDuration := e[selectedIdTask].NewDuration
//		selectedTaskEarliest := e[selectedIdTask].NewEarliest
//		selectedIdSite := e[selectedIdTask].NewIdSite
//
//		xAddressSelected := e[selectedIdSite].LocX
//		yAddressSelected := e[selectedIdSite].LocY
//		newTravelTime := math.Pow(math.Pow(xAddressSelected - xAddressOld,2) +
//			   			 math.Pow(yAddressSelected - yAddressOld,2),0.5)
//
//		if LastExecTime + newTravelTime < float64(selectedIdTask) {
//			arrvalNewTime = selectedTaskEarliest
//		}else {
//			arrvalNewTime = LastExecTime + newTravelTime
//		}
//		LastExecTime = arrvalNewTime + selectedTaskDuration
//
//		if runMode == 4 {
//			smoWeight = math.Exp(-(meanRateAlarmShift / timeShift)*(arrvalNewTime - SVTL1))
//			mProfit = mProfit + (e[selectedIdTask].NewImportance * smoWeight)
//		}else {
//			mProfit = mProfit + e[selectedIdTask].NewImportance
//		}
//
//		mLastTask++
//
//		Add(selectedIdTask,LastExecTime)
//		mRecentSelectedTask = selectedIdTask
//		if len(IDAVTask) == 1 {
//			mStopIteration = true
//		}
//	}else {
//		mGuardIterationFea = false
//		mRecentSelectedTask = -1
//	}
//
//}
//
//func Add(s int, l float64)  {
//	mTemPlanEntries[tempPlanFinishTaskExec] = float64(s)
//	LastExecTime = float64(mTemPlanEntries[tempPlanFinishTaskExec])
//	mTemPlanEntries[idTempPlanTask] = l
//	LastExecTime = float64(mTemPlanEntries[idTempPlanTask])
//}