TMP(1:256,1:1024) = 0;

for g=1:256

    L = X(g,:)
    Ltilde = L(end:-1:1);
    LL = cat(2,L,Ltilde);
    f_Echantillonage=125E6;
    l=length(LL);
    duree = l/f_Echantillonage;
    T=1/f_Echantillonage;
    sampling = 16;
    size=l/(2*sampling);

    t=T*(0:l-1);
    NFFT = l; %cas non precis mais marche bien ici
    Yfft=real(fft(LL,NFFT));
    f=f_Echantillonage/2*linspace(0,1,NFFT/2);
    yInverse=ifft(Yfft);
    YfftModif=Yfft;

    for j=1:l
        if(j<3200 && j>1000)
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

    TMP(g,:) = total(:);
    fprintf('%i\n', g)
end
    
