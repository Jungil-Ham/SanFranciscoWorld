function [RMD] = calRMD_unit(R_gc_esti, R_gc_true)


RgcTrue = R_gc_true;
RgcEsti = R_gc_esti;
rotationMatrixDifference = acos((trace(RgcTrue.' * RgcEsti)-1)/2) * (180/pi);

% return error metric
rotationMatrixDifference = real(rotationMatrixDifference);
RMD = rotationMatrixDifference;

end