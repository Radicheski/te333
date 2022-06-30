plotValues('0000', 100, 'Semiciclo completo');
plotValues('0001', 100, 'Borda de subida');
plotValues('0002', 100, 'Borda de descida');
plotValues('0003', 10e3, 'Semiciclo completo');
plotValues('0004', 10e3, 'Borda de descida');
plotValues('0005', 10e3, 'Borda de subida');

function data = readDataTable(filename)
    data = readtable(filename);
    data = data(:,4:5);
    data.Properties.VariableNames = {'time', 'voltage'};
end

function plotValues(file, freq, titleText)
    input = readDataTable(['ALL' file '/F' file 'CH1.CSV']);
    output = readDataTable(['ALL' file '/F' file 'CH2.CSV']);
    
    figure;
    hold on;
    ax = gca;
    
    xlabel('Tempo (s)');
    xlim([min(input.time) max(input.time)]);
    
    yyaxis left;
    ylim([min(cat(1,input.voltage,-output.voltage)) max(cat(1,input.voltage,-output.voltage))]);
    ylabel('Tensão de entrada (V)');
    plot(input.time, input.voltage);
    
    yyaxis right;
    ax.YDir = 'reverse';
    ylim([min(cat(1,-input.voltage,output.voltage)) max(cat(1,-input.voltage,output.voltage))]);
    ylabel('Tensão de saída (V)');
    plot(output.time, output.voltage);
    
    freqTitle = [num2str(freq) ' Hz'];
    title({titleText, freqTitle});
    
    saveas(gcf, [file '.png']);
end