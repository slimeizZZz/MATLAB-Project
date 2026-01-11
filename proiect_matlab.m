
clear; clc; close all;

portName = 'COM5';  % portul meu este COM5
baudRate = 115200;

delete(serialportfind); % sterge orice conexiune (inclusiv cea din Command Window)
delete(instrfind);      % sterge si conexiunile vechi

pause(2); 

disp(['Încerc conectarea la ', portName, '...']);


s = serialport(portName, baudRate);%creez conexiunea cu portul astfel incat sa conectez matlab cu esp32

configureTerminator(s, "CR/LF");%setez terminatorul ca sa nu se blocheze compilerul
flush(s);%curatarea bufferelor reziduale
disp('CONECTAT CU SUCCES!');

%pregatire grafic
%creez un tab figure cu nume si culoare
fig = figure('Name', 'Monitorizare LED', 'Color', 'w');
hLine = animatedline('Color', 'b', 'LineWidth', 2);%folosesc animatedline pt un plot live 
ax = gca; ax.YLim = [-0.2 1.2]; grid on;%setarea gridului si a axelor
%desi axa y in mod normal este cuprinsa intre 0 si 1 am adaugat pur estetic
%o marja de 0.2 ca sa nu fie lipita linia de figure
title('Test Conexiune - Apasă butonul!');

stopBtn = uicontrol('Style', 'pushbutton', 'String', 'STOP', ...
                    'Position', [20 20 100 40], ...
                    'Callback', 'setappdata(gcf, ''running'', 0)');%ce se intampla atunci cand opresc butonul adica circuitul 
setappdata(fig, 'running', 1); %setez variabila running la 1 ca sa pot sa o schimb mai sus in 0 adica graficul sa ramana la 0 cand apas a doua oara pe buton


x = 0;
while getappdata(fig, 'running')% cat timp figure se misca
    dataLine = readline(s);%citeste din sirul de seriala
    val = str2double(dataLine);%converteste textul "0" sau "1" in numerele 0 sau 1
    
    if ~isnan(val)%daca valoarea este un numar
        x = x + 1;
        addpoints(hLine, x, val);%adauga puncte, pe punctul x se adauga o noua valoare 0 sau 1 
        drawnow limitrate;%actualizarea-figure ului live si limitarea fps urilor
        
        if x > 100
             ax.XLim = [x-100 x];%cu comanda asta se pot vedea doar ultimele 100 de puncte pt ca ajustez axa x de la 1 la 100 practic
        end
    end
end

delete(s);%sterg incarcarea seriala
disp('Gata.');
