function p = searchThreshLevel( vals )
% Counts the total counts at a range of threshold levels and outputs the
% results
%
%   [p] = SEARCHTHRESHLEVEL( values ) returns the plot wiht the total
%   counts for the threshold levels given by the argument arry vals.
%   Minimum value is -0.300 V, maximum value is 0.300 V with increments of
%   0.2 mV.
%

% Establish connection
[g,obj] = SR430.connect( 0 );

% Clear SR430
invoke( obj, 'clear' );

% Preallocate data array
data = zeros( obj.BinsPerRecord*1024, numel( vals ) );

% Prepare plot
figure
p = plot( vals*1e3, sum( data,1 ) );
xlabel( 'Threshold Voltage [mV]' )
ylabel( 'Total Counts' )
title( 'Threshold Level Optimizer' )
p.Marker = 'o';
p.LineStyle = '-';

for i=1:numel( vals )
    
    % Start Scan
    invoke( obj, 'startScan' );
    
    while scanStatus < Nshots
        % Wait until scans are finished
        
        % Get current number of scans
        scanStatus = invoke( obj, 'scanStatus' );
        % Pausing seems to prevent a timeout of the GPIB connection. Might
        % also be related to the readout malfunction case (see below).
        pause(0.001)
        
    end
    
    % Read data
    data(:,i) = SR430.readData( obj,obj.BinsPerRecord*1024,0 );

    % Clear SR430
    invoke( obj, 'clear' );
    
    % Reset scan status
    scanStatus = 0;
    
    % Refresh plot
    p.YData = sum( data,1 );
    
end

% Disconnect
SR430.disconnect( g,obj,0 );