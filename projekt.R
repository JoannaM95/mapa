library(RCurl)
library(shiny)
library(choroplethr)
library(choroplethrMaps)
library(ggplot2)

#przygotowanie danych
file=getURL("https://raw.githubusercontent.com/JoannaM95/mapa/master/indicator%20life_expectancy_at_birth.csv")
data = read.csv(textConnection(file), header = T, sep = ",",dec=",")

name=substr(colnames(data),2,5)
colnames(data)=name

a=as.matrix(data[,-1])
b=na.omit(a)
a[which(a<mean(b)-2*sd(b))]=mean(b)-2*sd(b)
a[which(a>mean(b)+2*sd(b))]=mean(b)+2*sd(b)
plot=as.data.frame(a)

row=as.vector(data[,1])
row[188]="St. Barthelemy"
row=tolower(row)
stare=c("united states","macedonia, fyr","serbia","slovak republic","timor-leste","tanzania","bahamas","cote d'ivoire","congo, dem. rep.","congo, rep.","guinea-bissau","kyrgyz republic","lao")
nowe=c("united states of america","macedonia","republic of serbia","slovakia","east timor","united republic of tanzania","the bahamas","ivory coast","democratic republic of the congo","republic of congo","guinea bissau","kyrgyzstan","laos")
for(i in 1:length(stare)){
  row[which(row==stare[i])]=nowe[i]
}

data(country.map)
data(country.regions)
naa=which(is.na(match(row,country.regions$region)))
plot=plot[-naa,]

#aplikacja
server=function(input, output) {
  output$mapa=renderPlot({
    plot2=as.data.frame(cbind(as.vector(row[-naa]),as.vector(plot[input$rok-1799])))
    colnames(plot2)=c("region","value")
    country_choropleth(plot2,num_colors=1) + scale_fill_continuous(name="lat",low="darkolivegreen1", high="darkgreen", na.value="gray77")
  })
}

ui=fluidPage(
  titlePanel("Oczekiwana długość życia"),
  column(4, wellPanel(
    sliderInput("rok", "Wybierz rok",
                min = 1800, max = 2016, value = 1908, step=1, sep="")
  )),
  
  column(5,plotOutput("mapa",width="170%")
  )
)

shinyApp(ui,server)
