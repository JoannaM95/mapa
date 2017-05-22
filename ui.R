shinyUI(fluidPage(
  titlePanel("Oczekiwana długość życia w poszczególnych krajach"),
  column(4, wellPanel(
    sliderInput("rok", "Wybierz rok",
                min = 1800, max = 2016, value = 1908, step=1, sep="")
  )),
  
  column(5,plotOutput("mapa",width="170%")
  )
))