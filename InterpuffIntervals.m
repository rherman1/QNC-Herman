%%Create graphs of active and vehicle IPI

T = readtable('IPI data Matlab.csv');   %Import active interpuff interval data from csv file
T.WHEEL = categorical(T.WHEEL);     %change data type

ActiveIPI = T(T.WHEEL == 'A',:);    %select Active IPI
ActIPI = table2array(ActiveIPI(:,1:3));     %turn into array

    ActNic = ActIPI(:,1);     %separate into variables and change to vector
    ActCombo = ActIPI(:,2);
    ActStrb = ActIPI(:,3);

    pdNic = fitdist(ActNic,'Exponential');% fit exponential distribution to each active curve
    pdCombo = fitdist(ActCombo, 'Exponential');
    pdStrb = fitdist(ActStrb, 'Exponential');
    
    ExpNic = random(pdNic,10000,1); %create data based on this exponential distribution
    ExpCombo = random(pdCombo, 10000,1);
    ExpStrb = random(pdStrb, 10000,1);

figure(1);
    subplot(1,2,1); %create violin plot of data
        distributionPlot(ActIPI, 'color', {[.8 .8 .8],'r','m'}, 'distwidth', 0.8,'xNames',{'Nic','Combo','Strawb'});
        set(gca, 'YScale', 'log');
        plotSpread(ActIPI, 'spreadwidth', .5, 'distributioncolors', 'k');
        title('Active IPI Distributions');
        ylabel('log (IPI (Minutes))');

    subplot(1,2,2); % Make empirical cumulative distribution plots of all active
        h(1) = cdfplot(ActNic);
        hold on
        h(2) = cdfplot(ActCombo);
        h(3) = cdfplot(ActStrb);
        set (h(1), 'color', [.1 .1 .1]);
        set (h(2), 'color', 'r');
        set (h(3), 'color', 'm');
        legend('Nic','Combo','Strawb');
        ylabel('Cumulative Probability');
        xlabel('IPI (Minutes)');
        title('CDF of Active IPIs');

figure(2); %Make cumulative distribution plots for each distribution compared to model exponential
    subplot(1,3,1);
        h(1) = cdfplot(ActNic); 
        hold on
        h(2) = cdfplot(ExpNic);
        set (h(1), 'color', [.5 .5 .5]);
        set (h(2), 'color', 'k');
        title('Active Nicotine');
        xlabel('IPI (Minutes)');
        ylabel('Cumulative Probability');

    subplot(1,3,2);
        h(3) = cdfplot(ActCombo);
        hold on
        h(4) = cdfplot(ExpCombo);
        set (h(3), 'color', 'r');
        set (h(4), 'color', 'k');
        title('Active Combo');
        xlabel('IPI (Minutes)');
        ylabel([]);

    subplot(1,3,3);
        h(5) = cdfplot(ActStrb);
        hold on
        h(6) = cdfplot(ExpStrb);
        set (h(5), 'color', 'm');
        set (h(6), 'color', 'k');
        title ('Active Strawb');
        xlabel('IPI (Minutes)');
        ylabel([]);


figure (3); %Show each group as a normalized histogram with line for fitted exp. distribution
    subplot(1,3,1); %for ActNic
        a=histogram(ActNic,'Normalization','pdf','FaceAlpha',.3,'FaceColor','k');
        hold on
        b=histogram(ExpNic,'Normalization','pdf','DisplayStyle','stairs','EdgeColor','k');
        uistack(b,'top');
        title('Active Nicotine');
        xlabel('IPI (Minutes)');
        ylabel('Relative Frequency');

    subplot(1,3,2); %forActCombo
        a=histogram(ActCombo,'Normalization','pdf','FaceAlpha',.3,'FaceColor','r');
        hold on
        b=histogram(ExpCombo,'Normalization','pdf','DisplayStyle','stairs','EdgeColor','k');
        uistack(b,'top');
        title('Active Combo');
        xlabel('IPI (Minutes)');
        ylabel([]);



    subplot(1,3,3); %forActStrb
        a=histogram(ActStrb,'Normalization','pdf','FaceAlpha',.3,'FaceColor','m');
        hold on
        b=histogram(ExpStrb,'Normalization','pdf','DisplayStyle','stairs','EdgeColor','k');
        uistack(b,'top');
        title('Active Strawberry');
        xlabel('IPI (Minutes)');
        ylabel([]);






