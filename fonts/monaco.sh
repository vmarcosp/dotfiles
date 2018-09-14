  
cd /usr/share/fonts/truetype/

sudo mkdir ttf-monaco

cd ttf-monaco/

sudo wget http://www.gringod.com/wp-upload/software/Fonts/Monaco_Linux.ttf

sudo mkfontdir

cd ..

fc-cache
