program tappy;

//import "phys.so";

global
p;
w;
dead=false;
score=0;
fnt=0;
sp=0;
demo=true;
go =0;
i=0;
pwav=0;
swav=0;
hiscore=0;
begin
//x=fopen("hiscore.dat","r");
//if(x)
//fclose(x);
// if file cant be loaded,
ignore_error(126);
load("tappyhiscore.dat",&hiscore);
//end

timer[0]=0;
timer[1]=0;

set_mode(640400) ;
set_fps(30,0);
w=load_wav("tappy/loop.wav",1);
go=load_wav("tappy/gameover.wav",0);
i=load_wav("tappy/intro2.wav",1);
pwav=load_wav("tappy/point.wav",0);
swav=load_wav("tappy/star.wav",0);

sound(i,256,256);


load_fpg("tappy/tappy.FPG");

fnt=load_fnt("tappy/o.FNT");

write_int(fnt,320,20,4,&score);
write_int(fnt,640,20,5,&hiscore);
write(fnt,420,20,3,"Best:");

start_scroll(0,0,5,4,0,5);

//phys_init();

//ready();
p=plane();
//ready();
sp=camera();



scroll[0].camera=sp;
loop
//star();
//x0+=4;
if(dead==false && demo==false)
if(timer[1]>120 && timer[0]>300)
//rand(0,50)==49)
rocksnow();
timer[1]=0;

end
else
if(timer[2]>500)
let_me_alone();
stop_sound(all_sound);

dead=false;
demo=true;
sound(i,128,256);

p=plane();
sp=camera();
scroll[0].camera=sp;

while(!key(_space))
timer[0]=0;
timer[1]=0;
frame;
end
demo=false;
timer[0]=0;
timer[1]=0;
//scroll[0].camera=sp;
score=0;

end

end

frame;

end

end


process plane()

private;
ox=0;
f=2;
b=false;
//dead=false;
t=0;

begin

x=0;
y=200;
graph=1;

graph=17;

ctype=c_scroll;

t=write(fnt,320,60,4,"press to play!");


taphint();

while(demo==true)

if(key(_space))
demo=false;
timer[0]=0;
timer[1]=0;

end
/*
graph++;
if(graph==4)
graph=1;
end
*/

x+=10;
angle=(200-y)*200;
if(x>1600) x-=1600; end

frame;
end

delete_text(t);
stop_sound(all_sound);

sound(w,256,256);

ready();

loop

if(!key(_space) && !key(_alt) && !mouse.left)
b=false;
end

if(dead==false && (collision(type rocksnow) || collision(type drocksnow)))
//stop_sound(all_sound);
//sound(go,256,256);
//dead=true;
//ready();
die();
end

//if(key(_right))
/*
graph++;
if(graph==4)
graph=1;
end
*/
if(dead==false)
//advance(10);
x=x+10;
if(timer[0]>300)
y=y+f;
end


if(f<10)
f++;
end

if(b==false && (key(_space) || key(_alt) || mouse.left))
f=-10;
b=true;

end

//end
//if(key(_left))
//advance(-10);
//end

//x=mouse.x;
//y=mouse.y;

if(x!=ox)
if(ox>x)
flags=1;
else
flags=0;
end

ox=x;
end


angle=(200-y)*200;
end

if(dead == false && y>380)
die();
//dead=true;
//ready();

end


frame;
end


end


process star()

private
rang=0;

begin
x=rand(640,800)+p.x-320;
y=-20;
graph=6;
angle=0;
ctype=c_scroll;
flags=4;

rang = rand(-135000,-45000);
while(y<420)
if(collision(type plane))
if(graph==6)
score+=10;
sound(swav,256,256);
end

graph=8;
end

angle+=10000;
xadvance(rang,10);

frame;

end

end


process ready()

begin
//angle=cos(timer[0]);

graph=7;
x=father.x+1000;

if(dead==true)
graph=10;
timer[2]=0;
x=sp.x;
z=-1;
end

y=100;
ctype=c_scroll;
//z=20;

//z=513;
loop
angle=cos(timer[0]*3000)*10;
if(dead==true && graph==7)
x=x-10;
end

//size=abs(sin(timer[0]*2000)/20)+100;
//xadvance(0,15);

if(x<father.x-600)
signal(id,s_kill);
//x=father.x+600;
end

frame;
end

end


process drocksnow()
begin
graph=father.graph;
if(graph==16)
graph=9;
else
graph=16;
end


flags=3;
x=father.x+rand(0,50);
y=father.y-400;
ctype=c_scroll;
angle=rand(-10000,10000);


//400-father.y;

loop
frame;
end

end



process rocksnow()
private
r=0;
begin

graph=16;
if(rand(0,1)==1)
graph=9;
end

x=sp.x+400;
y=280+rand(0,150);
ctype=c_scroll;
r=drocksnow();
while(x>sp.x-200)
frame;
end
score++;
sound(pwav,512,256);

while(x>sp.x-400)

frame;
end
star();
frame;
star();
frame;
star();
frame;
star();
signal(r,s_kill);

end

process camera()

begin

ctype=c_scroll;

loop

x=p.x+180;
y=p.y;

frame;
end

end


process taphint()

begin

graph=11;
size=100;
timer[0]=0;
timer[1]=0;
timer[2]=0;

x=father.x+230;
y=father.y;
//ctype=c_scroll;

//taphint2();
taphint3();

while(demo==true)
if(graph==11)
graph=12;
x=50;
else
graph=11;
x=230;
end

frame(1000);
end


end

process taphint3()

begin


graph=14;

y=father.y+50;
x=father.x-30;

while(demo==true)

if(graph==14)
graph=13;
else
graph=14;
end

frame(2000);
end

end


process die()

begin

dead=true;
stop_sound(all_sound);
sound(go,256,256);
x=father.x;
ready();
if(score>hiscore)
hiscore=score;
save("tappyhiscore.dat",&hiscore,sizeof(hiscore));
end
end
