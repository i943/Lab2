clc
clear
close all

inf = 1000; % Бесконечность принята, как большое число
p=0:0.1:1;  % Массив вероятностей ошибки в прямом канале

%  Part 1
av_N = zeros(1, length(p));         % Среднее число повторных передач
av_N_theor = zeros(1, length(p));   % Среднее N по теор формуле
index = 0;                          % Индекс в массивах
for Pe=p
    index = index + 1;
    % При такой вероятности ошибка в канале будет бесконечна, знаменатель
    % равен нулю, поэтому сразу записывается "большое число"
    if Pe == 1
        av_N(index) = 100;
        av_N_theor(index) = 100;
        continue;
    end
    k = ones(1, inf); % Количество передач каждого сообщения
    for i=1:inf  
        while rand() < Pe      % В этом случае случилась ошибка в прямом
            k(i) = k(i) + 1;   % канале, сообщение передается еще раз,
        end                    % пока не передастся
    end
    av_N(index) = sum(k) / ...   % Общее количество попыток передачи
                    length(k);   % делим на количество сообщений
    av_N_theor(index) = 1 / (1 - Pe);   % Из теор допуска
end
figure;
subplot(2, 3, 1);
plot(p, av_N_theor, 'r', p, av_N, 'b');
legend('Theoretic', 'Model');
xlabel('Pe');
ylabel('n');
axis([0, 1.1, 0, 15]);
xticks(0:0.2:1);
title('1 допуск');
grid('On');

%  Part 2
n = 10; % Ограничение на передачу одного сообщения
av_N = zeros(1, length(p));
av_N_theor = zeros(1, length(p));
index = 0;
for Pe=p
    index = index + 1;
    % При такой вероятности ошибка в канале будет бесконечна, поэтому
    % для моделирования заранее знаем, что n передач, для теории ставим
    % близкое к 1 значение вероятности
    if Pe == 1
        av_N(index) = n;
        av_N_theor(index) = (1 - 0.999 ^ n) / (1 - 0.999);
        continue;
    end
    k = ones(1, inf);
    for i=1:inf
        while k(i) < n && rand() < Pe   % Пытаемся передать, пока есть
            k(i) = k(i) + 1;            % ошибка и пока не достигли n 
        end                             % передач
    end
    av_N(index) = sum(k) / length(k);
    av_N_theor(index) = (1 - Pe ^ n) / (1 - Pe);
end
subplot(2, 3, 4);
plot(p, av_N_theor, 'r', p, av_N, 'b');
legend('Theoretic', 'Model');
xlabel('Pe')
ylabel('n')
axis([0, 1.1, 0, 15])
xticks(0:0.2:1)
grid('On')
title('2 допуск');

%  Part 3
Pe_q = 0.5;
av_N = zeros(1, length(p));
av_N_theor = zeros(1, length(p));
index = 0;
for Pe=p
    index = index + 1;
    if Pe == 1
        av_N(index) = 100;
        av_N_theor(index) = (1 / (1 - 0.999 - Pe_q + 0.999 * Pe_q));
        continue;
    end
    k = ones(1, inf);
    for i=1:inf
        while rand() < Pe || rand() < Pe_q % Передаем, пока в обоих каналах
            k(i) = k(i) + 1;               % не будет передачи без ошибки
        end
    end
    av_N(index) = sum(k) / length(k);
    av_N_theor(index) = 1 / (1 - Pe - Pe_q + Pe * Pe_q);
end
subplot(2, 3, 2);
plot(p, av_N_theor, 'r', p, av_N, 'b');
title('3 допуск');
legend('Theoretic', 'Model');
xlabel('Pe');
ylabel('n');
axis([0, 1.1, 0, 15]);
xticks(0:0.2:1);
grid('On');

av_N = zeros(1, length(p));
av_N_theor = zeros(1, length(p));
index = 0;
for Pe=p
    index = index + 1;
    if Pe == 1
        av_N(index) = n;
        av_N_theor(index) = ((1 - (0.999 + Pe_q - 0.999 * Pe_q) ^ n) / ...
                                ((1 - 0.999) * (1 - Pe_q)));
        continue;
    end
    k = ones(1, inf);
    for i=1:inf
        while k(i) < n && (rand() < Pe || rand() < Pe_q)
            k(i) = k(i) + 1;
        end
    end
    av_N(index) = (sum(k) / length(k));
    av_N_theor(index) = ((1 - (Pe + Pe_q - Pe * Pe_q)^n) / ...
                            ((1 - Pe) * (1 - Pe_q)));
