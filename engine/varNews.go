package engine

type GetPlan struct {
		StepTime float64 `json:"step_time"`
		IdGuard  int     `json:"id_guard"`
		StepPos
}

type StepPos struct {
	IdTask		int			`json:"id_task"`
	TypeStatus 	int			`json:"type_status"`
	Duration    float64		`json:"duration"`
	Dist 		float64		`json:"dist"`
	LocX		float64		`json:"loc_x"`
	LocY		float64		`json:"loc_y"`
	TimeElapsed float64		`json:"time_elapsed"`
	Coverage
}

type Coverage struct {
	Score			 	float64	`json:"score"`
	ScoreAccumulated 	float64	`json:"score_accumulated"`
	CovByIds			string	`json:"cov_by_ids"`
	CovByMatrix			string	`json:"cov_by_matrix"`
}

var bestEmergency [1]int
var StorePos = make(map[string]StepPos)
var StorePlan = make(map[string]GetPlan)
var StoreCoverage = make(map[string]Coverage)

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
var sliceAllIdTask = make([]NewFormatTasks,lenAllTaskIDs)
var mapAllIdTask = map[int]NewFormatTasks{}
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
var meanRateAlarmsperShift float64 = 2
var criteriados bool
var runMode int
var selectScore int
var acScore float64
var lenAllTaskIDs int


/* COVERAGE TOP SCORE */

var coverageRadius float64
var standardRadius float64 = 7.5
var probAlarmDeltaSite float64
var survivalProbability float64
var startVirtualTimeL1 float64
var virtualTimeStep float64
var currentAlarmTime float64
var siteRelFreq float64
var xCoveredSiteCoordinate float64
var yCoveredSiteCoordinate float64
var xBaseCoordinate float64
var yBaseCoordinate float64
var coverageDistance float64
var localDistance float64
var reservedTime float64
var emergencyDeterministicDuration float64 = 7.5
var probNoAlarm float64
var accumulatedCoverageSite float64