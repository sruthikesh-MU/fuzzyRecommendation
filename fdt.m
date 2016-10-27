function fdt(inFile, mf, op, decTree, w)
% Fuzzy decision trees

in = csvread(inFile);
% Input data has 7 variables
% Car ID, Risk, Value Loss, Horsepower, City MPG, Highway MPG, and Price

% Membership funtions for the input characteristics
% Risk
risk.Low = [-3 -3 -2 0];
risk.Average = [-2 0 2];
risk.High = [0 2 3 3];

% Value Loss
valueLoss.Low = [0 0 100 200];
valueLoss.Average = [100 120 200];
valueLoss.High = [120 200 300 300]; %#ok<*STRNU>

% Horsepower
horsepower.Low = [0 0 60 100];
horsepower.Average = [60 100 140];
horsepower.Low = [100 140 250 250];

% City MPG
cityMPG.Poor = [0 0 20 30];
cityMPG.Average = [20 30 40];
cityMPG.Good = [30 40 60 60];

% Highway MPG
highwayMPG.Poor = [0 0 20 30];
highwayMPG.Average = [20 30 40];
highwayMPG.Good = [30 40 60 60];

% Price
price.Cheap = [0 0 7000 10000];
price.Average = [7000 10000 20000];
price.Expensive = [10000 20000 40000 40000];

% Decision Tree for evaluting the car for the membership function,
% operation and assumed decision tree
assesment = decisionTree(in, decTree, op, w, risk, valueLoss, horsepower, cityMPG, highwayMPG, price);

[bestVal, bestIdx] = max(assesment, [], 1); % Finding the best Car
disp(['Best Car ID is ', num2str(in(bestIdx, 1)), ' and its value is ', num2str(bestVal)]);
close all;

% Plot output car ratings for each car
figure(1);
plot(in(:,1), assesment)
xlabel('Car ID')
ylabel('Car Rating')
title('Car assessment rating based on Fuzzy Decision Tree')

% Histogram plot all the car ratings
[counts, centers]=hist(assesment, 10);  % Histogram of output car ratings
figure(2);
bar(centers, counts)
title('Histogram for car assessment')

end

% Decision Tree for the given input
function assesment = decisionTree(in, decisionTree, opModel, w, risk, valueLoss, horsepower, cityMPG, highwayMPG, price)

% Number of inputs
N = size(in, 1);
assesment = zeros(N,1);

for i=1:N % Loop for all the input data for the decision tree
    if decisionTree==1  % Default decision tree
        assesment(i) = fuzzyOp([
                        fuzzyOp([...
                            fuzzyOp([eval_mf({highwayMPG.Good, in(i,6)}, 'trapmf'), eval_mf({horsepower.Average, in(i,4)}, 'trimf')], 'AND_F', opModel, w),... 
                            fuzzyOp(eval_mf({cityMPG.Poor, in(i,5)}, 'trapmf'), 'NOT_F', opModel, w)],... 
                        'AND_F', opModel, w),... 
                        fuzzyOp([...
                            fuzzyOp([eval_mf({risk.Low, in(i,2)}, 'trapmf'), eval_mf({valueLoss.Low, in(i,3)}, 'trapmf')],'AND_F', opModel, w),... 
                            eval_mf({price.Cheap, in(i,7)}, 'trapmf')],... 
                        'OR_F', opModel, w)],... 
                       'AND_F', opModel, w);
    elseif decisionTree==2
    end
end

end

% Fuzzy operators
function out = fuzzyOp(in, op, model, w)

% Models
% zadeh, Bounded, and Yager

if strcmp(op, 'AND_F')    % Fuzzy intersection or conjuction
    if strcmp(model, 'zadeh')
        out = min(in, [], 2);
    elseif strcmp(model, 'bounded')
        out = max(0, sum(in, 2)-1);
    elseif strcmp(model, 'yager')
        out = 1 - min(1, sum((1-in).^w, 2).^1/w);
    end
elseif strcmp(op, 'OR_F')     % Fuzzy union
    if strcmp(model, 'zadeh') %#ok<*STCMP>
        out = max(in,[], 2);
    elseif strcmp(model, 'bounded')
        out = min(1, sum(in, 2));
    elseif strcmp(model, 'yager')
        out = min(1, sum(in.^w, 2).^1/w);
    end
elseif strcmp(op, 'NOT_F')    % Fuzzy complement
    if strcmp(model, 'zadeh')
        out = 1-in;
    elseif strcmp(model, 'bounded')
        out = 1-in;
    elseif strcmp(model, 'yager')
        out = (1-in.^w).^1/w;
    end
end
    

end


% Membership function
%--------------------------------------
% mf is assumed to be of the form:
%    {[a b c d], val}
%--------------------------------------
function mv = eval_mf(mf, fn)

% 11 membership functions 
% lines: traingular, trapezoidal
% TODO
% Smooth: gaussmf, gauss2mf, gbellmf
% Asymmetric functions: sigmf, dsigmf, psigmf
% Polynomial: zmf, pimf, smf

if strcmp(fn, 'trimf')
    % Triangular
    if mf{2} > mf{1}(3)
        mv = 0;
    elseif mf{2} > mf{1}(2)
        mv = (mf{1}(3) - mf{2}) / (mf{1}(3) - mf{1}(2));  
    elseif mf{2} > mf{1}(1)
        mv = (mf{2} - mf{1}(1)) / (mf{1}(2) - mf{1}(1));
    else 
        mv = 0;
    end
elseif strcmp(fn, 'trapmf')
    % Trapezoid
    if mf{2} > mf{1}(4)
        mv = 0;
    elseif mf{2} > mf{1}(3)
        mv = (mf{1}(4) - mf{2}) / (mf{1}(4) - mf{1}(3));
    elseif mf{2} > mf{1}(2)
        mv = 1;
    elseif mf{2} > mf{1}(1)
        mv = (mf{2} - mf{1}(1)) / (mf{1}(2) - mf{1}(1));
    else 
        mv = 0;
    end   
end
end

