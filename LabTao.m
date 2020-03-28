clc
clear
close all

% 2 лаба 7 Вариант Зависимости от p

n = 1000;
p = 0.5;
tao = 1:10;
buf_size = 5;

kpd = zeros(1, length(tao));
N = zeros(1, length(tao));
k = 0;
for t=tao
    num_channels = t+1;
    k = k + 1;
    buf = zeros(1, buf_size);
    buf_size_now = buf_size;
    messages_in_queue = 1:n;
    messages_in_queue(1:num_channels) = 0;
    messages_in_channels = 1:num_channels;
    last_message_sent = 0;
    last_message_recieved = 0;
    channel_now = 0;
    num_sends = 0;
    while last_message_sent < n
        num_sends = num_sends + 1;
        channel_now = mod(channel_now, num_channels) + 1;
        message_now = messages_in_channels(channel_now);
        if message_now == 0
            continue;
        end
        if rand() > p
            if last_message_sent == message_now - 1
                last_message_sent = message_now;
            elseif buf_size_now > 0
                buf(buf_size_now) = message_now;
                buf_size_now = buf_size_now - 1;
            else
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
            while ~isempty(find(buf==last_message_sent+1, 1))
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
        end
    end
    N(k) = num_sends / last_message_recieved;
    kpd(k) = last_message_sent / num_sends;
end
figure;
subplot(2, 1, 1);
plot(tao, N, 'r');
xlabel('Tao');
ylabel('среднее N');
grid('On');
subplot(2, 1, 2);
plot(tao, kpd, 'b');
xlabel('Tao');
ylabel('КПД');
grid('On');
