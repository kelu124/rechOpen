TotalArray=zeros(256*4,256+7);


GroNombre=(max(max(abs(FFTImageInt))))
ttt = floor(16*1024*FFTImageInt/GroNombre);

for i=1:256
  for j=1:4
      TotalArray((4*i)-3+j,1) = j-1;
      TotalArray((4*i)-3+j,2) = 1000+256*(j-1);
      TotalArray((4*i)-3+j,3) = 1000+256*(j);
      TotalArray((4*i)-3+j,5) = i;
    for k=1:256

      TotalArray((4*i)-3+j,7+k) = ttt(i,(j-1)*k+k);
    end
  end
end


