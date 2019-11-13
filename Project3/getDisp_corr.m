function disp_corr = getDisp_corr(ImageA,ImageB)

[corrA,corrB] = getCorr_clean(ImageA,ImageB);
disp_corr = corrA - corrB;