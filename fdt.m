function fdt(inFile, mf, op)
% Fuzzy decision trees

inp = csvread(inFile);
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

end

% Decision Tree for the given input
function assesment = decisionTree(inp, decisionTree, risk, valueLoss, horsepower, cityMPG, highwayMPG, price)

% Number of inputs
N = size(inp, 1);

for i=1:N % Loop for all the input data for the decision tree
    if decisionTree==1
        assesment = fuzzyOp([fuzzyOp([fuzzyOp([], AND_F, 'zadeh'), fuzzyOp(in(i,), )], AND_F, 'zadeh'), ], AND_F, 'zadeh');
    elseif decisionTree=2
    end
end

end

% Fuzzy operators
function out = fuzzyOp(in, op, model)

% Models
% zadeh, Bounded, and Yager

if op==AND_F    % Fuzzy intersection or conjuction
    if model=='zadeh'
        out = min(in, 2);
    elseif model=='bounded'
        out = max(0, 1-sum(in, 2));
    elseif model=='yager'
        out = min(1, sum(in.^w, 2).^1/w);
    end
elseif op==OR_F     % Fuzzy union
    if model=='zadeh' %#ok<*STCMP>
        out = max(in, 2);
    elseif model=='bounded'
        out = min(0, sum(in, 2));
    elseif model=='yager'
        out = 1 - min(1, sum((1-in).^w, 2).^1/w);
    end
elseif op==NOT_F    % Fuzzy complement
    if model=='zadeh'
        out = 1-in;
    elseif model=='bounded'
        out = 1-in;
    elseif model=='yager'
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

if fn==trimf
    % Triangular
    if val > mf{1}(3)
        mv = 0;
    elseif val > mf{1}(2)
        mv = (mf{1}(3) - mf{2}) / (mf{1}(3) - mf{1}(2));  
    elseif val > mf{1}(1)
        mv = (mf{2} - mf{1}(1)) / (mf{1}(2) - mf{1}(1));
    else 
        mv = 0;
    end
elseif fn==trapmf
    % Trapezoid
    if val > mf{1}(4)
        mv = 0;
    elseif val > mf{1}(3)
        mv = (mf{1}(4) - mf{2}) / (mf{1}(4) - mf{1}(3));
    elseif val > mf{1}(2)
        mv = 1;
    elseif val > mf{1}(1)
        mv = (mf{2} - mf{1}(1)) / (mf{1}(2) - mf{1}(1));
    else 
        mv = 0;
    end   
end