% KS Test
    %  null hypothesis = data in vectors are from the same continuous
    %  distribution 
        % result = 1 if null hypothesis is rejected (they are from different dist) at 5% sig.
    % Alternative hypothesis = data are from different dist.
    
[hNicVCombo,pNicVCombo] = kstest2(ActNic,ActCombo,'Alpha',(0.05/3)); %ks-test for p value 0.05/3 (Bonferroni correction for 3 tests)
[hNicVStrb,pNicVStrb] = kstest2(ActNic, ActStrb,'Alpha',(0.05/3));
[hComboVStrb,pComboVStrb] = kstest2(ActCombo, ActStrb,'Alpha',(0.05/3));
    LogicalStr = {'false', 'true'};

fprintf('\nDoes KS test reject the null hypothesis & find that samples are from different distributions?')
fprintf('\nActNic and ActCombo: %s , p = %f',LogicalStr{hNicVCombo+1},(pNicVCombo*3)); %print results of ks test for comparing experimental distributions with p value including Bonferroni correction 
fprintf('\nActNic and ActStrb: %s, p = %f',LogicalStr{hNicVStrb+1},(pNicVStrb*3));
fprintf('\nActCombo and ActStrb: %s, p = %f',LogicalStr{hComboVStrb+1},(pComboVStrb*3));


[hNicVExp,pNicVExp] = kstest2(ActNic,ExpNic);
[hComboVExp,pComboVExp] = kstest2(ActCombo, ExpCombo);
[hStrbVExp,pStrbVExp] = kstest2(ActStrb, ExpStrb); 


fprintf('\n\nActNic and ExpNic: %s , p = %f',LogicalStr{hNicVExp+1},(pNicVExp)); %print results for comparing each dist. to its corresponding model exponential distribution
fprintf('\nActCombo and ExpCombo: %s , p = %f',LogicalStr{hComboVExp+1},(pComboVExp));
fprintf('\nActStrb and ExpStrb: %s , p = %f',LogicalStr{hStrbVExp+1},(pStrbVExp));




%% Repeat steps for Vehicle

VehicleIPI = T(T.WHEEL == 'V',:); % Repeat with vehicle IPI
VehIPI = table2array(VehicleIPI(:,1:3));
VehNic = VehIPI(:,1); %separate into variables and change to vector
VehCombo = VehIPI(:,2);
VehStrb = VehIPI(:,3);


    pdVehNic = fitdist(VehNic,'Exponential');% fit exponential distribution to each veh curve
    pdVehCombo = fitdist(VehCombo, 'Exponential');
    pdVehStrb = fitdist(VehStrb, 'Exponential');
    
    ExpVehNic = random(pdVehNic,10000,1);
    ExpVehCombo = random(pdVehCombo, 10000,1);
    ExpVehStrb = random(pdVehStrb, 10000,1);
    
figure(4);
    subplot(1,2,1); %create violin plot of data
        distributionPlot(VehIPI, 'color', {[.8 .8 .8],'r','m'}, 'distwidth', 0.8,'xNames',{'Nic','Combo','Strawb'});
        set(gca, 'YScale', 'log');
        plotSpread(VehIPI, 'spreadwidth', .5, 'distributioncolors', 'k');
        title('Vehicle IPI Distributions');
        ylabel('log (IPI (Minutes))');

    subplot(1,2,2); % Make cumulative distribution plots of all vehicle IPIs
        h(1) = cdfplot(VehNic);
        hold on
        h(2) = cdfplot(VehCombo);
        h(3) =cdfplot(VehStrb);
        set (h(1), 'color', [.1 .1 .1]);
        set (h(2), 'color', 'r');
        set (h(3), 'color', 'm');
        legend('Nic','Combo','Strawb');
        ylabel('Cumulative Probability');
        xlabel('IPI (Minutes)');
        title('CDF of Vehicle IPIs');

