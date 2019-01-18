cd /usr/share/fonts/truetype/

sudo mkdir ttf-firacode && cd ttf-firacode

sudo wget https://github.com/tonsky/FiraCode/releases/download/1.206/FiraCode_1.206.zip -O firacode.zip; sudo unzip firacode.zip; sudo rm firacode.zip;

sudo mv ttf/* . 

sudo rm -rf eot otf ttf woff woff2 *.css *.html

sudo mkfontdir

cd ..

fc-cache
