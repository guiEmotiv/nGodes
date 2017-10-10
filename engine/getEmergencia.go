package engine

import (

	"math"
	"math/rand"
	"time"
	"fmt"
	"encoding/json"
	"io/ioutil"
)

func GetEmergency(a Client) (total []NewFormatTasks){

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
			for j := 1; j <= maxSites ; j++ {
				aprUpperBound[j] = (1.0/(float64(maxSites-1))) * (float64(j))
				//fmt.Println("upp",aprUpperBound[j])
				if u < aprUpperBound[j] {
					if u >= aprUpperBound[j-1]{
						aprAlarmSite[i] = j
						//fmt.Println("site", aprAlarmSite[i])
					}
				}
			}

			Store["Emergency"] = NewFormatTasks{
				maxOrdTasks + i,
				aprAlarmSite[i],
				aprAlarmTime[i],
				aprAlarmTime[i],
				aprAlarmTime[i] + aprEmerDuration,
					aprEmerDuration,
					aprEmerImportance,
					0,
			}
			for _, v := range Store {
				total = append(total, v)
			}
			fmt.Println(Store)
			//fmt.Println(s)
			//fmt.Printf("#RegularTasks: %d | newIdTasks: %d | newIdSite: %d | releasing: %g | duration: %g | importance: %g \n",
			//	maxSites, newOrder,newSite, newAlarm,aprEmerDuration,aprEmerImportance)

		}
	}

	return
}

func GetRandom() float64 {
	rand.Seed(time.Now().UTC().UnixNano())
	time.Sleep(time.Nanosecond)
	return rand.Float64()
}

func GetJson(s []NewFormatTasks) {
	output, _ := json.MarshalIndent(s, "","\t")
	error := ioutil.WriteFile("post.json", output, 0777)
	if error != nil {
		fmt.Println("error json")

	}
}

