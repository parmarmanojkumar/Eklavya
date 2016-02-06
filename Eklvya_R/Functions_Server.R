#Function to run on server
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
        Finalppm <<- 0
        FinalppmVal <<- 0
        Finalfp <<- 0
        FinalfpVal <<- 0
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

updateplot3 <- function(x,y,z, setplot = 0){
        par(fin= c(5,5),mfrow=c(2,2) )
        frame_length = 50
        idx = length(x) - frame_length
        idx1 = length(x) - 10
        if (idx > 0) {
                plot(x[-idx:0], type='l', ylim = c(-40,40),
                     col = 'blue', xlab = "Time stamp", 
                     ylab="Intensity", main=" Lin Acc X")
                plot(y[-idx:0], type='l', ylim = c(-40,40),
                     col = 'green', xlab = "Time stamp", 
                     ylab="Intensity", main=" Lin Acc Y")
                plot(z[-idx:0], type='l', ylim = c(-40,40),
                     col = 'red', xlab = "Time stamp", 
                     ylab="Intensity", main=" Lin Acc Z")
                if (setplot==1){
                        plot(x[-idx:0], type='l', ylim = c(-40,40),
                             col = 'blue', xlab = "Time stamp", 
                             ylab="Intensity", main=" Lin Acc XYZ")
                        lines(y[-idx:0], type='l',col = 'green')
                        lines(z[-idx:0], type='l',col = 'red')
                }else if (setplot==2){
                        scatterplot3d(x[-idx1:0],y[-idx1:0],z[-idx1:0],
                                      col.axis="blue",highlight.3d=TRUE, 
                                      col.grid="lightblue",
                                      xlab = "Intensity X", 
                                      ylab="Intensity Y",
                                      zlab="Intensity Z", 
                                      main=" Lin Acc in 3D",
                                      xlim = c(-40,40),
                                      ylim = c(-40,40), zlim = c(-40,40))
                }
                
                
        }
        else{
                plot(x, type='l', col = 'blue', ylim = c(-40,40), 
                     xlab = "Time stamp", ylab="Intensity", main=" Lin Acc X")
                plot(y, type='l', col = 'green', ylim = c(-40,40), 
                     xlab = "Time stamp", ylab="Intensity", main=" Lin Acc Y")
                plot(z, type='l', col = 'red',ylim = c(-40,40),
                     xlab = "Time stamp", ylab="Intensity", main=" Lin Acc Z")
                if (setplot==1){
                        plot(x, type='l', ylim = c(-40,40),
                             col = 'blue', xlab = "Time stamp", 
                             ylab="Intensity", main=" Lin Acc XYZ")
                        lines(y, type='l',col = 'green')
                        lines(z, type='l',col = 'red')
                }else if (setplot==2){
                        scatterplot3d(x,y,z,col.axis="blue",highlight.3d=TRUE, 
                                      col.grid="lightblue",xlab = "Intensity X", 
                                      ylab="Intensity Y",zlab="Intensity Z", 
                                      main=" Lin Acc in 3D", xlim = c(-40,40),
                                      ylim = c(-40,40), zlim = c(-40,40))
                }
                
        }
}

punchperminutecalc <- function(x,y,z){
        par(fin= c(5,5),mfrow=c(2,2) )
        frame_length = 50
        intensity_threshold = 20
        ppm_intensity = 0
        idx = length(x) - frame_length
        #print("debug1")
        if (idx > 0) {
                ppm_intensity = sqrt(x[-idx:0]**2 + y[-idx:0]**2 + z[-idx:0]**2)
        }else{
                ppm_intensity = sqrt(x**2 + y**2 + z**2)
        }
        #print("debug2")
        #print(ppm_intensity)
        # 50 frames @200ms corresponds to 10 second so ppm is multiplied by 6
#         ppm_count = sum(ppm_intensity > intensity_threshold) * 6
#         Finalppm <<- Finalppm %>% c(ppm_count)
#         Finalppmval <<- ppm_count
        #print(ppm_count)
        updateplot3(x,y,z)
        #print("debug3")
        idx = length(Finalppm) - frame_length
        if (idx > 0) {
                #print(-idx)
                plot(Finalppm[-idx:0], type='l', col = 'blue', 
                     xlab = "Time stamp", ylab="Intensity", main=" Punch Per minute")
                meanppm=mean(Finalppm[-idx:0])
        }else{
                plot(Finalppm, type='l', col = 'blue', 
                     xlab = "Time stamp", ylab="Intensity", main=" Punch Per minute")
                meanppm = mean(Finalppm)
                
        }
        abline(h=meanppm)
        text(1,0, paste0("Mean PPM : ",round(meanppm,digits = 1)), col = "gray60", adj = c(0, -.1))
        #print("debug4")
        
}

