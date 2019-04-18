function I=pdwt(img)
redRegion=img(:,:,1);
greenRegion=img(:,:,2);
blueRegion=img(:,:,3);
[llr,lhr,hlr,hhr]=dwt2(redRegion,'haar');
[llg,lhg,hlg,hhg]=dwt2(greenRegion,'haar');
[llb,lhb,hlb,hhb]=dwt2(blueRegion,'haar');
firstDecomposition(:,:,1)=[llr,lhr;hlr,hhr];
firstDecomposition(:,:,2)=[llg,lhg;hlg,hhg];
firstDecomposition(:,:,3)=[llb,lhb;hlb,hhb];
firstDecomposition=uint8(firstDecomposition);
I=firstDecomposition;
end