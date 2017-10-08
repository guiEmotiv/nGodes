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
	i := 0
	for aprAlarmTime[i] <= (aprTimeShift - aprEmerDuration - minimumDistanceAlarm){
		i++
		aprInterArrival[i] = -math.Log(GetRandom()) * (aprTimeShift / aprMeanRate)
		aprAlarmTime[i] = aprInterArrival[i] + aprAlarmTime[i-1]
		//fmt.Println(aprInterArrival)
		u := GetRandom()
		//fmt.Println(u)
		if aprAlarmTime[i] < aprTimeShift {
			for j := 1; j < maxSites ; j++ {
				aprUpperBound[j] = (1.0/(float64(maxSites))) * (float64(j))
				//fmt.Println("upp",aprUpperBound[j])
				if u < aprUpperBound[j] {
					if u >= aprUpperBound[j-1]{
						aprAlarmSite[i] = j
						//fmt.Println("site", aprAlarmSite[i])
					}
				}
			}
			newOrder := maxOrdTasks + i
			newAlarm := aprAlarmTime[i]
			newSite := aprAlarmSite[i]
			fmt.Printf("#tareas max: %d -  Tarea Emer # %d - tiempo de alarma %g - t duracion %g - nivel importance %g - Site # %d \n",
				maxSites, newOrder,newAlarm,aprEmerDuration,aprEmerImportance,newSite)
		}
	}
}

func GetRandom() float64 {
	rand.Seed(time.Now().UTC().UnixNano())
	time.Sleep(time.Nanosecond)
	return rand.Float64()
}


