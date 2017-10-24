package engine

type GetPlan struct {
	IdPlan		float64		`json:"id_plan"`
	StepTime	float64		`json:"step_time"`
	IdGuard		int 		`json:"id_guard"`
	StepPos
	Status		bool			`json:"status"`

}

type StepPos struct {
	LocX	float64
	LocY	float64
	Dist 	float64
}

var StorePos = make(map[string]StepPos)
var StorePlan = make(map[string]GetPlan)

/* SORT EVERY TASKS */

type byEarliest []NewFormatTasks

func (a byEarliest) Len() int  {return len(a)}
func (a byEarliest) Swap(i, j int) {
	a[i], a[j] = a[j], a[i]
}
func (a byEarliest) Less(i, j int) bool {
	if a[i].NewEarliest < a[j].NewEarliest {
		return true
	}
	if a[i].NewEarliest > a[j].NewEarliest {
		return false
	}
	return a[i].NewIdTask < a[j].NewIdTask
}

/* END IT */

var vTT float64
var vTS float64
var stepTime float64
var newX1, newY1, newX2, newY2 float64
var distq float64
var l int