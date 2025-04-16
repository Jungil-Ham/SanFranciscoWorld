function R = createRotationMatrix(A)
    % 벡터 A를 정규화
    A = A / norm(A);

    % 벡터 A와 직교하는 벡터 B 생성
    if A(1) == 0
        B = cross([1, 0, 0], A);
    else
        B = cross([0, 1, 0], A);
    end
    B = B / norm(B);

    % 벡터 A와 B에 모두 직교하는 벡터 C 생성
    C = cross(A, B);
    C = C / norm(C);

    % 회전 행렬 R 생성
    R = [A B.' C.'];
end