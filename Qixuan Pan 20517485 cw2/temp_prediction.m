%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]

function temp_prediction
count=1;
data=1;
Tc=10;
temp_rate=0;
while true
    voltage=a.readvoltage('A0'); %Read the data from A0
    temperature=(voltage-0.5)/0.01/Tc; %Calculate the temperature
    data(count)=temperature;
    if count>1
        temp_rate=data(count)-data(count-1);
        if temp_rate>-4
            writeDigitalPin(a,'d13',0); %Turn off the green LED
            writeDigitalPin(a,'d12',0); %Turn off the red LED
            writeDigitalPin(a,'d11',1); %Turn on the yellow LED
        elseif temp_rate>4
            writeDigitalPin(a, 'd13', 0);
            writeDigitalPin(a, 'd11', 0); %Turn off the yellow LED
            writeDigitalPin(a, 'd12', 1); %Turn on the red LED
        elseif temp_rate>-4 && temp_rate<4
            writeDigitalPin(a, 'd11', 0);
            writeDigitalPin(a, 'd12', 0); %Turn off the red LED
            writeDigitalPin(a, 'd13', 1); %Turn on the green LED
        end
    end
end
end