%Pan Qixuan
%sqyqp1@nottingham.edu.cn

%% PRELIMINARY TASK-ARDUINO AND GIT INSTALLATION

a=arduino;

%% TASK 1-READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]

a=arduino; %Connect to arduino

duration=600; %Set the sampling time to 600 seconds
time=0:1:duration; %One data point per second
voltages=zeros(1, duration+1); %Create a group to store voltage data
temperature=zeros(1, duration+1); %Create a group to store temperature data

V0=500; %Zero-degree voltage of the temperature sensor
TC=10;  %The temperature coefficient of the temperature sensor

for i=1:duration+1;
    voltages(i)=readVoltage(a,'A0'); %Read the sensor voltage
    temperature(i)=(voltages(i)-V0)/TC; %Convert to temperature
    pause(1); %Measure again after waiting for one second
end

min_temp=min(temperature); %Minimum temperature
max_temp=max(temperature); %Maximum temperature
mean_temp=mean(temperature); %Average temperature

figure; 
plot(time, temperature, '-b', 'LineWidth', 2);
xlabel('time (seconds)'); %Set the time as the x-label
ylabel('temperature (\circC)') %Set the temperature as the y-label
title('temperature vs. time');
grid on;

file=fopen('cabin_temperature.txt', 'w'); %Open the file as written
fprintf(file, 'Data logging initiated-21/02/2025\n'); %Output the date and location
fprintf(file, 'Location: [Nottingham]\n\n');

for time=0:1:duration
    fprintf(file, 'Minute\t\t\t%d\n', time-1); %Display the data recorded from one minute to ten minutes in the file
    fprintf(file, 'Temperature\t\t%.2f C\n', temperature); %Display the temperature data recorded from one minute to ten minutes in the file
end

fprintf(file, 'Minimum temperature: %.2f\circC\n', min_temp); %Display Minimum temperature in the file
fprintf(file, 'Maximum temperature: %.2f\circC\n', max_temp); %Display Maximum temperature in the file
fprintf(file, 'Average temperature: %.2f\circC\n', mean_temp); %Display Average temperature in the file

fprintf(file, '\nData logging terminated\n'); %Enter the conclusion in the file

fclose(file); %Close the file

file=fopen('cabin_temperature.txt', 'r'); %Read the content of the document
line=fgetl(file); %Read the first line of the document
while ischar(line); %If there is still any content in the file
    disp(line); %Show the content of that line
    line=fgetl(file); %Continue reading the next line
end
fclose(file);

%% TASK 2- LED TEMPERATURE MONITORINE DEVICE IMPLEMENTATION [25 MARKS]

a=arduino; %Connect to arduino

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

%% TASK 4- REFLECTIVE STATEMENT [5 MARKS]

%The challenges of coursework for me are as follow:
%the connection of circuits and how to precisely read data from temperature
%sensors and control leds according to different temperature changes. In
%task 1, due to my unproficiency in circuit connection, the obtained
%temperature has always been negative, which took me quite a lot of time.
%In taks 2, due to the uncontrollable factor of the surrounding
%temperature, it is difficult to make all three LEDs light up. I also tried
%using a hair dryer to blow on the termistor or covering the thermistor
%with my hand, but this is not the best solution. I think more sensitive
%thermal resistors can be used to improve these problems, which can better
%sense the temperature. In taks 3, there is also a situation where the
%control effect of the LED cannot be well observed due to temperature
%issues. 