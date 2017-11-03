package main

import (
	g "github.com/guiemotiv/nGodes/engine"
	"fmt"
	"gopkg.in/fogleman/gg.v1"
	"strconv"
	"github.com/gin-gonic/gin"
)

func main(){

	instances := g.GetOrdinaryTask("./json/ordinarytask.json")
	// make emergency tasks
	a := g.GetTotalEvent(instances)

	//fmt.Println(a)

	q, r := g.GetNews(a)
	fmt.Println("BEST ACUMULADO",r)
	g.GetJsonClock(q)
			//
			d := gg.NewContext(600,600)

			for i := 0;i<len(a); i++ {
				d.DrawString(strconv.Itoa(a[i].NewIdSite),a[i].LocX*35+5,a[i].LocY*35+5)
				//d.DrawString(strconv.FormatFloat(a[i].LocX, 'f', 6, 64),a[i].LocX*20-20,a[i].LocY*20-20)

				d.DrawCircle(a[i].LocX*35,a[i].LocY*35,1)
				d.SetRGB(255, 255, 0)
				d.Stroke()

			}

			for i := 0; i < len(q)-1; i++ {
				d.DrawCircle(q[35].LocX*35,q[35].LocY*35,q[35].Coverage.Score*35)
				d.Stroke()
				d.SetRGB(100, 10, 100)
				d.Fill()
				d.SetRGB(100, 1, 1)
				d.DrawCircle(q[0].StepPos.LocX*35,q[0].StepPos.LocY*35,2)
				d.Fill()
				d.DrawString("BASE: (6, 9.5)",q[0].StepPos.LocX*35+5,q[0].StepPos.LocY*35)

				if q[i].StepPos.IdTask == 1  {
					d.SetRGB(100, 100, 1)
					d.DrawCircle(q[i].StepPos.LocX*35,q[i].StepPos.LocY*35,2)
					d.Fill()
				}else if q[i].StepPos.IdTask == 2{
					d.SetRGB(19, 100, 10)
					d.DrawCircle(q[i].StepPos.LocX*35,q[i].StepPos.LocY*35,3)
					d.Fill()
				}
			}

			d.SavePNG("./img/newpos.png")

	/******** Discrete Event Simulation Models in Go  *********/

	e := gin.Default()
	e.GET("/", func(c *gin.Context) {
		c.JSON(200, q )})
	e.LoadHTMLGlob("public/*")
	e.Static("/src","./src")
	e.GET("/index", func(c *gin.Context) {
		c.HTML(200,"index.html",gin.H{

		})
	})
	// engine.GET("/create-algorithm")
	e.Run() // listen and serve on 0.0.0.0:8080

	/******** Discrete Event Simulation Models in Go  *********/

}



