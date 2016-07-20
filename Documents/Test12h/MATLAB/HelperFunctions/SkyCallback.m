function [] = SkyCallback( ~,~,fh,F)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

value = floor(get(findobj(gcf,'Tag','SkyCallback'),'Value'));
disp(value)
thisax = axes('Parent', fh);
image(F(value).cdata, 'Parent', thisax);
disp(F)

end

