package main

import (
	//"gopkg.in/fogleman/gg.v1"
	g "github.com/guiemotiv/nGodes/engine"
	"fmt"

)


func main(){

	instances := g.GetOrdinaryTask("./json/ordinarytask.json")
	// make emergency tasks
	a := g.GetTotalEvent(instances)
	fmt.Println(a)
	g.GetJson(a)

	//g.ConsiderTemptativePlans(a, 12.3,2)

	w := make(map[int]int)

	w[0] = 1
	fmt.Println(w)
	w[0] = 2
	fmt.Println(w)
	delete(w,0)
	w[10] = 2
	w[11] = 3
	f := w[10]
	fmt.Println(w)
	fmt.Println(f)





	//	s := TimeStepPlan(range(1:LastTaskId))

}
