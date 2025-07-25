% define_IMU_buses.m


clear all;  % Clear workspace to avoid conflicts

%% Helper function to create a bus element
function elem = createBusElement(name, dataType)
    elem = Simulink.BusElement;
    elem.Name = name;
    elem.DataType = dataType;
    elem.Dimensions = 1;
    elem.SampleTime = -1;  % Inherited
    elem.Complexity = 'real';
    elem.SamplingMode = 'Sample based';
end
% IMU bus (gyro, accel, mag)
elems = [
  createBusElement('p','double');
  createBusElement('q','double');
  createBusElement('r','double');
  createBusElement('ax','double');
  createBusElement('ay','double');
  createBusElement('az','double');
];
IMUBus = Simulink.Bus;
IMUBus.Elements = elems;
assignin('base','IMUBus',IMUBus);
save('data/IMU_Bus.mat', 'IMUBus');

disp('Bus definitions created and saved to data/IMU_Bus.mat');