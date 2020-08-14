#players <- read.csv("D:/Diego/Git/FIFA  Players/data/data.csv",header=TRUE,encoding="UTF-8")

#Excluding variables that shouldn't be taken into account
#Photo, Nationality, jersey number, etc.
#players <- players[,-c(1,5,7,11,14,19:21,23:54)]

#Warning: This function assumes the structure of the input dataset doesn't change.
#Only numerical variables related to stats are used.
playerspca <- function(dataset){
  pca1 <- PCA(dataset[,-c(1:5,8,9:19,54)],ncp=10,graph=FALSE)
  output <- as.data.frame(cbind(dataset,pca1$ind$coord))
  #as.data.frame(output)
}

measuredist <- function(dataset,player,n){
  playerid <- which(dataset$ID == player)
  distances <- as.vector(dist(dataset[playerid,55:64],dataset[,55:64]))
  final <- cbind(dataset,distances)
  final <- final[order(distances),]
  final <- head(final,n=n+1)
}

plotting <- function(dataset){
  theta <- c("Crossing","Finishing","HeadingAccuracy","ShortPassing","Volleys","Dribbling","Curve","FKAccuracy",
             "LongPassing","BallControl","Acceleration","SprintSpeed","Agility","Reactions","Balance",
             "ShotPower","Jumping","Stamina","Strength","LongShots","Aggression","Interceptions",
             "Positioning","Vision","Penalties","Composure","Marking","StandingTackle","SlidingTackle",
             "GKDiving","GKHandling","GKKicking","GKPositioning","GKReflexes")
  
  plot <- plot_ly(type='scatterpolar',
                  fill='toself',
                  mode='markers',
                  r=as.numeric(dataset[1,20:53]),
                  theta=theta,
                  name=dataset[1,3],
                  showlegend=TRUE
  )%>% 
    layout(polar = list(radialaxis = list(
      visible = TRUE,
      range = c(0,100)
    )),
    legend=TRUE
    )
  
  for (i in 2:nrow(dataset)){
    plot <- add_trace(plot,
                      r=as.numeric(dataset[i,20:53]),
                      theta=theta,
                      showlegend=TRUE,
                      mode="markers",
                      visible="legendonly",
                      name=dataset[i,3])
  }
  plot
}
