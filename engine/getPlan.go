package engine

import "fmt"

/* C_GuardTemptativePlan */

func ConsiderTemptativePlans(e []NewFormatTasks ,SVTL1 float64, IDAVTask int)  {

	/* var local */
	mLastTask := 2
	for i := 0; i < IDAVTask; i++ {

		if mLastTask > 1 {
			a := append(TemptativePlanFinishTaskExec, mLastTask)
			fmt.Println(a)
		}
		mLastTask++
	}

}