figure(5); %Make empirical cumulative distribution plots for each distribution compared to model exponential
    subplot(1,3,1);
        h(1) = cdfplot(VehNic); 
        hold on
        h(2) = cdfplot(ExpVehNic);
        set (h(1), 'color', [.5 .5 .5]);
        set (h(2), 'color', 'k');
        title('Vehicle Nicotine');
        xlabel('IPI (Minutes)');
        ylabel('Cumulative Probability');

    subplot(1,3,2);
        h(3) = cdfplot(VehCombo);
        hold on
        h(4) = cdfplot(ExpVehCombo);
        set (h(3), 'color', 'r');
        set (h(4), 'color', 'k');
        title('Vehicle Combo');
        xlabel('IPI (Minutes)');
        ylabel([]);

    subplot(1,3,3);
        h(5) = cdfplot(VehStrb);
        hold on
        h(6) = cdfplot(ExpVehStrb);
        set (h(5), 'color', 'm');
        set (h(6), 'color', 'k');
        title ('Vehicle Strawb');
        xlabel('IPI (Minutes)');
        ylabel([]);

figure (6); %Show each group as a normalized histogram with line for fitted exp. distribution
    subplot(1,3,1); %for VehNic
        a=histogram(VehNic,'Normalization','pdf','FaceAlpha',.3,'FaceColor','k');
        hold on
        b=histogram(ExpVehNic,'Normalization','pdf','DisplayStyle','stairs','EdgeColor','k');
        uistack(b,'top');
        title('Vehicle Nicotine');
        xlabel('IPI (Minutes)');
        ylabel('Relative Frequency');

    subplot(1,3,2); %for VehCombo
        a=histogram(VehCombo,'Normalization','pdf','FaceAlpha',.3,'FaceColor','r');
        hold on
        b=histogram(ExpVehCombo,'Normalization','pdf','DisplayStyle','stairs','EdgeColor','k');
        uistack(b,'top');
        title('Vehicle Combo');
        xlabel('IPI (Minutes)');
        ylabel([]);


    subplot(1,3,3); %for VehStrb
        a=histogram(VehStrb,'Normalization','pdf','FaceAlpha',.3,'FaceColor','m');
        hold on
        b=histogram(ExpVehStrb,'Normalization','pdf','DisplayStyle','stairs','EdgeColor','k');
        uistack(b,'top');
        title('Vehicle Strawberry');
        xlabel('IPI (Minutes)');
        ylabel([]);






% KS Test
    %  null hypothesis = data in vectors are from the same continuous
    %  distribution 
        % result = 1 if null hypothesis is rejected (they are from different dist) at 5% sig.
    % Alternative hypothesis = data are from different dist.
    
[hVehNicVVehCombo,pVehNicVVehCombo] = kstest2(VehNic,VehCombo,'Alpha',(0.05/3)); %ks-test for p value 0.05/3 (Bonferroni correction for 3 tests)
[hVehNicVVehStrb,pVehNicVVehStrb] = kstest2(VehNic, VehStrb,'Alpha',(0.05/3)); %compare treatments to each other
[hVehComboVVehStrb,pVehComboVVehStrb] = kstest2(VehCombo, VehStrb,'Alpha',(0.05/3));
    LogicalStr = {'false', 'true'};

