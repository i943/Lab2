clc
clear
close all

% 2 лаба 7 Вариант Логи в файл (+вывод в консоль)

f = fopen('logs.txt', 'w');
n = 10;
p = 0.5;
tao = 2;
num_channels = tao+1;
buf_size = 5;

buf = zeros(1, buf_size);
buf_size_now = buf_size;
fprintf(f, '%s%s\n%s%s\n%s%s\n%s%s\n\n', ...
            "t = ", int2str(tao), "p = ", num2str(p), ...
            "Num of channels = ", int2str(num_channels), ...
            "Buffer size = ", num2str(buf_size));
messages_in_queue = 1:n;
messages_in_queue([1,2,3]) = 0;
last_message_sent = 0;
last_message_recieved = 0;
messages_in_channels = 1:num_channels;
channel_now = 0;
num_str = 1;
while last_message_sent < n
    channel_now = mod(channel_now, num_channels) + 1;
    message_now = messages_in_channels(channel_now);
    if message_now == 0
        fprintf(f, '%s empty subchannel\n', num2str(num_str));
        fprintf('%s empty subchannel\n', num2str(num_str));
        num_str = num_str + 1;
        continue;
    end
    fprintf(f, '%s %s%s\t\t\t\t\t\t%s', num2str(num_str), "m", int2str(message_now), "buffer: ");
    fprintf('%s %s%s\t\t\t\t\t\t%s', num2str(num_str), "m", int2str(message_now), "buffer: ");
    num_str = num_str + 1;
    
    for i=buf_size_now+1:buf_size
        fprintf(f, '%s%s', int2str(buf(i)), " ");
        fprintf('%s%s', int2str(buf(i)), " ");
    end
    fprintf(f, '\n');
    fprintf('\n');
    
    if rand() > p
        if last_message_sent == message_now - 1
            fprintf(f, '%s\t\t%s%s%s\n', num2str(num_str), "m", int2str(message_now), "+ ->");
            fprintf('%s\t\t%s%s%s\n', num2str(num_str), "m", int2str(message_now), "+ ->");
            num_str = num_str + 1;
            last_message_sent = message_now;
        elseif buf_size_now > 0
            fprintf(f, '%s\t\t%s%s%s\n', num2str(num_str), "m", int2str(message_now), "+ to buf");
            fprintf('%s\t\t%s%s%s\n', num2str(num_str), "m", int2str(message_now), "+ to buf");
            num_str = num_str + 1;
            buf(buf_size_now) = message_now;
            buf_size_now = buf_size_now - 1;
        else
            fprintf(f, '%s\t\t%s%s%s\n', num2str(num_str), "m", int2str(message_now), "- no place in buffer");
            fprintf('%s\t\t%s%s%s\n', num2str(num_str), "m", int2str(message_now), "- no place in buffer");
            num_str = num_str + 1;
            continue;
        end
        if last_message_recieved < message_now
            last_message_recieved = message_now;
        end
        next_message_index = find(messages_in_queue>0, 1);
        if isempty(next_message_index)
            messages_in_channels(channel_now) = 0;
        else
            messages_in_channels(channel_now) = messages_in_queue(next_message_index);
            messages_in_queue(next_message_index) = 0;
        end
        % Доотправлять из буфера
        while ~isempty(find(buf==last_message_sent+1, 1))
            fprintf(f, '%s\t\t%s%s%s\n', num2str(num_str), "m", int2str(last_message_sent+1), " from buf ->");
            fprintf('%s\t\t%s%s%s\n', num2str(num_str), "m", int2str(last_message_sent+1), " from buf ->");
            num_str = num_str + 1;
            buf(find(buf==last_message_sent+1, 1)) = 0;
            buf_size_now = buf_size_now + 1;
            last_message_sent = last_message_sent + 1;
        end
        put_in_buf = buf(buf~=0);
        buf = zeros(1, buf_size);
        if ~isempty(put_in_buf)
            j=1;
            for i=buf_size_now+1:buf_size
                buf(1, i) = put_in_buf(1, j);
                j=j+1;
            end
            buf_size_now = buf_size-length(put_in_buf);
        end
    else
        fprintf(f, '%s\t\t%s%s%s\n', num2str(num_str), "m", int2str(message_now), "- error in channel");
        fprintf('%s\t\t%s%s%s\n', num2str(num_str), "m", int2str(message_now), "- error in channel");
        num_str = num_str + 1;
    end
end
