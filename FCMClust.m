function [center, U, obj_fcn] = FCMClust(data, cluster_n, options)  
% FCMClust.m   ����ģ��C��ֵ�����ݼ�data��Ϊcluster_n��  
%  
% �÷���  
%   1.  [center,U,obj_fcn] = FCMClust(Data,N_cluster,options);  
%   2.  [center,U,obj_fcn] = FCMClust(Data,N_cluster);  
%    
% ���룺  
%   data        ---- nxm����,��ʾn������,ÿ����������m��ά����ֵ  
%   N_cluster   ---- ����,��ʾ�ۺ�������Ŀ,�������  
%   options     ---- 4x1��������  
%       options(1):  �����Ⱦ���U��ָ����>1                  (ȱʡֵ: 2.0)  
%       options(2):  ����������                           (ȱʡֵ: 100)  
%       options(3):  ��������С�仯��,������ֹ����           (ȱʡֵ: 1e-5)  
%       options(4):  ÿ�ε����Ƿ������Ϣ��־                (ȱʡֵ: 1)  
% �����  
%   center      ---- ��������  
%   U           ---- �����Ⱦ���  
%   obj_fcn     ---- Ŀ�꺯��ֵ  
%   Example:  
%       data = rand(100,2);  
%       [center,U,obj_fcn] = FCMClust(data,2);  
%       plot(data(:,1), data(:,2),'o');  
%       hold on;  
%       maxU = max(U);  
%       index1 = find(U(1,:) == maxU);  
%       index2 = find(U(2,:) == maxU);  
%       line(data(index1,1),data(index1,2),'marker','*','color','g');  
%       line(data(index2,1),data(index2,2),'marker','*','color','r');  
%       plot([center([1 2],1)],[center([1 2],2)],'*','color','k')  
%       hold off;  
  
   
  
if nargin ~= 2 & nargin ~= 3,    %�ж������������ֻ����2����3��  
 error('Too many or too few input arguments!');  
end  
  
data_n = size(data, 1); % ���data�ĵ�һά(rows)��,����������  
in_n = size(data, 2);   % ���data�ĵڶ�ά(columns)����������ֵ����  
% Ĭ�ϲ�������  
default_options = [5; % �����Ⱦ���U��ָ��  
    50;                % ����������  
    1e-5;               % ��������С�仯��,������ֹ����  
    1];                 % ÿ�ε����Ƿ������Ϣ��־  
  
if nargin == 2,  
 options = default_options;  
 else       %������options������ʱ������  
 % ���������������Ƕ���ô�͵���Ĭ�ϵ�option;  
 if length(options) < 4, %����û�����opition������4����ô������Ĭ��ֵ;  
  tmp = default_options;  
  tmp(1:length(options)) = options;  
  options = tmp;  
  end  
    % ����options��������ֵΪ0(��NaN),������ʱΪ1  
 nan_index = find(isnan(options)==1);  
    %��denfault_options�ж�Ӧλ�õĲ�����ֵ��options�в�������λ��.  
 options(nan_index) = default_options(nan_index);  
 if options(1) <= 1, %���ģ�������ָ��С�ڵ���1  
  error('The exponent should be greater than 1!');  
 end  
end  
%��options �еķ����ֱ�ֵ���ĸ�����;  
expo = options(1);          % �����Ⱦ���U��ָ��  
max_iter = options(2);  % ����������  
min_impro = options(3);  % ��������С�仯��,������ֹ����  
display = options(4);  % ÿ�ε����Ƿ������Ϣ��־  
  
obj_fcn = zeros(max_iter, 1); % ��ʼ���������obj_fcn  
  
U = initfcm(cluster_n, data_n);     % ��ʼ��ģ���������,ʹU�����������Ϊ1,  
center = [0.2;0.9];
% Main loop  ��Ҫѭ��  
for i = 1:max_iter,  
    %�ڵ�k��ѭ���иı��������ceneter,�ͷ��亯��U��������ֵ;  
%      [U, center, obj_fcn(i),expo] = stepfcm(data, center, cluster_n, expo);  
     [U, center, obj_fcn(i),expo] = stepfcm(data, U, cluster_n, expo); 
     if display,  
      fprintf('FCM:Iteration count = %d, obj. fcn = %f, expo=%f, center_1=%f, center_2=%f\n', i, obj_fcn(i),expo,center(1),center(2));  
     end  
     % ��ֹ�����б�  
     if i > 1,  
      if abs(obj_fcn(i) - obj_fcn(i-1)) < min_impro,  
                break;  
            end,  
     end  
end  
  
