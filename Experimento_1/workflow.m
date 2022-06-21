plotValues('0000', 10e3, 10e3, 10e-9, @integrator);
plotValues('0001', 10e3, 100e3, 10e-9, @integrator);
plotValues('0002', 10e3, 1e6, 10e-9, @integrator);

plotValues('0003', 1e3, 100e3, 10e-9, @differentiator);
plotValues('0004', 10e3, 100e3, 10e-9, @differentiator);
plotValues('0005', 39e3, 100e3, 10e-9, @differentiator);

function data = readDataTable(filename)
    data = readtable(filename);
    data = data(:,4:5);
    data.Properties.VariableNames = {'time', 'voltage'};
end

function plotValues(file, R, Rf, C, functionHandler)
    input = readDataTable(['ALL' file '/F' file 'CH1.CSV']);
    output = readDataTable(['ALL' file '/F' file 'CH2.CSV']);
    
    G = functionHandler(R, Rf, C);
    [z, x, ~] = lsim(G, input.voltage, input.time);
    
    figure;
    hold on;
    plot(input.time, input.voltage);
    plot(output.time, output.voltage);
    plot(x, z);
    
    legend('Sinal de entrada', 'Saída (medida)', 'Saída (calculada)');
    xlabel('Tempo (s)');
    ylabel('Tensão (V)');
    ylim([-0.6 0.6]);
    
    textRf = ['R_f = ' num2str(Rf) ' \Omega'];
    textRi = ['R_i = ' num2str(R) ' \Omega'];
    title({textRf, textRi});
    
    saveas(gcf, [file '.png']);
end

function G = integrator(R, Rf, C)
    s = tf('s');
    G = - (Rf / R) * (1 / (1 + s * C * Rf));
end

function G = differentiator(R, Rf, C)
    s = tf('s');
    G = - Rf / (R + 1 / (s * C));
end

