initVariables <- function (){
        # Initialization of variables
        Acccalib <<- 0
        Magcalib <<- 0
        GyroCalib <<- 0
        LinAccX <<- 0
        LinAccY <<- 0
        LinAccZ <<- 0
        GravAccX <<- 0
        GravAccY <<- 0
        GravAccZ <<- 0
        EulerX <<- 0
        EulerY <<- 0
        EulerZ <<-0
}

updatecalib <- function(var1, var2, var3, var4, var5, var6){
        #Update calib
        Acccalib <<- Acccalib %>% c(var1,var4)
        Magcalib <<- Magcalib %>% c(var2,var5)
        GyroCalib <<- GyroCalib %>% c(var3,var6)
}
updateLinAcc<- function(var1, var2, var3, var4, var5, var6){
        #Update LinAcc
        LinAccX <<- LinAccX %>% c(var1,var4)
        LinAccY <<- LinAccY %>% c(var2,var5)
        LinAccZ <<- LinAccZ %>% c(var3,var6)
}

updateGravAcc<- function(var1, var2, var3, var4, var5, var6){
        #Update GravAcc
        GravAccX <<- GravAccX %>% c(var1,var4)
        GravAccY <<- GravAccY %>% c(var2,var5)
        GravAccZ <<- GravAccZ %>% c(var3,var6)
}

updateEuler<- function(var1, var2, var3, var4, var5, var6){
        #Update Euler
        EulerX <<- EulerX %>% c(var1,var4)
        EulerY <<- EulerY %>% c(var2,var5)
        EulerZ <<- EulerZ %>% c(var3,var6)
}

updateplot3 <- function(x,y,z){
        par(fin= c(5,5),mfrow=c(2,2) )
        idx = length(x)
        if (idx > 50) {
                idx1 = idx -10
                idx = idx -50
                plot(x[-idx:0], type='l', ylim = c(-40,40),col = 'blue', xlab = "Time stamp", ylab="Intensity", main=" Lin Acc X")
                plot(y[-idx:0], type='l', ylim = c(-40,40),col = 'green', xlab = "Time stamp", ylab="Intensity", main=" Lin Acc Y")
                plot(z[-idx:0], type='l', ylim = c(-40,40),col = 'red', xlab = "Time stamp", ylab="Intensity", main=" Lin Acc Z")
                scatterplot3d(x[-idx1:0],y[-idx1:0],z[-idx1:0],col.axis="blue",highlight.3d=TRUE, col.grid="lightblue",xlab = "Intensity X", ylab="Intensity Y",zlab="Intensity Z", main=" Lin Acc in 3D")
                
        }
        else{
                plot(x, type='l', col = 'blue', ylim = c(-40,40), xlab = "Time stamp", ylab="Intensity", main=" Lin Acc X")
                plot(y, type='l', col = 'green', ylim = c(-40,40), xlab = "Time stamp", ylab="Intensity", main=" Lin Acc Y")
                plot(z, type='l', col = 'red',ylim = c(-40,40),xlab = "Time stamp", ylab="Intensity", main=" Lin Acc Z")
                scatterplot3d(x,y,z,col.axis="blue",highlight.3d=TRUE, col.grid="lightblue",xlab = "Intensity X", ylab="Intensity Y",zlab="Intensity Z", main=" Lin Acc in 3D")
        }
}

initVariables()