fprintf('\n\nDoes KS test reject the null hypothesis & find that samples are from different distributions?')
fprintf('\nVehNic and VehCombo: %s , p = %f',LogicalStr{hVehNicVVehCombo+1},(pVehNicVVehCombo*3)); %print results of ks test for comparing experimental distributions with p value including Bonferroni correction 
fprintf('\nVehNic and VehStrb: %s, p = %f',LogicalStr{hVehNicVVehStrb+1},(pVehNicVVehStrb*3));
fprintf('\nVehCombo and VehStrb: %s, p = %f',LogicalStr{hVehComboVVehStrb+1},(pVehComboVVehStrb*3));


[hVehNicVVehExp,pVehNicVVehExp] = kstest2(VehNic,ExpVehNic);
[hVehComboVVehExp,pVehComboVVehExp] = kstest2(VehCombo, ExpVehCombo);
[hVehStrbVVehExp,pVehStrbVVehExp] = kstest2(VehStrb, ExpVehStrb); 


fprintf('\n\nVehNic and ExpVehNic: %s , p = %f',LogicalStr{hVehNicVVehExp+1},(pVehNicVVehExp)); %print results for comparing each dist. to its corresponding model exponential distribution
fprintf('\nVehCombo and ExpVehCombo: %s , p = %f',LogicalStr{hVehComboVVehExp+1},(pVehComboVVehExp));
fprintf('\nVehStrb and ExpVehStrb: %s , p = %f',LogicalStr{hVehStrbVVehExp+1},(pVehStrbVVehExp));

%% Repeat for total IPI
TotIPI = table2array(T(:,1:3));     %turn into array

    TotNic = TotIPI(:,1);     %separate into variables and change to vector
    TotCombo = TotIPI(:,2);
    TotStrb = TotIPI(:,3);

    pdTotNic = fitdist(TotNic,'Exponential');% fit exponential distribution to each total curve
    pdTotCombo = fitdist(TotCombo, 'Exponential');
    pdTotStrb = fitdist(TotStrb, 'Exponential');
    
    ExpTotNic = random(pdTotNic,10000,1); %create data based on this exponential distribution
    ExpTotCombo = random(pdTotCombo, 10000,1);
    ExpTotStrb = random(pdTotStrb, 10000,1);

figure(7);
    subplot(1,2,1); %create violin plot of data
        distributionPlot(TotIPI, 'color', {[.8 .8 .8],'r','m'}, 'distwidth', 0.8,'xNames',{'Nic','Combo','Strawb'});
        set(gca, 'YScale', 'log');
        plotSpread(ActIPI, 'spreadwidth', .5, 'distributioncolors', 'k');
        title('Total IPI Distributions');
        ylabel('log (IPI (Minutes))');

    subplot(1,2,2); % Make empirical cumulative distribution plots of all Total
        h(1) = cdfplot(TotNic);
        hold on
        h(2) = cdfplot(TotCombo);
        h(3) = cdfplot(TotStrb);
        set (h(1), 'color', [.1 .1 .1]);
        set (h(2), 'color', 'r');
        set (h(3), 'color', 'm');
        legend('Nic','Combo','Strawb');
        ylabel('Cumulative Probability');
        xlabel('IPI (Minutes)');
        title('CDF of Total IPIs');

figure(8); %Make cumulative distribution plots for each distribution compared to model exponential
    subplot(1,3,1);
        h(1) = cdfplot(TotNic); 
        hold on
        h(2) = cdfplot(ExpTotNic);
        set (h(1), 'color', [.5 .5 .5]);
        set (h(2), 'color', 'k');
        title('Total Nicotine');
        xlabel('IPI (Minutes)');
        ylabel('Cumulative Probability');

    subplot(1,3,2);
        h(3) = cdfplot(TotCombo);
        hold on
        h(4) = cdfplot(ExpTotCombo);
        set (h(3), 'color', 'r');
        set (h(4), 'color', 'k');
        title('Total Combo');
        xlabel('IPI (Minutes)');
        ylabel([]);

    subplot(1,3,3);
        h(5) = cdfplot(TotStrb);
        hold on
        h(6) = cdfplot(ExpTotStrb);
        set (h(5), 'color', 'm');
        set (h(6), 'color', 'k');
        title ('Total Strawb');
        xlabel('IPI (Minutes)');
        ylabel([]);

