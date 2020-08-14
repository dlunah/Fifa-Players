# Fifa-Players
Side project.  Get player suggestions for your transfers.

This project was inspired on the "The ten most similar players - Pro Evolution Soccer 2019" app, built by Thiago (https://github.com/ThiagoValentimMarques).  Data set obtained from https://www.kaggle.com/karangadiya/fifa19.

Have you ever been unable to complete a transfer either because the player's value doesn't fit your budget, or because their club just won't let them go?  This app aims to help you find options to get a player that can bring similar qualities to your team.

Here, I built a PCA on the player game stats (Crossing, Finishing, Heading, Accuracy, ShortPassing, Volleys, Dribbling, Curve, FKAccuracy, LongPassing, BallControl, Acceleration, SprintSpeed, Agility, Reactions, Balance, ShotPower, Jumping, Stamina, Strength, LongShots, Aggression, Interceptions, Positioning, Vision, Penalties, Composure, Marking, StandingTackle, SlidingTackle, GKDiving, GKHandling, GKKicking, GKPositioning, GKReflexes).  Based on the PCA outcome, I decided to take the first 10 components (accounting by about 91% of the variance, 10th component is the first one that explains less than 1%).  

![Components](/www/Components.png)

This PCA helps separate players; We can see how stattistics that characterize goalkeepers (II quadrant), defense players (IV quadrant) and strikers (I qudrant) are separated by the first two components.  Midfielders will be between strikers and defense players, being really close to the 1st component axis.  This way, the more alike players are, the closer together they will be in the new coordinate system.

![PCAVars](/www/PCAVars.png)

When a player is chosen, an euclidean distance will be calculated between that player and all the others, keeping the n closest ones (n is the number of players the user chose to see).  A radar chart will show the game stats of each player (starting with the chosen one, all others can be added interactively by clickling their name on the legend), and a table with some relevant information will be displayed at the bottom.  Updating the number of players will update these two.
