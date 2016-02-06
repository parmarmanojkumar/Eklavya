#Punch analysis
filepath <- "/Users/VirKrupa/Documents/99_hackathon/Eklvya_Repo/Eklvya_R/data_di.txt"
dillepdata <- read.table(filepath)
plot(dillepdata$LinAccX , type='l')

xd = (dillepdata$LinAccX > 1) * dillepdata$LinAccX
xds = abs((xd - smooth(xd, "3RS3R")))
x = xds > 20

yd = (dillepdata$LinAccY > 1) * dillepdata$LinAccY
yds = abs((yd - smooth(yd, "3RS3R")))
y = yds > 20

zd = (dillepdata$LinAccZ > 1) * dillepdata$LinAccZ
zds = abs((zd - smooth(zd, "3RS3R")))
z = zds > 20

par(fin= c(5,5),mfrow=c(3,2) )
plot(xd,type= 'l')

plot(x,type= 'l')

plot(yd,type= 'l')
plot(y,type= 'l')

plot(zd,type= 'l')
plot(z,type= 'l')
sum(x)
sum(y)
sum(z)


