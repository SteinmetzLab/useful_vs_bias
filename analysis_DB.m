%% Usefulness vs. Bias

% Load data
[header,data] = csvreadh(fullfile('C:\proj\useful_vs_bias\useful_vs_bias.csv'));
data = data(1:9,:);

header = header(1:16);
% Split into the three datasets
udata = data(:,1:16);
bdata_back = data(:,17:32);
bdata_pedig = data(:,33:48);

% Z-score each persons data
udataz = (udata - repmat(nanmean(udata,2),1,size(udata,2))) ./ repmat(nanstd(udata,[],2),1,size(udata,2));
bdata_backz = (bdata_back - repmat(nanmean(bdata_back,2),1,size(bdata_back,2))) ./ repmat(nanstd(bdata_back,[],2),1,size(udata,2));
bdata_pedigz = (bdata_pedig - repmat(nanmean(bdata_pedig,2),1,size(bdata_pedig,2))) ./ repmat(nanstd(bdata_pedig,[],2),1,size(udata,2));

dataz = [udataz bdata_backz bdata_pedigz];

% Take the means
udata_ = nanmean(udataz,1);
bdata_back_ = nanmean(bdata_backz,1);
bdata_pedig_ = nanmean(bdata_pedigz,1);

% Compute correlations
stacked_ = [udata_' bdata_back_' bdata_pedig_'];
c = corrcoef(stacked_);

disp(sprintf('Correlation of utility with background bias: %1.2f',c(1,2)));
disp(sprintf('Correlation of utility with pedigree bias: %1.2f',c(1,3)));
disp(sprintf('Correlation of background bias with pedigree bias: %1.2f',c(2,3)));

axis_edge = ceil(max(abs(stacked_(:))));

headerno_ = {};
for hi = 1:length(header)
    headerno_{hi} = strrep(header{hi},'_','');
end
% Make a basic plot
h = figure;
% Plot two plots, one with science vs background, the other plotting
% science vs pedigree
subplot(121);
plot(stacked_(:,1),stacked_(:,2),'o','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',10);
xlabel('Utility to judge science (s.d.)');
ylabel('Bias related to background (s.d.)');
axis equal
axis([-1 1 -1 1]*axis_edge);
title(sprintf('r = %1.2f',c(1,2)));
for ti = 1:length(header)
    text(stacked_(ti,1)+0.1,stacked_(ti,2)+0.1,headerno_{ti});
end

subplot(122);
plot(stacked_(:,1),stacked_(:,3),'o','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',10);
xlabel('Utility to judge science (s.d.)');
ylabel('Bias related to pedigree (s.d.)');
axis equal
axis([-1 1 -1 1]*axis_edge);
title(sprintf('r = %1.2f',c(1,3)));
for ti = 1:length(header)
    text(stacked_(ti,1)+0.1,stacked_(ti,3)+0.1,headerno_{ti});
end

%%
r = corrcoef(dataz');
figure; 
imagesc(r);
colormap gray;
rup = triu(r);
rup = rup(rup>0 & rup~=1);
mean(rup)

%% Standard order
% standard_order = [
% yale_order = [2 3 9 10 14 

%% PCA space
[coeff, score, latent, tsquared, explained] = pca(dataz);


%% Some ideas to consider:
% - is our data consistent across the lab?
% - if you order things the "standard" way, how bad is that?
% - how would you define a new order of elements that would cause less
% bias?
% - is the yale order less biased? How much so? 
% - we used 3 questions because pedigree could have been unrelated to
% background, are there really only two dimensions in the data?