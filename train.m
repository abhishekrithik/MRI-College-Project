function Featr=train(A3)

Ik11=A3;
m=mean(mean(Ik11));
s=std(std(double(Ik11)));
v=var(var(double(Ik11)));
sk=skewness(skewness(double(Ik11)));
k=kurtosis(kurtosis(double(Ik11)));

Stat_Fea=mean(mean([m s v sk k]));
%Shape Feature
Ib1=Ik11;
ss=regionprops(Ib1);
ar=ss.Area;
cent=ss.Centroid;
bb=ss.BoundingBox;
Shape_Fea=mean([ar cent bb]);

Fea=mean([Stat_Fea Shape_Fea]);
Featr=Fea/100;
end