end
subplot(2, 3, 5);
plot(p, av_N_theor, 'r', p, av_N, 'b');
legend('Theoretic', 'Model');
xlabel('Pe');
ylabel('n');
axis([0, 1.1, 0, 15]);
xticks(0:0.2:1);
grid('On');

%  Part 4
tao = 2;
% Вывод логов в файл при одном значении вероятности ошибки
Pe_for_logs = 0.3;
f = fopen('logs_alg_wait.txt', 'w');
for i=1:inf
    fprintf(f, 'm%s\n', int2str(i + 1));
    while rand() < Pe_for_logs
        fprintf(f, '\t%s\n', "-");
        fprintf(f, 'm%s\n', int2str(i + 1));
    end
    fprintf(f, '\t%s\n', "+");
end
% Моделирование для всех значений вероятности ошибки
koef = zeros(1, length(p));
koef_theor = zeros(1, length(p));
index = 0;
for Pe=p
    index = index + 1;
    if Pe == 1
        koef(index) = (1 / (3 * 1000));
        koef_theor(index) = ((1 - 0.999) / (1 + tao));
        continue;
    end
    k = ones(1, inf);
    for i=1:inf
        k(i) = (tao + 1);
        while rand() < Pe
            k(i) = k(i) + tao + 1;
        end
    end
    koef(index) = (inf / sum(k));
    koef_theor(index) = ((1 - Pe) / (1 + tao));
end
subplot(2, 3, 3);
plot(p, koef_theor, 'r', p, koef, 'b');
title('4 допуск');
legend('Theoretic', 'Model');
xlabel('Pe');
ylabel('КИК');
xticks(0:0.2:1);
grid('On');

%  Part 5
% Логи в файл
Pe_for_logs = 0.3;
f = fopen('logs_alg_back.txt', 'w');
stack = inf:-1:1;   % Стэк сообщений для отправки
need_to_add = 0;    % Переменная, отвечающая за надобность добавления в 
                    % стэк сообщений, если получена отрицательная квитанция
                    % (Эта квитанция может быть получена, когда
                    % за меньше, чем tao времени получена другая, тогда
                    % такое сообщение просто удаляется на приемной стороне
                    % и мы уже и так знаем, что его нужно заново передать)
while length(stack) > tao
    if need_to_add > 0
        need_to_add = need_to_add - 1;
    end
    m_now = stack(end);     % Номер сообщения для передачи 
    stack = stack(1:end-1); % Удаление сообщения из стэка
    fprintf(f, 'n%s\n', int2str(m_now));
    if rand() < Pe_for_logs
        fprintf(f, '\t%s%s%s\n', "m", int2str(m_now), "-");
        if need_to_add == 0     % Если получена отрицательная квитанция
                                % и эта переменная равна нулю, то это
                                % и следующие tao сообщений нужно передать
                                % повторно. При этом для следующих tao
                                % сообщений (не включая это) 
                                % этого делать не нужно, поэтому
                                % устанавливаем переменную need_to_add =
                                % tao+1
            res = stack(end-tao+1:end);
            stack = [stack(1:end-tao) res m_now res]; % В стэк добавляем 
                                                      % следующие tao
                                                      % сообщений для
                                                      % вывода логов,
                                                      % текущее заново и
                                                      % еще раз следующие
                                                      % tao, потому что они
                                                      % удалятся на
                                                      % приемной стороне
            need_to_add = tao+1;
        end
    else
        fprintf(f, '\t%s%s%s\n', "m", int2str(m_now), "+");
    end
end
% Моделирование
koef = zeros(1, length(p));
koef_theor = zeros(1, length(p));
index = 0;
for Pe=p
    index = index + 1;
    if Pe == 1
        koef(index) = 0;
        koef_theor(index) = ((1 - 0.999) / (1 + 0.999 * tao));
        continue;
    end
    k = 0;
    i = 0;
    while 1
        if rand() < Pe
            k = k + tao + 1;
            i = i - 1;
        else
            k = k + 1;
        end
        i = i + 1;
        if i > inf
            break;
        end
    end
    koef(index) = (inf / k);
    koef_theor(index) = ((1 - Pe) / (1 + Pe * tao));
end
subplot(2, 3, 6);
plot(p, koef_theor, 'r', p, koef, 'b');
title('5 допуск');
legend('Theoretic', 'Model');
xlabel('Pe');
ylabel('КИК');
axis([0, 1.1, 0, 1.2]);
xticks(0:0.2:1);
grid('On');