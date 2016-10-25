function fdt(inFile, method)
% Fuzzy decision trees

inp = csvread(inFile);
% Input data has 7 variables
% Car ID, Risk, Value Loss, Horsepower, City MPG, Highway MPG, and Price

% Membership funtions for the input characteristics
% Risk
x = (-3:3)';    % Input range for Risk
risk.Low = trapmf_S(x, [-3 -3 -2 0]);
risk.Average = trimf_S(x, [-2 0 2]);
risk.High = trapmf_S(x, [0 2 3 3]);

% Value Loss
x = (0:300)';
valueLoss.Low = trapmf_S(x, [0 0 100 200]);
valueLoss.Average = trimf_S(x, [100 120 200]);
valueLoss.High = trapmf_S(x, [120 200 300 300]);

% Horsepower
x = (0:250)';
horsepower.Low = trapmf_S(x, [0 0 60 100]);
horsepower.Average = trimf_S(x, [60 100 140]);
horsepower.Low = trapmf_S(x, [100 140 250 250]);

% City MPG
x = (0:60)';
cityMPG.Poor = trapmf_S(x, [0 0 20 30]);
cityMPG.Average = trimf_S(x, [20 30 40]);
cityMPG.Good = trapmf_S(x, [30 40 60 60]);

% Highway MPG
x = (0:60)';
highwayMPG.Poor = trapmf_S(x, [0 0 20 30]);
highwayMPG.Average = trimf_S(x, [20 30 40]);
highwayMPG.Good = trapmf_S(x, [30 40 60 60]);

% Price
x = (0:40000)';
price.Cheap = trapmf_S(x, [0 0 7000 10000]);
price.Average = trimf_S(x, [7000 10000 20000]);
price.Expensive = trapmf_S(x, [10000 20000 40000 40000]);

end

% Decision Tree for the given input
function out = decisionTree(inp, risk, valueLoss, horsepower, cityMPG, highwayMPG, price)

% Number of inputs
N = size(inp, 1);

for i=1:N % Loop for all the input data for the decision tree
    
end

end


% Membership functions
% Trapezoidal Membership
function trapmf_S(mf, val)

end

% Traingular Membership
function trimf_S
end

% Membership function
%--------------------------------------
% mf is assumed to be of the form:
%    {[a b c (d)], height}
%--------------------------------------
function mv = eval_mf( mf, val )

if( length(mf{1}) == 3)
    % Triangular
    if val > mf{1}(3)
        mv = 0;
    elseif val > mf{1}(2)
        mv = mf{2} * (mf{1}(3) - val) / (mf{1}(3) - mf{1}(2));
    elseif val > mf{1}(1)
        mv = mf{2} * (val - mf{1}(1)) / (mf{1}(2) - mf{1}(1));
    else 
        mv = 0;
    end
elseif (length(mf{1}) == 4)
    % Trapezoid
    if val > mf{1}(4)
        mv = 0;
    elseif val > mf{1}(3)
        mv = mf{2} * (mf{1}(4) - val) / (mf{1}(4) - mf{1}(3));
    elseif val > mf{1}(2)
        mv = mf{2};
    elseif val > mf{1}(1)
        mv = mf{2} * (val - mf{1}(1)) / (mf{1}(2) - mf{1}(1));
    else 
        mv = 0;
    end   
end

