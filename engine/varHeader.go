package engine

/* VARIABLE EMERGENCY*/

var aprCoorX 				float64
var aprCoorY 				float64
var maxSites				int
var maxOrdTasks 			int
var aprAlarmTime 			[300]float64
var aprAlarmSite			[300]int
var aprInterArrival 		[300]float64
var aprUpperBound			[300]float64
var aprTimeShift			float64 		= 100.0
var aprEmerDuration 		float64			= 7.5
var minimumDistanceAlarm 	float64			= 2.5
var aprMeanRate 			float64			= 2.0
var aprEmerImportance		float64			= 100.0
 

/* MAKE TASKS AND EMERGENCY*/

type NewFormatTasks struct {
	NewIdTask		int
	NewIdSite		int
	NewReleasing	float64
	NewEarliest		float64
	NewLatest		float64
	NewDuration		float64
	NewImportance   float64
	NewTaskType		int
}



