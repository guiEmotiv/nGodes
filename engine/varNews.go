package engine

type GetPlan struct {
	IdPlan		float64		`json:"id_plan"`
	StepTime	float64		`json:"step_time"`
	IdGuard		int 		`json:"id_guard"`
	StepPos
}

type StepPos struct {
	TimeElapsed float64		`json:"time_elapsed"`
	IdTask		int			`json:"id_task"`
	TypeStatus 	int			`json:"type_status"`
	LocX		float64		`json:"loc_x"`
	LocY		float64		`json:"loc_y"`
	Dist 		float64		`json:"dist"`
	Duration    float64		`json:"duration"`
}

var bestEmergency [1]int
var StorePos = make(map[string]StepPos)
var StorePlan = make(map[string]GetPlan)

/* SORT EVERY TASKS */

type sortByWeight []NewFormatTasks
func (a sortByWeight) Len() int  {return len(a)}
func (a sortByWeight) Swap(i, j int) {
	a[i], a[j] = a[j], a[i]
}
func (a sortByWeight) Less(i, j int) bool {
	if a[i].NewImportance < a[j].NewImportance {
		return true
	}
	if a[i].NewImportance > a[j].NewImportance {
		return false
	}
	return a[i].NewIdTask < a[j].NewIdTask
}

/* END IT */
var sortByWe = make([]NewFormatTasks,lenAllTaskIDs)

var StoreByWeight = map[int]NewFormatTasks{}
var StoreEmergency = make(map[int]NewFormatTasks)
var idPlanTaskOrd []int
var idPlanTaskEmer []int

var aPosX, aPosY, nPosX, nPosY float64
var updateX, updateY *float64
var virtualTimeShift float64 = 100.0
var elapsedTime float64
var	virtualStepTime float64
var virtualStartTime float64
var stepTime float64
var stepDist float64
var baseReturn 	bool
var LastExecTime float64
var consideredStartExecTime float64
var deleteId int
var deleteIdEmergency int
var lastPosOrdX float64
var lastPosOrdY float64
var timeSinceConsidered float64
var xxx float64
var smoothedWeight float64
var meanRateAlarmsperShift float64
var criteriados bool
var runMode int
var selectScore int
var acScore float64
var lenAllTaskIDs int