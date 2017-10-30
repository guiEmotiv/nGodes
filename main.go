package main

import (
	"gopkg.in/fogleman/gg.v1"
	g "github.com/guiemotiv/nGodes/engine"
	"strconv"
)

func main(){

	instances := g.GetOrdinaryTask("./json/ordinarytask.json")
	// make emergency tasks
	a := g.GetTotalEvent(instances)
	//fmt.Println(a)
	g.GetJson(a)
	//g.GetNews(a)
	q := g.GetNews(a)
	g.GetJsonClock(q)

	d := gg.NewContext(400,400)

	for i := 0;i<len(a); i++ {
		d.DrawString(strconv.Itoa(a[i].NewIdSite),a[i].LocX*20+5,a[i].LocY*20+5)
		//d.DrawString(strconv.FormatFloat(a[i].LocX, 'f', 6, 64),a[i].LocX*20-20,a[i].LocY*20-20)
		d.DrawCircle(a[i].LocX*20,a[i].LocY*20,1)
		//fmt.Println("f: ",a[0].LocX*20,a[0].LocY*20)
		//fmt.Println("f: ",a[1].LocX*20,a[1].LocY*20)
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
			// fmt.Println("g",q[0].StepPos.LocX*20, q[0].StepPos.LocY*20)
			// fmt.Println("g",q[1].StepPos.LocX*20, q[1].StepPos.LocY*20)
			d.Fill()
		}else if q[i].StepPos.IdTask == 2{
			d.SetRGB(19, 100, 10)
			d.DrawCircle(q[i].StepPos.LocX*20,q[i].StepPos.LocY*20,2)
			d.Fill()
		}
		//d.DrawCircle(q[i].StepPos.LocX*20,q[i].StepPos.LocY*20,1)
		// //fmt.Println("g",q[0].StepPos.LocX*20, q[0].StepPos.LocY*20)
		// //fmt.Println("g",q[1].StepPos.LocX*20, q[1].StepPos.LocY*20)
		//d.Stroke()
	}

	d.SavePNG("./img/newpos.png")


}




