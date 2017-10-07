package main

import (
	"gopkg.in/fogleman/gg.v1"
	g "github.com/guiemotiv/godes/engine"
	"fmt"
	"math"
)



func main(){

	a := g.GetInstances("./client.json")
	//fmt.Println(a)
	g.GetEmergency(a)

	fmt.Println(-math.Log(g.GetRandom()))

	//var test [4]int
	//test[0] = 2
	//fmt.Print(test)

	//for i := 0; i < 10; i++ {
	//	fmt.Println(-math.Log(rand.Float64()))
	//	fmt.Println(-math.Log(rand.Float64()))
	//}


	gt := gg.NewContext(400, 400)
	gt.SetRGBA(0, 0, 0, 0.1)
	//gt.DrawCirale(200,200,10)
	gt.SetRGB(0, 0, 0)
	//for i := 0; i < len(a.AreaA); i++ {
	//	gt.DrawString(a.AreaA[i].ID, a.AreaA[i].LocX - 20,a.AreaA[i].LocY - 20)
	//	gt.DrawPoint(a.AreaA[i].LocX,a.AreaA[i].LocY,5)
	//	gt.Stroke()
	//	fmt.Println(a.AreaA[i].LocX,a.AreaA[i].LocY)
	//}
	gt.SavePNG("./new.png")
}
