package engine

import (
	"fmt"
	"math"
	"math/rand"
	"time"
)

func GetEmergency(a Client) {

	maxSites = len(a.AreaA)
	maxOrdTasks = len(a.AreaA)
	fmt.Println("len(v1) =",maxSites)
	fmt.Println("len(v2) =",maxOrdTasks)

	//for i := 0; i < maxSites -1; i++ {
	//	aprCoorX = a.AreaA[i].LocX
	//	aprCoorY = a.AreaA[i].LocY
	//	fmt.Println(aprCoorX,aprCoorY)ewe
	//}



	i := 0
	aprAlarmTime[i] = 0
	for aprAlarmTime[i] <= (aprShiftLength - aprEmerDuration - minimumDistanceAlarm){
		i++
		aprInterArrival[i] = -math.Log(GetRandom()) * (aprShiftLength / aprMeanRate)
		aprAlarmTime[i] = aprInterArrival[i] + aprAlarmTime[i-1]
		//fmt.Println(aprInterArrival)
		aprAlarmSite[i] = 0
		u := rand.Float64()
		//fmt.Println(u)
		if aprAlarmTime[i] < aprShiftLength {
			for j := 1; j < maxSites; j++ {
				aprUpperBound[j] = 1 / ((float64(maxSites) - 1.0) * float64(j))
				//fmt.Println(j, maxSites, aprUpperBound[j])
				if u < aprUpperBound[j] {
					if u >= aprUpperBound[j-1] {
						aprAlarmSite[i] = j
						fmt.Println(aprAlarmSite[i])
					}
				}
			}
			newOrder := maxOrdTasks + i
			newAlarm := aprAlarmTime[i]
			newSite := aprAlarmSite[i]
			fmt.Printf("Emergencia # %d - tiempo de alarma %g - t duracion %g - nivel importance %g - posicion # %d \n",newOrder,newAlarm,aprEmerDuration,aprEmerImportance,newSite)
		}
	}
}

func GetRandom() float64 {
	rand.Seed(time.Now().UTC().UnixNano())
	return rand.Float64()
}