function s = euclid(a, z, k)
az = a(:,1) - z;
min = 0;
for j = 1:k
    min = min + az(j,1)^2;
end
s = 1;
for i = 2:40
    az = a(:,i) - z;
    temp = 0;
    for j = 1:k
        temp = temp + az(j,1)^2;
    end
    if (temp < min)
        s = i;
        min = temp;
    end
end