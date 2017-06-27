%L1 �W�uL������
%L2 �W�uL���u��
%L3 �W�uL���u��
%L4 �W�uL������
%L5 end effector

function theta = IK_7DOF_FullBend( L0,L1,L2,L3,L4,L5,x_base,y_base,z_base,x_end,y_end,z_end,alpha,beta,gamma,Rednt_alpha)

    %��X�Ѽ�
    theta=zeros(1,7);

    %�D�XH_hat_x
    %R=R_z1x2z3(alpha,beta,gamma);
    R=R_z1x2y3(alpha,beta,gamma);
    V_H_hat_x=R(1:3,1);%���X�کԨ��ഫ������x�}�A���X��1�欰X�b�����V�q
    V_H_hat_x=V_H_hat_x/norm(V_H_hat_x);
    V_H_hat_y=R(1:3,2);%���X�کԨ��ഫ������x�}�A���X��2�欰Y�b�����V�q

    %V_H_hat_y=V_H_hat_y/norm(V_H_hat_y);
    V_r_end=[x_end-x_base;
             y_end-y_base;
             z_end-z_base];
    V_r_h=L5*V_H_hat_x;
    V_r_wst=V_r_end-V_r_h;

       %% ==Axis4== %%
    ru_norm=(L1^2+L2^2)^0.5; %L�����������
    rf_norm=(L3^2+L4^2)^0.5;

    theta_tmp=acos((ru_norm^2 + rf_norm^2- norm(V_r_wst)^2) / (2*ru_norm*rf_norm));
    theta(4)=2*pi-atan2(L1,L2)-atan2(L4,L3)-theta_tmp;

    V_r_m=(ru_norm^2-rf_norm^2+norm(V_r_wst)^2)/(2*norm(V_r_wst)^2)*V_r_wst;

    %Redundant circle �b�|R
    Rednt_cir_R=ru_norm^2-((ru_norm^2-rf_norm^2+norm(V_r_wst)^2)/(2*norm(V_r_wst)))^2;
    Rednt_cir_R=Rednt_cir_R^0.5;

    %�ꤤ���I��Elbow�V�q V_r_u
    V_shx=[1;0;0];
    V_shy=[0;1;0];
    V_shz=[0;0;1];

    V_alpha_hat=cross(V_r_wst,V_shz)/norm(cross(V_r_wst,V_shz));
    V_beta_hat=cross(V_r_wst,V_alpha_hat)/norm(cross(V_r_wst,V_alpha_hat));

    temp=Rogridues(Rednt_alpha,V_r_wst/norm(V_r_wst))*[Rednt_cir_R*V_beta_hat;1];  %Rednt_alpha����V�M�פ�W����V�ʬۤ�
    V_R_u=temp(1:3,1);
    V_r_u=V_r_m+V_R_u;

    %���� V_r_u  ��V_ru_l1
    V_r_f=V_r_wst-V_r_u;
    Vn_u_f=cross(V_r_u,V_r_f)/norm(cross(V_r_u,V_r_f)); %ru �� rf���k�V�q
    theat_upoff=atan(L2/L1);
    temp=Rogridues(-theat_upoff,Vn_u_f)*[V_r_u;1];  %���� V_r_u  ��V_ru_l1
    V_ru_l1=temp(1:3,1);
    V_ru_l1=V_ru_l1*L1/norm(V_ru_l1); %�վ㦨L1����
    
    if imag(V_ru_l1(1)) ~= 0 || imag(V_ru_l1(3)) ~=0
        qq=1;
    end
    theta(1)=atan2(V_ru_l1(1),-V_ru_l1(3));%org
  

    if theta(1) ~= 0
        theta(2)=atan2(-V_ru_l1(2),V_ru_l1(1)/sin(theta(1)));
    else
        theta(2)=atan2(V_ru_l1(2),-V_ru_l1(3));    
    end   
    
       %% ==Axis3== %%
    %��shy(V_r_u,V_r_f���k�V�q)�g�L1,2�b�����  �PV_r_u,V_r_f �ݭn��3�b��h��
    V_n_yrot12=Ry(-theta(1))*Rx(-theta(2))*[-V_shy;1];  %��V�w�q�����Y �]���|�ttheta1 theta2�h�t��
    V_n_yrot12=V_n_yrot12(1:3,1);
    
    Vn_nuf_nyrot12=cross(Vn_u_f,V_n_yrot12);
    Vn_nuf_nyrot12=Vn_nuf_nyrot12/norm(Vn_nuf_nyrot12);
    
    temp=V_n_yrot12'*Vn_u_f/norm(V_n_yrot12)/norm(Vn_u_f); 

    %Vn_u_f �M V_n_yrot12���k�V�q   �P V_ru_l1�P��V theta(3)�ݭn�[�t��
    if norm(Vn_nuf_nyrot12 - V_ru_l1/norm(V_ru_l1)) < 1.e-7
        theta(3)=-acos(temp);
    else
        theta(3)=acos(temp);
    end
    

       %% ==Axis5==  %%
    theta(5)=0;

       %% ==Axis6== %%
    V_wst_to_end=V_r_end-V_r_wst;

    %����V_r_f �� V_rf_l4
    theat_lowoff=atan(L3/L4);
    temp=Rogridues(theat_lowoff,Vn_u_f)*[V_r_f;1];  %���� V_r_f  V_rf_l4
    V_rf_l4=temp(1:3,1);
    V_rf_l4=V_rf_l4*L4/norm(V_rf_l4); %�վ㦨L4����

    %V_n_rfl4 ��V_n_rf�Φ������� ���k�V�q
    Vn_rfl4_nuf=cross(V_rf_l4,Vn_u_f)/norm(cross(V_rf_l4,Vn_u_f));
    t_rfl4_nuf=(Vn_rfl4_nuf'*V_r_wst-Vn_rfl4_nuf'*V_r_end)/(norm(Vn_rfl4_nuf)^2); %V_n_rf,V_n_rfl4�����W�A�B�g�LV_r_end�I�����u�ѼƦ���t ��rfl4_nuf
    Vproj_end_rfl4_nuf=V_r_end+t_rfl4_nuf*Vn_rfl4_nuf;%V_r_end �u��V_n_rfl4,V_n_rf�����k�V�q��v�b�����W���I
    V_wst_to_projend_rfl4_nuf=Vproj_end_rfl4_nuf-V_r_wst;

    %����bacos(1.000000.....)���ɭԷ|�X�{�곡�����p
    temp=V_rf_l4'*V_wst_to_projend_rfl4_nuf/norm(V_rf_l4)/norm(V_wst_to_projend_rfl4_nuf);
    if abs(temp-1)<1.e-7 
       if temp >0
           temp=1;
       else
           temp=-1;
       end
    end

    %�����k�V�q �M Vn_rfl4_nuf  �P��n�[�t��  �P�_theta6�n���W�Ω��U��
    Vn_rfl4_WstToProjEndRfl4Nuf=cross(V_rf_l4/norm(V_rf_l4),V_wst_to_projend_rfl4_nuf/norm(V_wst_to_projend_rfl4_nuf));
    Vn_rfl4_WstToProjEndRfl4Nuf=Vn_rfl4_WstToProjEndRfl4Nuf/norm(Vn_rfl4_WstToProjEndRfl4Nuf);
    if norm(Vn_rfl4_WstToProjEndRfl4Nuf - Vn_rfl4_nuf) < 1.e-7
        theta(6)=-acos(temp); 
    else
        theta(6)=acos(temp); 
    end
    
        %% ==Axis7==  %%
    temp=Rogridues(-theta(6),Vn_rfl4_nuf)*[Vn_u_f;1]; 
    Vn_nuf_rotx6_along_NRfl4Nuf=temp(1:3,1);%nuf �u�� Vn_rfl4_nuf �����6�b���ױo���v�I�P�ؼ��I�������k�V�q
    Vn_nuf_rotx6_along_NRfl4Nuf=Vn_nuf_rotx6_along_NRfl4Nuf/norm(Vn_nuf_rotx6_along_NRfl4Nuf);
    Vn_WstToEnd_WstToProjEndRfl4Nuf=cross(V_wst_to_end,V_wst_to_projend_rfl4_nuf);%V_wst_to_projend �M V_wst_to_end���k�V�q
    Vn_WstToEnd_WstToProjEndRfl4Nuf=Vn_WstToEnd_WstToProjEndRfl4Nuf/norm(Vn_WstToEnd_WstToProjEndRfl4Nuf);

    %�Q�Ϊk�V�q��V �P�_theta7�����V
    temp=V_wst_to_projend_rfl4_nuf'*V_wst_to_end/norm(V_wst_to_projend_rfl4_nuf)/norm(V_wst_to_end);
    if norm(Vn_WstToEnd_WstToProjEndRfl4Nuf - Vn_nuf_rotx6_along_NRfl4Nuf) < 1.e-7
        theta(7)=-acos(temp); 
    else
        theta(7)=acos(temp); 
    end
end
