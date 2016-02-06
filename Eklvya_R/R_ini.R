install.packages(c("Cairo", "scatterplot3d","dplyr","Rserve"))
library(c("Cairo", "scatterplot3d","dplyr","Rserve"))
require(Rserve)
Rserve(args = '--no-save --RS-enable-control')
require(RSclient)
c <- RS.connect()
RS.close(c)


