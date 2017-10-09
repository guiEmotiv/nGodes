package engine

import (
	"fmt"
	"math"
	"math/rand"
	"time"
)

func GetEmergency(a Client) (m NewFormatTasks){

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
				aprUpperBound[j] = (1.0/(float64(maxSites-1))) * (float64(j))
				//fmt.Println("upp",aprUpperBound[j])
				if u < aprUpperBound[j] {
					if u >= aprUpperBound[j-1]{
						aprAlarmSite[i] = j
						//fmt.Println("site", aprAlarmSite[i])
					}
				}
			}
			newOrder := maxOrdTasks + i
			newSite := aprAlarmSite[i]
			newAlarm := aprAlarmTime[i]
			newEarly := aprAlarmTime[i]
			newLast := aprAlarmTime[i] + aprEmerDuration

			m = NewFormatTasks{
				newOrder,
				newSite,
				newAlarm,
				newEarly,
				newLast,
				aprEmerDuration,
				aprEmerImportance,
				0,
			}
			fmt.Print("hola soy m ", m )
			fmt.Printf("#RegularTasks: %d | newIdTasks: %d | newIdSite: %d | releasing: %g | duration: %g | importance: %g \n",
				maxSites, newOrder,newSite, newAlarm,aprEmerDuration,aprEmerImportance)
		}
	}
	return
}

func GetRandom() float64 {
	rand.Seed(time.Now().UTC().UnixNano())
	time.Sleep(time.Nanosecond)
	return rand.Float64()
}


