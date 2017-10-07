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
var aprShiftLength			float64 		= 100.0
var aprEmerDuration 		float64			= 7.5
var minimumDistanceAlarm 	float64			= 2.5
var aprMeanRate 			float64			= 2.0
var aprEmerImportance		float64			= 100.0

/* OTHERS VARIABLES*/

var site []int
var tasks []int
var guard []int
var timeStepPlan []int

var maxGuards int

var intFactor float64
var intFactorTOP float64
var timeWeightedTOPFactor string

var showDetails float64
var minimumDistance float64

var allGuardID int
var availableTasksID int
var maxConcurrIterationTime  int
var terminationTime float64
var emerDeterministicDuration float64
var baseReturn bool
var meanRateAlarmPerShift float64

var standarRadious float64
var importAlarma float64

var maxSteps int
var virtualTimeStep float64
var maxAvailableTasks int


var firstAlarmTasksId int
var lastAlarmTasksId int
var timeStepPlanCounter int
var UpperBoundForTimeStepPlan int
var currenAlarmaTime float64





var timeFinTurno = 8.0 * 60 * 60 // sec
var timeInicioTurno = 0.0
var timeOperacion = 15.0 * 60
var timeViaje = (timeFinTurno - timeOperacion) / 5.0
var velocidad = 100.0 / timeViaje


