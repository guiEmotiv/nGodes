package engine

import (

	"math"
	"math/rand"
	"time"
	"fmt"
	"encoding/json"
	"io/ioutil"
	"os"
)

func GetTotalEvent(a OrdinaryTask) (eventsTotal []NewFormatTasks){
	maxSites = len(a)
	maxOrdTasks = len(a) - 1
	for w := 0; w < maxSites; w++ {
		StoreTasks["Emergency"] = NewFormatTasks{
			a[w].NewIDTask,
			a[w].NewIDSite,
			a[w].NewReleasing,
			a[w].NewEarliest,
			a[w].NewLatest,
			a[w].NewDuration,
			a[w].NewImportance,
			a[w].NewTaskType,
			a[w].LocX,
			a[w].LocY,
			a[w].Frequency,
		}
		for _, v := range StoreTasks {
			eventsTotal = append(eventsTotal, v)
		}
	}
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
			StoreTasks["Emergency"] = NewFormatTasks{
				maxOrdTasks + i,
				aprAlarmSite[i],
				aprAlarmTime[i],
				aprAlarmTime[i],
				aprAlarmTime[i] + aprEmerDuration,
				aprEmerDuration,
				aprEmerImportance,
				0,
				a[aprAlarmSite[i]].LocX,
				a[aprAlarmSite[i]].LocY,
				0,
			}

			for _, v := range StoreTasks {
				eventsTotal = append(eventsTotal, v)
				fmt.Println("StoreTask: ",StoreTasks)
			}
			//fmt.Println(StoreTasks)
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
	jsonFile, _ := json.MarshalIndent(s, "","\t")
	err := ioutil.WriteFile("./json/eventsTotal.json", jsonFile, 0777)
	if err != nil {
		fmt.Println("error when create JSON file")
	}
}

func GetOrdinaryTask(filepath string) OrdinaryTask {
	var newJson OrdinaryTask
	jsonFile, _ := os.Open(filepath)
	defer jsonFile.Close()
	jsonParser := json.NewDecoder(jsonFile)
	jsonParser.Decode(&newJson)
	return newJson
}

func GetTotalEvents(s string) NewFormatTasks {
	var newJson NewFormatTasks
	jsonFile, _ := os.Open(s)
	defer jsonFile.Close()
	jsonParser := json.NewDecoder(jsonFile)
	jsonParser.Decode(&newJson)
	return newJson
}
