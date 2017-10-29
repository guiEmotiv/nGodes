package engine

type GetPlan struct {
	IdPlan		float64		`json:"id_plan"`
	StepTime	float64		`json:"step_time"`
	IdGuard		int 		`json:"id_guard"`
	StepPos
}

type StepPos struct {
	TimeElapsed float64
	IdTask		int
	TypeStatus 	int
	LocX		float64
	LocY		float64
	Dist 		float64
	Duration    float64
}

var lastPosOrdX float64
var lastPosOrdY float64
var StorePos = make(map[string]StepPos)
var StorePlan = make(map[string]GetPlan)
//var storeIdOrdnew = make([]int,len(sortByWe))

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
var sortByWe = make([]NewFormatTasks,30)
var StoreByWeight = map[int]NewFormatTasks{}
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
var ConsideredStartExecTime float64
var deleteId int