package main

import (
	"gopkg.in/fogleman/gg.v1"
	g "github.com/guiemotiv/nGodes/engine"
	"time"
	"math/rand"

	"fmt"
)

func main(){
	rand.Seed( time.Now().UTC().UnixNano())
	instances := g.GetInstances("./client.json")
	//fmt.Println(a)

	// make emergency tasks
	g.GetEmergency(instances)
	//fmt.Println(s.NewIdTask)
	fmt.Println(instances)
	// make regular tasks



	gt := gg.NewContext(400, 400)
	gt.SetRGBA(0, 0, 0, 0.1)
	//gt.DrawCirale(200,200,10)
	gt.SetRGB(0, 0, 0)
	for i := 0; i < len(instances.AreaA); i++ {
		gt.DrawString(instances.AreaA[i].ID, instances.AreaA[i].LocX - 20,instances.AreaA[i].LocY - 20)
		gt.DrawPoint(instances.AreaA[i].LocX,instances.AreaA[i].LocY,5)
		gt.Stroke()
		//fmt.Println(a.AreaA[i].LocX,a.AreaA[i].LocY)
	}
	gt.SavePNG("./new.png")
}
