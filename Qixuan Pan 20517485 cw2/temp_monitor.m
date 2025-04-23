%% TASK 2- LED TEMPERATURE MONITORINE DEVICE IMPLEMENTATION [25 MARKS]

function temp_monitor(a)

figure; %make a graphical window

voltageArr=zeros(1,601); %Set up an array for collection voltage data
temperatureArr=zeros(1,601); %Set up an array for collection temperature data
counter=1; %Set upA a timer in seconds

while true
    voltageReading=a.readVoltage('A0'); %Read the voltage value in A0
    volatageArr(counter)=voltageReading; %Put the voltage value in the array
    temperatureArr(counter)=(voltageReading-0.5)/0.01; %Calculate the temperature by voltage
    time=1:counter;
    plot(time, temperatureArr(1:counter)); %Draw the curve what temperature vs time
    xlabel('time(s)'); %Set the time as the x-label
    ylabel('temperature(\circC)'); %Set the temperature as the y-label
    title('temperature vs time');
    drawnow;
    xlim([0 601]); %Set the x-label from 0 to 601
    if temperatureArr(counter)>=18 && temperatureArr(counter)<=24 %When the temperature is between 18 and 24 degrees
        writeDigitalPin(a,'D11',0); %Turn off the yellow LED
        writeDigitalPin(a,'D12',0); %Turn off the red LED
        writeDigitalPin(a,'D13',1); %Turn on the green LED
        pause(2); %Wait for 2 seconds
    elseif temperatureArr(counter)<18 %When the temperature is less than 18
        writeDigitalPin(a,'D13',0); %Turn off the green LED
        writeDigitalPin(a,'D12',0);
        writeDigitalPin(a,'D11',1); %Turn on the yellow LED
        pause(0.5); %Wait for 0.5 seconds
        writeDigitalPin(a,'D11',0); %Turn off the yellow LED
        pause(0.5); %Wait for 0.5 seconds
    elseif temperatureArr(counter)>24 %When the temperature is above than 24
        writeDigitalPin(a,'D13',0);
        writeDigitalPin(a,'D11',0);
        writeDigitalPin(a,'D12',1); %Turn on the red LED
        pause(0.25); %Wait for 0.25 seconds
        writeDigitalPin(a,'D12',0); %Turn off the red LED
        pause(0.25); %Wait for 0.25 seconds
    end

    counter=counter+1; %Record the next time point

    if counter>601; %When the time exceeds 601 second, end the cycle
        break;
    end
end