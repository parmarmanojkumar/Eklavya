#Punch analysis
filepath <- "/Users/VirKrupa/Documents/99_hackathon/Eklvya_Repo/Eklvya_R/data_di.txt"
dillepdata <- read.table(filepath)
# plot(dillepdata$LinAccX , type='l')
# par(fin= c(5,5),mfrow=c(1,1) )
# 
# xd = (dillepdata$LinAccX > 1) * dillepdata$LinAccX
# xds = abs((xd - smooth(xd, "3RS3R")))
# x = xds > 20
# 
# yd = (dillepdata$LinAccY > 1) * dillepdata$LinAccY
# yds = abs((yd - smooth(yd, "3RS3R")))
# y = yds > 20
# 
# zd = (dillepdata$LinAccZ > 1) * dillepdata$LinAccZ
# zds = abs((zd - smooth(zd, "3RS3R")))
# z = zds > 20
# 
# par(fin= c(5,5),mfrow=c(3,2) )
# plot(xd,type= 'l')
# 
# plot(x,type= 'l')
# 
# plot(yd,type= 'l')
# plot(y,type= 'l')
# 
# plot(zd,type= 'l')
# plot(z,type= 'l')
# sum(x)
# sum(y)
# sum(z)

par(fin= c(5,5),mfrow=c(1,1), lwd = 1 )

x = dillepdata$LinAccX
Y = dillepdata$LinAccY
z = dillepdata$LinAccZ
len1 = 10
start = 40
x1 = x[start: (start+len1)]
y1 = y[start: (start+len1)]
z1 = z[start: (start+len1)]

s3d <- scatterplot3d(x1,y1,z1, type='o', color = 'green',
                         col.axis="blue",highlight.3d=TRUE, 
                         col.grid="lightblue",xlab = "Intensity X", 
                         ylab="Intensity Y",zlab="Intensity Z", 
                         main=" Lin Acc in 3D", xlim = c(-40,40),
                         ylim = c(-40,40), zlim = c(-40,40), angle = 30) 
len1 = 10
start = 60
x1 = x[start: (start+len1)]
y1 = y[start: (start+len1)]
z1 = z[start: (start+len1)]
s3d$points3d(x1,y1,z1,col='red',type='o', pch = 8) 


