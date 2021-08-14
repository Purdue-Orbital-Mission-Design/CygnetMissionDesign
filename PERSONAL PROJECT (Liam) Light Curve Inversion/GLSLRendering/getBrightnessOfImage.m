function brightness = getBrightnessOfImage(colimage)
   image = rgb2gray(colimage);
   
   image(image == 240 | image == 210 | image == 255) = 0;
   
   brightness = sum(sum(image)) / numel(image) / 255;
end