library(shiny)
library(DT)
library(plyr)
library(dplyr)

### Shiny user interface ###

ui <- fluidPage(
  
titlePanel(strong("Single Species Persistence Model", titleWidth = 350)),

div(style="display: inline-block;vertical-align:top; width: 300px;", fileInput("file", "Choose data CSV File", multiple = FALSE, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv"))),

fluidRow(style = "margin-top: 25px;",
         column(6, p(tags$b('Persistence Probabilities for each year', style = "font-size: 150%; font-family:Helvetica; color:#4c4c4c; text-align:left;"))),
         column(6, p(tags$b('Persistence Probabilities for the most recent year', style = "font-size: 150%; font-family:Helvetica; color:#4c4c4c; text-align:left;")))),
fluidRow(column(6, DTOutput("persistence1")),
         column(6, DTOutput("persistence2")))
)

### Shiny server ###

server <- function(input, output) {

# Input data csv file

filedata <- reactive({
  inFile <- input$file
  if (is.null(inFile)){return(NULL)}
  
  y <- as.data.frame(read.csv(inFile$datapath, fileEncoding="UTF-8-BOM"))
  y <- y[order(y$Locality, y$Year),]
  
  nLoc = length(unique(y$Locality))
  nyear = length(unique(y$Year))

  y$Occ <- y$Count
  y$Occ[!is.na(y$Occ)] <- 1
  y$Occ[is.na(y$Occ)] <- 0
  y$T <- rep(1:nyear, nLoc)
  y$N <- y$Occ
  y$t <- NA
  
  a <- split(y, y$Locality)
  for (j in 1:nLoc) { a[[j]]$N[1] <- ifelse((a[[j]]$Occ[1]==1), 1,0)}
  for (j in 1:nLoc){a[[j]]$t[1] = 0}
  for (j in 1:nLoc) {{for(i in 2:nyear) { a[[j]]$N[i] <- if(a[[j]]$Occ[i]==1) { (1 + a[[j]]$N[i-1]) } else { (a[[j]]$N[i-1]) }}}}
  for (j in 1:nLoc) {for(i in 2:nyear) { a[[j]]$t[i] <- (a[[j]]$N[i-1]) }}
  y$N <- unlist(lapply(seq_along(1:nLoc), function(x) as.numeric(a[[x]]$N)))
  y$t <- unlist(lapply(seq_along(1:nLoc), function(x) as.numeric(a[[x]]$t)))
  y$P <- mapply(function(N, T, t) (1/(1+(((T/t)^(N-1)-1)/(N-1)))), y$N,y$T,y$t)
  y$Conclusion <- with(y, ifelse(y$P==1, "Persisting", ifelse(y$P < 0.5 & y$P >= 0, "More likely to extinct", "More likely to extant")))
  y$P <- format(round(y$P, 4), nsmall = 5)
  return(y)
})

# Persistence table output for each year

output$persistence1 <- renderDT({
  if (is.null(input$file)) {return(NULL)}
  df <- filedata()
  df = subset(df, select = c(Locality, Year, Count, P, Conclusion))
  return(df)
})

# Persistence table output for most recent years

output$persistence2 <- renderDT({
  if (is.null(input$file)) {return(NULL)}
  df <- filedata()
  df = subset(df, select = c(Locality, Year, Count, P, Conclusion))
  df <- df[which(df$Year== max(df$Year)),]
  return(df)
})

}

shinyApp(ui, server)