punchperminutecount <- function(){
        frame_length = 50
        idx = length(LinAccX) - frame_length
        if (idx > 0) {
                xd = (LinAccX[-idx:0] > 1) * LinAccX[-idx:0]
        }else{
                xd = (LinAccX > 1) * LinAccX
        }
        xds = abs((xd - smooth(xd, "3RS3R")))
        x = sum(xds > 20) * 6
        Finalppm <<-  Finalppm %>% c(x)
        x
}
punchperminutout <- function(){
        Finalppm[length(Finalppm)]
}

punchperminutemax <- function(){
        frame_length = 50
        idx = length(Finalppm) - frame_length
        if (idx > 0) {
                maxcount = max(Finalppm[-idx:0])
        }else{
                maxcount = max(Finalppm)
        }
        maxcount
}



intensitycalc <- function(x,y,z){
        par(fin= c(5,5),mfrow=c(2,2) )
        frame_length = 25
        intensity_threshold = 20
        ppm_intensity = 0
        idx = length(x) - frame_length
        #print("debug1")
#         if (idx > 0) {
#                 ppm_intensity = sqrt(x[-idx:0]**2 + y[-idx:0]**2 + z[-idx:0]**2)
#         }else{
#                 ppm_intensity = sqrt(x**2 + y**2 + z**2)
#         }
        #print("debug2")
        #print(ppm_intensity)
        # 50 frames @200ms corresponds to 10 second so ppm is multiplied by 6
        #         ppm_count = sum(ppm_intensity > intensity_threshold) * 6
        #         Finalppm <<- Finalppm %>% c(ppm_count)
        #         Finalppmval <<- ppm_count
        #print(ppm_count)
        updateplot3(x,y,z)
        #print("debug3")
        idx = length(Finalfp) - frame_length
        if (idx > 0) {
                #print(-idx)
                plot(Finalfp[-idx:0], type='l', col = 'blue', 
                     xlab = "Time stamp", ylab="pound force", main=" Pound Force (@25 kg Punch bag)")
                maxfp=max(Finalfp[-idx:0])
        }else{
                plot(Finalfp, type='l', col = 'blue', 
                     xlab = "Time stamp", ylab="pound force", main="Pound Force (@25 kg Punch bag)")
                maxfp = max(Finalfp)
                
        }
        if (is.na(maxfp)){
                maxfp == 0
        }
        #abline(h=meanfp)
        text(1,0, paste0("Max intensity : ",round(maxfp,digits = 1)), col = "gray60", adj = c(0, -.1))
        #print("debug4")
        
}

intensitycount <- function(){
        frame_length = 50
        idx = length(LinAccX) - frame_length
        if (idx > 0) {
                xdl = (LinAccX[-idx:0])
                ydl = (LinAccY[-idx:0])
                zdl = (LinAccZ[-idx:0])
        }else{
                xdl = LinAccX
                ydl = LinAccY
                zdl = LinAccZ
        }
        xd = (xdl < -2) * xdl
        xds = abs((xd - smooth(xd, "3RS3R")))
        x = (xds > 15)
        xf = xdl[x]
        yf = ydl[x]
        zf = zdl[x]
        allf =  sqrt((xf)**2 + (yf)**2 + (zf)**2)
        #print(allf)
        #allf[allf==0] <- NA
        intensity <- median(allf, na.rm = T)
        if (is.na(intensity)){
                intensity = 0
        }
        #print(intensity)
        forceN <- intensity * 25 # ms2 into mass 5 kg 
        forcepound <- forceN * 0.224809
        Finalfp <<-  Finalfp %>% c(forcepound)
        forcepound
}

intensitymax <- function(){
        frame_length = 25
        idx = length(Finalfp) - frame_length
        if (idx > 0) {
                maxfp = max(Finalfp[-idx:0])
        }else{
                maxfp = max(Finalfp)
        }
        if (is.na(maxfp)){
                return(0)
        }else{
                return(maxfp)
        }
}

lastintenistyout <- function(){
        if (is.na(Finalfp[length(Finalfp)])){
                return (0)
        }else{
                return(Finalfp[length(Finalfp)])
        }
}

initVariables()