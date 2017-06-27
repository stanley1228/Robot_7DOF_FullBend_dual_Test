
clear all
close all
clc




%�T�w�Ѽ�
L0=225;   %�Y��ӻH
L1=250;   %L�� ����
L2=50;    %L�� �u��
L3=50;    %L�� �u��
L4=250;   %L�� ���� 
L5=150;   %��end-effector

x_base_R=0;   %����I
y_base_R=0;
z_base_R=0;

x_base_L=0;   %����I
y_base_L=0;
z_base_L=0;


DEF_DESCRETE_POINT=90;

Path_R=zeros(DEF_DESCRETE_POINT,3);%�W�e�����|�I
PathPoint_R=zeros(DEF_DESCRETE_POINT,3);%�O����ڤW���I�A�e�Ϩϥ�
PathTheta_R=zeros(DEF_DESCRETE_POINT,7);%�O���C�b���סA�e�Ϩϥ�
 
Path_L=zeros(DEF_DESCRETE_POINT,3);%�W�e�����|�I
PathPoint_L=zeros(DEF_DESCRETE_POINT,3);%�O����ڤW���I�A�e�Ϩϥ�
PathTheta_L=zeros(DEF_DESCRETE_POINT,7);%�O���C�b���סA�e�Ϩϥ�

%% �Ѱ_�l�I���e�i100�i��k��u���_��   ���Ƥj�p200x200  ��t10
R_point1 = [300 -10 0];
L_point1 = [300 90 0];

R_point2 = [500 -10 0]; %���e200
L_point2 = [500 90 0]; %���e200

%%�i�����90��
R_point3 = [300 -10 0]; %�k���P�}�� x����h200 
L_point3 = [500 90 0]; %���⤣��

R_point4 = [500 -10 0]; %�k��x ��P���e200   
L_point4 = [300 90 0];  %����x ��P����200  


R_point5 = [300 -10 0]; %�k���P�}x����200
L_point5 = [300 90 0]; %���⤣��

%%���e200�i���_��
R_point6 = [500 -10 0]; %�k��x���e200
L_point6 = [500 90 0];  %����x���e200


for t=1:1:DEF_DESCRETE_POINT
    if t<=DEF_DESCRETE_POINT*0.2
        Path_R(t,1:3)=R_point1+(R_point2-R_point1)*t/(DEF_DESCRETE_POINT*0.2);%���e200
        Path_L(t,1:3)=L_point1+(L_point2-L_point1)*t/(DEF_DESCRETE_POINT*0.2);%���e200
    elseif t<=DEF_DESCRETE_POINT*0.4
        Path_R(t,1:3)=R_point2+(R_point3-R_point2)*(t-DEF_DESCRETE_POINT*0.2)/(DEF_DESCRETE_POINT*0.2);%�k���P�}�� x����h200
        Path_L(t,1:3)=L_point2+(L_point3-L_point2)*(t-DEF_DESCRETE_POINT*0.2)/(DEF_DESCRETE_POINT*0.2);%���⤣��
    elseif t<=DEF_DESCRETE_POINT*0.6
        xcR=(500+300)*0.5;
        ycR=-10;
        zcR=0;
        rR=500-xcR;
        
        xcL=(500+300)*0.5;
        ycL=90;
        zcL=0;
        rL=500-xcL;
              
        Path_R(t,1:3)=[xcR ycR zcR]+rR*[cos( pi*(t-DEF_DESCRETE_POINT*0.4)/(DEF_DESCRETE_POINT*0.2) + pi) sin(pi*(t-DEF_DESCRETE_POINT*0.4)/(DEF_DESCRETE_POINT*0.2) + pi) 0]; %�k��U��W����
        Path_L(t,1:3)=[xcL ycL zcL]+rL*[cos( pi*(t-DEF_DESCRETE_POINT*0.4)/(DEF_DESCRETE_POINT*0.2)) sin(pi*(t-DEF_DESCRETE_POINT*0.4)/(DEF_DESCRETE_POINT*0.2)) 0]; %����W��U����
 
    elseif t<=DEF_DESCRETE_POINT*0.8
        Path_R(t,1:3)=R_point4+(R_point5-R_point4)*(t-DEF_DESCRETE_POINT*0.6)/(DEF_DESCRETE_POINT*0.2);
        Path_L(t,1:3)=L_point4+(L_point5-L_point4)*(t-DEF_DESCRETE_POINT*0.6)/(DEF_DESCRETE_POINT*0.2);
    elseif t<=DEF_DESCRETE_POINT
        Path_R(t,1:3)=R_point5+(R_point6-R_point5)*(t-DEF_DESCRETE_POINT*0.8)/(DEF_DESCRETE_POINT*0.2);
        Path_L(t,1:3)=L_point5+(L_point6-L_point5)*(t-DEF_DESCRETE_POINT*0.8)/(DEF_DESCRETE_POINT*0.2);
    end
    
