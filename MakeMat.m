% Use imufilter() to generate Rotation Matrix "headings" from
% Accelerometer and Gyroscope data.
%
% Parameters:
%
% - Acc is an Nx3 matrix, where N is the number of data samples, and the 3
% columns contain the X, Y, and Z axes of acceleration data, calibrated in
% G.
%
% - Gyr is an Nx3 matrix where the 3 columns contain the X, Y, and Z axes
% of angular velocity "gyroscope" data, calibrated in degrees/second.
%
% Output:
%
% - R is the 3x3xN Rotation Matrix output, used for further analysis and
% plotting.

function R = MakeMat(Acc, Gyr)

SampRate = 500;
GtoA = 9.80665; % Convert acceleration in G to m/s^2.

% Generate the Sensor Fusion function.
FUSE = imufilter('SampleRate', SampRate);

% Call the sensor fusion function to convert Accel and Gyro to a
% Quaternion which represents the IMU heading.
q = FUSE(Acc.*GtoA, deg2rad(Gyr));

% Convert the Quaternions to Rotation Matrices
R = rotmat(q, 'point');
