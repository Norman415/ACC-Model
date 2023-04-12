%% 无人驾驶油门踏板标定程序
% thr=0.5;% 油门开度
% sim('Collibration_acceleration_brake'); %使用的函数

% thr=0;
% for i=1:11
%     sim('Collibration_acceleraiton_brake');
%     v_temp(:,i)=vx.data;
%     a_trmp(:,i)=ax.data;
%     thr_temp(:,i)=ones(length(vx.data),1)*thr;%每个循环下thr是不变的
%     thr=thr+0.1;
% end

%% 合并,一定要转成行向量再合并，否则会导致合并失败
% v=v_temp(:,1)';
% a=a_trmp(:,1)';
% tr=thr_temp(:,1)';
% for i=2:length(a_trmp(1,:))
%     v=[v,v_temp(:,i)'];
%     a=[a,a_trmp(:,i)'];
%     tr=[tr,thr_temp(:,i)'];
% end

%% 拟合
% F=scatteredInterpolant(v',a',tr');%转成列向量
% vu=0:0.1:50;
% au=0:0.1:5;
% table=zeros(length(vu),length(au));
% for i=1:length(vu)
%     for j=1:length(au)
%         table(i,j)=F(vu(i),au(j));
%     end
% end

%% 制动踏板的标定程序
brake=0.1;
for i=1:80
    sim('Collibration_acceleraiton_brake');
    vb_temp(:,i)=vx.data;
    ab_temp(:,i)=ax.data;
    brake_temp(:,i)=ones(length(vx.data),1)*brake;%每个循环下thr是不变的
    brake=brake+0.1;
end

%% 合并,一定要转成行向量再合并，否则会导致合并失败
vbr=vb_temp(:,1)';
abr=ab_temp(:,1)';
br=brake_temp(:,1)';
for i=2:length(ab_temp(1,:))
    vbr=[vbr,vb_temp(:,i)'];
    abr=[abr,ab_temp(:,i)'];
    br=[br,brake_temp(:,i)'];
end
 
%% 拟合
F=scatteredInterpolant(vbr',abr',br');%转成列向量
vubr=0:0.05:50;
aubr=-8:0.05:0;
tablebr=zeros(length(vubr),length(aubr));
for i=1:length(vubr)
    for j=1:length(aubr)
        tablebr(i,j)=F(vubr(i),aubr(j));
    end
end

%% 数据处理
for i=1:length(vubr)
    tablebr(i,length(aubr))=0;
end