end

for t=1:1:DEF_DESCRETE_POINT
 
    %��J�Ѽ�
    in_x_end_R=Path_R(t,1);
    in_y_end_R=Path_R(t,2);
    in_z_end_R=Path_R(t,3);
    
    in_x_end_L=Path_L(t,1);
    in_y_end_L=Path_L(t,2);
    in_z_end_L=Path_L(t,3);
   
    in_alpha_R=60*(pi/180);
    in_beta_R=0*(t/DEF_DESCRETE_POINT)*(pi/180);
    in_gamma_R=0*(t/DEF_DESCRETE_POINT)*(pi/180);
    
    in_alpha_L=-60*(pi/180);
    in_beta_L=0*(t/DEF_DESCRETE_POINT)*(pi/180);
    in_gamma_L=0*(t/DEF_DESCRETE_POINT)*(pi/180);

    Rednt_alpha_R=-90*(pi/180);
    Rednt_alpha_L=90*(pi/180);

    %���I��min==>IK==>theta==>FK==>���I��mout
    %inverse kinematic
    y_base_R=-L0;%header0 �y�Шt������shoulder0 �y�Шt �tY��V��L0
    theta_R=IK_7DOF_FullBend(L0,L1,L2,L3,L4,L5,x_base_R,y_base_R,z_base_R,in_x_end_R,in_y_end_R,in_z_end_R,in_alpha_R,in_beta_R,in_gamma_R,Rednt_alpha_R);
  	y_base_L=L0;%header0 �y�Шt������shoulder0 �y�Шt �tY��V��L0
    theta_L=IK_7DOF_FullBend(L0,L1,L2,L3,L4,L5,x_base_L,y_base_L,z_base_L,in_x_end_L,in_y_end_L,in_z_end_L,in_alpha_L,in_beta_L,in_gamma_L,Rednt_alpha_L);
    theta_L(3)=-theta_R(3); %����M�k�⪺��3�b�ݭn�ϦV
     
     
    %forward kinematic
    [out_x_end_R,out_y_end_R,out_z_end_R,out_alpha_R,out_beta_R,out_gamma_R,P_R,RotationM_R] = FK_7DOF_FullBend(L0,L1,L2,L3,L4,L5,x_base_R,y_base_R,z_base_R,theta_R);
    [out_x_end_L,out_y_end_L,out_z_end_L,out_alpha_L,out_beta_L,out_gamma_L,P_L,RotationM_L] = FK_7DOF_FullBend(-L0,L1,L2,L3,L4,L5,x_base_L,y_base_L,z_base_L,theta_L);

    %�O�����|�W���I
    PathPoint_R(t,1:3)=[out_x_end_R out_y_end_R out_z_end_R];
    PathPoint_L(t,1:3)=[out_x_end_L out_y_end_L out_z_end_L];
    
    %�e���`�I��
    Draw_7DOF_FullBend_dual_point(P_R,RotationM_R,PathPoint_R,P_L,RotationM_L,PathPoint_L);
   
    %�O���C�b�����ܤ�
    PathTheta_R(t,1:7)=theta_R*(180/pi);
    PathTheta_L(t,1:7)=theta_L*(180/pi);
    
    In_R=[in_x_end_R in_y_end_R in_z_end_R in_alpha_R in_beta_R in_gamma_R]
    Out_R=[out_x_end_R out_y_end_R out_z_end_R out_alpha_R out_beta_R out_gamma_R]
    
    In_L=[in_x_end_L in_y_end_L in_z_end_L in_alpha_L in_beta_L in_gamma_L]
    Out_L=[out_x_end_L out_y_end_L out_z_end_L out_alpha_L out_beta_L out_gamma_L]
   
    pause(0.1);
end
