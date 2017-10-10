package engine

/* VARIABLE EMERGENCY*/

var maxSites				int
var maxOrdTasks 			int
var aprAlarmTime 			[100]float64
var aprAlarmSite			[100]int
var aprInterArrival 		[100]float64
var aprUpperBound			[100]float64
var aprTimeShift			float64 		= 100.0
var aprEmerDuration 		float64			= 7.5
var minimumDistanceAlarm 	float64			= 2.5
var aprMeanRate 			float64			= 2.0
var aprEmerImportance		float64			= 100.0

/* MAKE FORMAT TO TOTAL EVENTS*/

type NewFormatTasks struct {
	NewIdTask		int
	NewIdSite		int
	NewReleasing	float64
	NewEarliest		float64
	NewLatest		float64
	NewDuration		float64
	NewImportance   float64
	NewTaskType		int
	LocX			float64
	LocY 			float64
	Frequency		float64
}

var StoreTasks = make(map[string]NewFormatTasks)

/* ORDINARY TASKS FORMAT*/

type OrdinaryTask []struct {
	NewIDTask     int     `json:"NewIdTask"`
	NewIDSite     int     `json:"NewIdSite"`
	NewReleasing  float64 `json:"NewReleasing"`
	NewEarliest   float64 `json:"NewEarliest"`
	NewLatest     float64 `json:"NewLatest"`
	NewDuration   float64 `json:"NewDuration"`
	NewImportance float64 `json:"NewImportance"`
	NewTaskType   int     `json:"NewTaskType"`
	LocX          float64 `json:"LocX"`
	LocY          float64 `json:"LocY"`
	Frequency     float64 `json:"Frequency"`
}
