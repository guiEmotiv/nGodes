package engine

/* VARIABLES GLOBALS */
var currAlarmTime 				float64
var xAddressOld 				float64
var yAddressOld 				float64
var considerStartExecTime 		float64
var baseReturn 					bool
var timeShift 					float64 = 100.0
var runMode 					int

/* VARIABLES GET PLAN */
var mLastTask 					int
var LastExecTime 				float64
var mTemPlanEntries 			map[int]float64
var criteriaDos 				bool
var idTempPlanTask 				int
var tempPlanFinishTaskExec	 	int
var meanRateAlarmShift 			float64
var desirabilityScore 			float64
var feasibleTaskId 				[]int
var feasibleScore 				[]float64
var k 							int = 1
var trueIndicator 				int
var topBest 					int
var bestPosition 				int
var mGuardIterationFea 			bool
var bestArrayScore 				[]float64
var bestArrayId 				[]int
var minimun						float64
var minPos						int
var bestPositionNow 			int
var selectedIdTask				int
var arrvalNewTime				float64
var smoWeight					float64
var mProfit						float64
var mRecentSelectedTask			int
var mStopIteration				bool

/* NEW GO DES */

var rOriginXPosition float64
var rOriginYPosition float64