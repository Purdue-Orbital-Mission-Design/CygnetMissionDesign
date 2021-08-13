function [brightness, image] = getBrightnessOfFigure(ax1, fig2)
   delete(gca)
   ax2 = copyobj(ax1, fig2);

   set(fig2, 'GraphicsSmoothing', 'off')
   set(ax2, 'Color', 'k', 'xtick', [], 'ytick', [], 'ztick', [])
   
   frame = getframe();
   colimage = frame2im(frame);
   image = rgb2gray(colimage);
   
   image(image == 240 | image == 210 | image == 255) = 0;
   
   brightness = sum(sum(image)) / numel(image) / 255;
end