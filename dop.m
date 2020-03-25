clc
clear
close all

inf = 1000; % ������������� �������, ��� ������� �����
p=0:0.1:1;  % ������ ������������ ������ � ������ ������

%  Part 1
av_N = zeros(1, length(p));         % ������� ����� ��������� �������
av_N_theor = zeros(1, length(p));   % ������� N �� ���� �������
index = 0;                          % ������ � ��������
for Pe=p
    index = index + 1;
    % ��� ����� ����������� ������ � ������ ����� ����������, �����������
    % ����� ����, ������� ����� ������������ "������� �����"
    if Pe == 1
        av_N(index) = 100;
        av_N_theor(index) = 100;
        continue;
    end
    k = ones(1, inf); % ���������� ������� ������� ���������
    for i=1:inf  
        while rand() < Pe      % � ���� ������ ��������� ������ � ������
            k(i) = k(i) + 1;   % ������, ��������� ���������� ��� ���,
        end                    % ���� �� ����������
    end
    av_N(index) = sum(k) / ...   % ����� ���������� ������� ��������
                    length(k);   % ����� �� ���������� ���������
    av_N_theor(index) = 1 / (1 - Pe);   % �� ���� �������
end
figure;
subplot(2, 3, 1);
plot(p, av_N_theor, 'r', p, av_N, 'b');
legend('Theoretic', 'Model');
xlabel('Pe');
ylabel('n');
axis([0, 1.1, 0, 15]);
xticks(0:0.2:1);
title('1 ������');
grid('On');

%  Part 2
n = 10; % ����������� �� �������� ������ ���������
av_N = zeros(1, length(p));
av_N_theor = zeros(1, length(p));
index = 0;
for Pe=p
    index = index + 1;
    % ��� ����� ����������� ������ � ������ ����� ����������, �������
    % ��� ������������� ������� �����, ��� n �������, ��� ������ ������
    % ������� � 1 �������� �����������
    if Pe == 1
        av_N(index) = n;
        av_N_theor(index) = (1 - 0.999 ^ n) / (1 - 0.999);
        continue;
    end
    k = ones(1, inf);
    for i=1:inf
        while k(i) < n && rand() < Pe   % �������� ��������, ���� ����
            k(i) = k(i) + 1;            % ������ � ���� �� �������� n 
        end                             % �������
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
title('2 ������');

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
        while rand() < Pe || rand() < Pe_q % ��������, ���� � ����� �������
            k(i) = k(i) + 1;               % �� ����� �������� ��� ������
        end
    end
    av_N(index) = sum(k) / length(k);
    av_N_theor(index) = 1 / (1 - Pe - Pe_q + Pe * Pe_q);
end
subplot(2, 3, 2);
plot(p, av_N_theor, 'r', p, av_N, 'b');
title('3 ������');
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
% ����� ����� � ���� ��� ����� �������� ����������� ������
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
% ������������� ��� ���� �������� ����������� ������
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
title('4 ������');
legend('Theoretic', 'Model');
xlabel('Pe');
ylabel('���');
xticks(0:0.2:1);
grid('On');

%  Part 5
% ���� � ����
Pe_for_logs = 0.3;
f = fopen('logs_alg_back.txt', 'w');
stack = inf:-1:1;   % ���� ��������� ��� ��������
need_to_add = 0;    % ����������, ���������� �� ���������� ���������� � 
                    % ���� ���������, ���� �������� ������������� ���������
                    % (��� ��������� ����� ���� ��������, �����
                    % �� ������, ��� tao ������� �������� ������, �����
                    % ����� ��������� ������ ��������� �� �������� �������
                    % � �� ��� � ��� �����, ��� ��� ����� ������ ��������)
while length(stack) > tao
    if need_to_add > 0
        need_to_add = need_to_add - 1;
    end
    m_now = stack(end);     % ����� ��������� ��� �������� 
    stack = stack(1:end-1); % �������� ��������� �� �����
    fprintf(f, 'n%s\n', int2str(m_now));
    if rand() < Pe_for_logs
        fprintf(f, '\t%s%s%s\n', "m", int2str(m_now), "-");
        if need_to_add == 0     % ���� �������� ������������� ���������
                                % � ��� ���������� ����� ����, �� ���
                                % � ��������� tao ��������� ����� ��������
                                % ��������. ��� ���� ��� ��������� tao
                                % ��������� (�� ������� ���) 
                                % ����� ������ �� �����, �������
                                % ������������� ���������� need_to_add =
                                % tao+1
            res = stack(end-tao+1:end);
            stack = [stack(1:end-tao) res m_now res]; % � ���� ��������� 
                                                      % ��������� tao
                                                      % ��������� ���
                                                      % ������ �����,
                                                      % ������� ������ �
                                                      % ��� ��� ���������
                                                      % tao, ������ ��� ���
                                                      % �������� ��
                                                      % �������� �������
            need_to_add = tao+1;
        end
    else
        fprintf(f, '\t%s%s%s\n', "m", int2str(m_now), "+");
    end
end
% �������������
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
title('5 ������');
legend('Theoretic', 'Model');
xlabel('Pe');
ylabel('���');
axis([0, 1.1, 0, 1.2]);
xticks(0:0.2:1);
grid('On');