%15_1 (move 2 stairs)
%Rot1 = R_gc_true(:,:,6);
%Rot2 = R_gc_true(:,:,803);

%15_3 (move 6 stairs)
%Rot1 = R_gc_true(:,:,2);
%Rot2 = R_gc_true(:,:,420);
%Rot3 = R_gc_true(:,:,824);
%Rot4 = R_gc_true(:,:,1213);
%Rot5 = R_gc_true(:,:,1482);
%Rot6 = R_gc_true(:,:,1980);

%15_2 (In place)
%Rot1 = R_gc_true(:,:,52);
%Rot2 = R_gc_true(:,:,740);
%Rot3 = R_gc_true(:,:,1674);
%Rot4 = R_gc_true(:,:,3161);

%15_4 (move 6 stairs (2))
%Rot1 = R_gc_true(:,:,2);
%Rot2 = R_gc_true(:,:,1073);
%Rot3 = R_gc_true(:,:,1415);

%15_5 (in place (2))
%Rot1 = R_gc_true(:,:,93);
%Rot2 = R_gc_true(:,:,879);
%Rot3 = R_gc_true(:,:,1779);
%Rot4 = R_gc_true(:,:,2571);
%Rot5 = R_gc_true(:,:,3025);

%Rot_2 (in place (3))
Rot1 = R_gc_true(:,:,128);
Rot2 = R_gc_true(:,:,626);
Rot3 = R_gc_true(:,:,1821);
Rot4 = R_gc_true(:,:,2667);
%Rot5 = R_gc_true(:,:,3025);


[RMD] = calRMD_unit(Rot1, Rot2)
[RMD] = calRMD_unit(Rot1, Rot3)
[RMD] = calRMD_unit(Rot1, Rot4)
%[RMD] = calRMD_unit(Rot1, Rot5)
%[RMD] = calRMD_unit(Rot1, Rot6)
