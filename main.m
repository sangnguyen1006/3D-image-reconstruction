%% Ten thanh vien
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                   %%%
% Nguyen Van Sang     1813823       %%%
% Cao Le Quang Truong 1814546       %%%
% Dinh Nhat Quang     1813659       %%%
%                                   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% De anh DICOM trong mot folder rieng.
%% 
clear all
tic
disp('Processing...');
d = uigetdir(pwd, 'Select a folder');
files = dir(fullfile(d)); % lay thu muc
currentFolder = pwd;
s=size(files);

D=[];
k=0;
for i = 3 : s(1)  % vi i=1,2 khong chua tep
    %str = int2str(i); % chuyen i thanh chuoi
    %str = strcat('\',str,'.dcm');% sap xep theo thu tu "\i.jpg"
    %str = strcat(duongdan_dcm,str); % lay ten day du cua file anh
    k=k+1;
    str=strcat(files(i).folder,'\',files(i).name); 
    img = dicomread(str);
    [img, map] = gray2ind(img,89);
    z=size(img);
        switch z(1)
             case 128
                 img = imresize(img, 1);
             case 256
                 img = imresize(img, 0.5);
             case 512
                 img = imresize(img, 0.25);
        end
     D(:,:,1,k)=img; % [128 128 1 size]
end

%% hien thi tuan tu
figure(1);
for Img = 1:k
    imagesc(D(:,:,Img));
    title('Sequential Display')
    axis off; 
    colormap(map)
    hold on;
    pause(0.3);  % pause(n) slows down image display
end

%% hien thi mot loat cac lat cat
figure(2);
for iImg = 1:k
    subplot(round(sqrt(s(1))+0.5),round(sqrt(s(1))+0.5),iImg);
    imagesc(D(:,:,iImg));
    % Setting display properties
    colormap(map)
    axis image;
    axis off; colorbar
    title(sprintf('Slice # %02d',iImg))      
end

%% hien thi anh 3 mat cat axial, coronal, sagittal 
v=squeeze(D); % bo bot 1 chieu th? 3, v:(128x128xsize)
axial =v(:,:,round(k/2));
coronal = squeeze(v(:,round(128/2),:));
sagital=squeeze(v(round(128/2),:,:)); 
% To improve image quality of coronal and sagittal views
% Affine transform, followed by interpolation is carried out. 
% Defining affine transform
figure(3);
%Displaying axial slice
    subplot(2,2,1);
    imagesc(axial);
    axis off;
    colormap gray;
    title('Axial')
%Displaying coronal slice
    subplot(2,2,2);
    imagesc(coronal);
    colormap gray;
    axis image; axis off
    view(90,90)
    title ('Coronal')
% Displaying sagittal slice
    subplot(2,2,3);
    imagesc(sagital);
    colormap gray;
    axis image; axis off
    view(90,90)
    title('Sagittal')

%% hien thi anh tai tao 3d
figure(4)
D2 = squeeze(D);
image_num = 8;
image(D2(:,:,image_num))
x = xlim;
y = ylim;
xlim(x)
ylim(y)

Ds = smooth3(D2);
hs=0.5;
hiso = patch(isosurface(Ds,hs),...
	'FaceColor',[1,.75,.65],...
	'EdgeColor','none');
%nhung pixel co cuong do > or =5 se duoc to vat 
%chat, nguoc lai thi xem nhu rong khong co vat chat
hcap = patch(isocaps(D2,hs),...
	'FaceColor','interp',...
	'EdgeColor','none');
colormap(map)
axis tight 
daspect([1,1,.4])
lightangle(305,30); 
set(gcf,'Renderer','zbuffer');
lighting phong;
isonormals(Ds,hiso);
set(hcap,'AmbientStrength',.6)
set(hiso,'SpecularColorReflectance',0,'SpecularExponent',50);
X_value=220;
Y_value=30;
view(X_value,Y_value);% goc quay de hien thi
title('Tai tao anh 3D');
set(gca,'fontsize',12);
disp('Done!.');
toc
