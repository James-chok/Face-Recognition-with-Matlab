k = 70;
randarray = load('randarray.mat');
randarray = randarray.randarray;

imagearray1 = zeros(112,92,7,40);

for i = 1:40;
    for j = 1:7;
        temp = imread(['att_faces/s', num2str(i), '/', num2str(randarray(i,j)), '.pgm']);
        imagearray1(:,:,j,i) = temp;
    end
end

imagearray2 = zeros(112,92,40);
for i = 1:40;
    temp = zeros(112,92);
    for j = 1:7;
        temp = temp + imagearray1(:,:,j,i);
    end
    temp = temp ./ 7;
    imagearray2(:,:,i) = temp;
end

temp = zeros(112,92);
for i = 1:40
    temp = temp + imagearray2(:,:,i);
end
x = temp ./ 40;

imagearray3 = zeros(112*92,40);
for i = 1:40
    imagearray2(:,:,i) = imagearray2(:,:,i) - x;
    imagearray3(:,i) = reshape(imagearray2(:,:,i),112*92,1);
end

C = imagearray3 * imagearray3' ./ 39;

[V,A] = eig(C);
A = diag(A);
[A,I] = sort(A,'descend');
V = V(:,I(1:k));
V = V';

a = zeros(k,40);
temp = zeros(112*92,1);
for i = 1:40
    temp(:,1) = imagearray3(:,i);
    a(:,i) = V * temp;
end

right = 0;
for i = 1:40
    for j = 8:10
        image = double(imread(['att_faces/s', num2str(i), '/', num2str(randarray(i,j)), '.pgm']));
        imagetemp = image;
        image = image - x;
        image = reshape(image,112*92,1);
        z = V * image;
        s = euclid(a, z, k);
        if (s == i)
            right = right + 1;
        end
        imagetemp = uint8(imagetemp);
        imwrite(imagetemp, ['result/s', num2str(s), '/', num2str(randarray(i,j)), '.pgm']);
    end
end

P = right / 120 * 100;
P