figure (9); %Show each group as a normalized histogram with line for fitted exp. distribution
    subplot(1,3,1); %for TotNic
        a=histogram(TotNic,'Normalization','pdf','FaceAlpha',.3,'FaceColor','k');
        hold on
        b=histogram(ExpTotNic,'Normalization','pdf','DisplayStyle','stairs','EdgeColor','k');
        uistack(b,'top');
        title('Total Nicotine');
        xlabel('IPI (Minutes)');
        ylabel('Relative Frequency');

    subplot(1,3,2); %for TotCombo
        a=histogram(TotCombo,'Normalization','pdf','FaceAlpha',.3,'FaceColor','r');
        hold on
        b=histogram(ExpTotCombo,'Normalization','pdf','DisplayStyle','stairs','EdgeColor','k');
        uistack(b,'top');
        title('Total Combo');
        xlabel('IPI (Minutes)');
        ylabel([]);


    subplot(1,3,3); %for TotStrb
        a=histogram(TotStrb,'Normalization','pdf','FaceAlpha',.3,'FaceColor','m');
        hold on
        b=histogram(ExpTotStrb,'Normalization','pdf','DisplayStyle','stairs','EdgeColor','k');
        uistack(b,'top');
        title('Total Strawberry');
        xlabel('IPI (Minutes)');
        ylabel([]);






% KS Test
    %  null hypothesis = data in vectors are from the same continuous
    %  distribution 
        % result = 1 if null hypothesis is rejected (they are from different dist) at 5% sig.
    % Alternative hypothesis = data are from different dist.
    
[hTotNicVTotCombo,pTotNicVTotCombo] = kstest2(TotNic,TotCombo,'Alpha',(0.05/3)); %ks-test for p value 0.05/3 (Bonferroni correction for 3 tests)
[hTotNicVTotStrb,pTotNicVTotStrb] = kstest2(TotNic, TotStrb,'Alpha',(0.05/3));
[hTotComboVTotStrb,pTotComboVTotStrb] = kstest2(TotCombo, TotStrb,'Alpha',(0.05/3));
    LogicalStr = {'false', 'true'};

fprintf('\n\nDoes KS test reject the null hypothesis & find that samples are from different distributions?')
fprintf('\nTotNic and TotCombo: %s , p = %f',LogicalStr{hTotNicVTotCombo+1},(pTotNicVTotCombo*3)); %print results of ks test for comparing experimental distributions with p value including Bonferroni correction 
fprintf('\nTotNic and TotStrb: %s, p = %f',LogicalStr{hTotNicVTotStrb+1},(pTotNicVTotStrb*3));
fprintf('\nTotCombo and TotStrb: %s, p = %f',LogicalStr{hTotComboVTotStrb+1},(pTotComboVTotStrb*3));


[hTotNicVTotExp,pTotNicVTotExp] = kstest2(TotNic,ExpTotNic);
[hTotComboVTotExp,pTotComboVTotExp] = kstest2(TotCombo, ExpTotCombo);
[hTotStrbVTotExp,pTotStrbVTotExp] = kstest2(TotStrb, ExpTotStrb); 


fprintf('\n\nTotNic and ExpTotNic: %s , p = %f',LogicalStr{hTotNicVTotExp+1},(pTotNicVTotExp)); %print results for comparing each dist. to its corresponding model exponential distribution
fprintf('\nTotCombo and ExpTotCombo: %s , p = %f',LogicalStr{hTotComboVTotExp+1},(pTotComboVTotExp));
fprintf('\nTotStrb and ExpTotStrb: %s , p = %f',LogicalStr{hTotStrbVTotExp+1},(pTotStrbVTotExp));
