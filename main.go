package main

import (
	"gopkg.in/fogleman/gg.v1"
	g "github.com/guiemotiv/nGodes/engine"
	"fmt"

)

func main(){

	instances := g.GetOrdinaryTask("./ordinarytask.json")
	//fmt.Println(a)

	// make emergency tasks
	a := g.GetTotalEvent(instances)
	fmt.Println(a)
	g.GetJson(a)


	gt := gg.NewContext(400, 400)
	gt.SetRGBA(0, 0, 0, 0.1)
	//gt.DrawCircle(200,200,10)
	gt.SetRGB(0, 0, 0)
	//for i := 0; i < len(instances.AreaA); i++ {
	//	gt.DrawString(instances.AreaA[i].ID, instances.AreaA[i].LocX - 20,instances.AreaA[i].LocY - 20)
	//	gt.DrawPoint(instances.AreaA[i].LocX,instances.AreaA[i].LocY,5)
	//	gt.Stroke()
	//	//fmt.Println(a.AreaA[i].LocX,a.AreaA[i].LocY)
	//}
	gt.SavePNG("./new.png")
}