iter_n = i; % ʵ�ʵ�������  
obj_fcn(iter_n+1:max_iter) = [];  
  
  
% �Ӻ���  
function U = initfcm(cluster_n, data_n)  
% ��ʼ��fcm�������Ⱥ�������  
% ����:  
%   cluster_n   ---- �������ĸ���  
%   data_n      ---- ��������  
% �����  
%   U           ---- ��ʼ���������Ⱦ���  
U = rand(cluster_n, data_n);  
col_sum = sum(U);  
U = U./col_sum(ones(cluster_n, 1), :);  
  
   
%ԭʼ��FCM   
% �Ӻ���  
function [U_new, center, obj_fcn, expo_new] = stepfcm(data, U, cluster_n, expo)  
% ģ��C��ֵ����ʱ������һ��  
% ���룺  
%   data        ---- nxm����,��ʾn������,ÿ����������m��ά����ֵ  
%   U           ---- �����Ⱦ���  
%   cluster_n   ---- ����,��ʾ�ۺ�������Ŀ,�������  
%   expo        ---- �����Ⱦ���U��ָ��                       
% �����  
%   U_new       ---- ������������µ������Ⱦ���  
%   center      ---- ������������µľ�������  
%   obj_fcn     ---- Ŀ�꺯��ֵ  
mf = U.^expo;       % �����Ⱦ������ָ��������  
center = mf*data./((ones(size(data, 2), 1)*sum(mf'))'); % �¾�������(5.4)ʽ  
dist = distfcm(center, data);       % ����������  
obj_fcn = sum(sum((dist.^2).*mf)) + expo;  % ����Ŀ�꺯��ֵ (5.1)ʽ  
tmp = dist.^(-2/(expo-1));      
U_new = tmp./(ones(cluster_n, 1)*sum(tmp));  % �����µ������Ⱦ��� (5.3)ʽ  
% expo_new = expo;
% expo_new = sum(sum(U_new.*dist + 2.*dist))./sum(sum(dist)); %m0 = 2
% expo_new = sum(sum( 6.*U_new.*dist.^2 - U_new.^2.*dist.^2))./sum(sum(2.*U_new.*dist.^2)); %m0 = 2
% expo_new = (-sum(sum(log(-1./(log(U_new).*dist.^2))))./sum(sum(log(U_new)))).*0.6742;
%expo_new = -sum(sum(log(-0.17144./(log(U_new).*dist.^2))))./sum(sum(log(U_new)));  %FLIR0359.jpg
% expo_new = -sum(sum(log(-0.268./(log(U_new).*dist.^2))))./sum(sum(log(U_new))); %FLIR0371.jpg ����50��
expo_new = -sum(sum(log(-0.14744./(log(U_new).*dist.^2))))./sum(sum(log(U_new)));  %FLIR0359.jpg ����50��

% ��ʼ�������ģ��ȸ��������Ⱦ����ٸ��¾�������
% % �Ӻ���  
% function [U_new, center, obj_fcn, expo_new] = stepfcm(data, center, cluster_n, expo)  
% % ģ��C��ֵ����ʱ������һ��  
% % ���룺  
% %   data        ---- nxm����,��ʾn������,ÿ����������m��ά����ֵ  
% %   U           ---- �����Ⱦ���  
% %   cluster_n   ---- ����,��ʾ�ۺ�������Ŀ,�������  
% %   expo        ---- �����Ⱦ���U��ָ��                       
% % �����  
% %   U_new       ---- ������������µ������Ⱦ���  
% %   center      ---- ������������µľ�������  
% %   obj_fcn     ---- Ŀ�꺯��ֵ  
% 
% dist = distfcm(center, data);       % ���������� 
% tmp = dist.^(-2/(expo-1));      
% U_new = tmp./(ones(cluster_n, 1)*sum(tmp));  % �����µ������Ⱦ��� (5.3)ʽ  
% mf = U_new.^expo;       % �����Ⱦ������ָ��������  
% obj_fcn = sum(sum((dist.^2).*mf));  % ����Ŀ�꺯��ֵ (5.1)ʽ  
% center = mf*data./((ones(size(data, 2), 1)*sum(mf'))'); % �¾�������(5.4)ʽ  
% expo_new = expo;
% % expo_new = sum(sum(2.*dist.^2 - U_new.*dist.^2))./sum(sum(dist.^2));

%�������������ĵĵ���������̩��չ��
% �Ӻ���  
% function [U_new, center, obj_fcn, expo_new] = stepfcm(data, U, cluster_n, expo)  
% % ģ��C��ֵ����ʱ������һ��  
% % ���룺  
% %   data        ---- nxm����,��ʾn������,ÿ����������m��ά����ֵ  
% %   U           ---- �����Ⱦ���  
% %   cluster_n   ---- ����,��ʾ�ۺ�������Ŀ,�������  
% %   expo        ---- �����Ⱦ���U��ָ��                       
% % �����  
% %   U_new       ---- ������������µ������Ⱦ���  
% %   center      ---- ������������µľ�������  
% %   obj_fcn     ---- Ŀ�꺯��ֵ  
% % mf = U.^expo;       % �����Ⱦ������ָ��������  
% mf = U.^2 + (expo-2)*log(U).*U.^2 + log(U).*log(U).*(expo-2).^2.*U.^2;       % �����Ⱦ������ָ��������  
% center = mf*data./((ones(size(data, 2), 1)*sum(mf'))'); % �¾�������(5.4)ʽ  
% dist = distfcm(center, data);       % ����������  
% obj_fcn = sum(sum((dist.^2).*mf));  % ����Ŀ�꺯��ֵ (5.1)ʽ  
% 
% 
% U_new = (-2*(expo-2).*dist.^2 - ones(cluster_n, 1)*sum((-2*expo*dist.^2 + 2*dist.^2)))./(2*dist.^2);
% 
% % tmp = dist.^(-2/(expo-1));      
% % U_new = tmp./(ones(cluster_n, 1)*sum(tmp));  % �����µ������Ⱦ��� (5.3)ʽ  
% % expo_new = expo;
% expo_new = sum(sum(U_new.*dist + 2.*dist))./sum(sum(dist)); %m0 = 2
% % expo_new = sum(sum( 6.*U_new.*dist.^2 - U_new.^2.*dist.^2))./sum(sum(2.*U_new.*dist.^2)); %m0 = 3
  
   
  
% �Ӻ���  
function out = distfcm(center, data)  
% �������������������ĵľ���  
% ���룺  
%   center     ---- ��������  
%   data       ---- ������  
% �����  
%   out        ---- ����  
out = zeros(size(center, 1), size(data, 1));  
for k = 1:size(center, 1), % ��ÿһ����������  
    % ÿһ��ѭ��������������㵽һ���������ĵľ���  
    out(k, :) = sqrt(sum(((data-ones(size(data,1),1)*center(k,:)).^2)',1));  
end  
