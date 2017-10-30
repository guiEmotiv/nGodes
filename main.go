package main

import (
	"gopkg.in/fogleman/gg.v1"
	g "github.com/guiemotiv/nGodes/engine"
	"strconv"
	"fmt"
)

func main(){

	instances := g.GetOrdinaryTask("./json/ordinarytask.json")
	// make emergency tasks
	a := g.GetTotalEvent(instances)
	//fmt.Println(a)
	g.GetJson(a)
	//g.GetNews(a)
	q, r := g.GetNews(a)
	fmt.Println("vamos",r)
	g.GetJsonClock(q)

	d := gg.NewContext(400,400)

	for i := 0;i<len(a); i++ {
		d.DrawString(strconv.Itoa(a[i].NewIdSite),a[i].LocX*20+5,a[i].LocY*20+5)
		//d.DrawString(strconv.FormatFloat(a[i].LocX, 'f', 6, 64),a[i].LocX*20-20,a[i].LocY*20-20)
		d.DrawCircle(a[i].LocX*20,a[i].LocY*20,1)
		d.SetRGB(255, 255, 0)
		d.Stroke()

	}

	for i := 0; i < len(q)-1; i++ {
		d.SetRGB(10, 100, 100)
		d.Fill()
		d.DrawString(strconv.FormatFloat(q[0].StepPos.LocX, 'f', 6, 64),q[0].StepPos.LocX*20,q[0].StepPos.LocY*20)
		if q[i].StepPos.IdTask == 1  {
			d.SetRGB(100, 100, 1)
			d.DrawCircle(q[i].StepPos.LocX*20,q[i].StepPos.LocY*20,2)
			d.Fill()
		}else if q[i].StepPos.IdTask == 2{
			d.SetRGB(19, 100, 10)
			d.DrawCircle(q[i].StepPos.LocX*20,q[i].StepPos.LocY*20,2)
			d.Fill()
		}
	}

	d.SavePNG("./img/newpos.png")

}




