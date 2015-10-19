TMP(1:256,1:1024) = 0;
FFTImage = TMP;
FFTOffset = 1500;
FFTSize = 1024;
f_Echantillonage=125E6;

T=1/f_Echantillonage;
sampling = 16;
    
    
for g=1:256

    L = X(g,:)
    Ltilde = L(end:-1:1);
    LL = cat(2,L,Ltilde);
    
    l=length(LL);
    duree = l/f_Echantillonage;
    size=l/(2*sampling);

    t=T*(0:l-1);
    NFFT = l; %cas non precis mais marche bien ici
    Yfft=real(fft(LL,NFFT));
    f=f_Echantillonage/2*linspace(0,1,NFFT/2);
    # yInverse=ifft(Yfft);
    YfftModif=Yfft;

    for j=1:l
        if(j>(FFTOffset+0) && j<=(FFTOffset+FFTSize))
            YfftModif(j)=YfftModif(j);
        else
            YfftModif(j)=0;
        end
    end
   
    
    
    yInverseModif=ifft(YfftModif);
    yInverseModif=real(yInverseModif(1:l/2)).^2;

    total = YfftModif(1:size);
    for j=1:size
        total(j)=0;
        for k=1:sampling
          total(j) = total(j)+ yInverseModif((j-1)*sampling+(k-1)+1);
        end
        
    end
    
    for j=1:FFTSize
        FFTImage(g,j) = YfftModif(FFTOffset+j);
    end
    
    TMP(g,:) = total(:);
    
end

TMP = 255*TMP/(max(max(TMP)));
