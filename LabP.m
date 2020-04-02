clc
clear
close all

% 2 лаба 7 Вариант Зависимости от p

n = 200;
p = 0:0.1:1;
tao = 2;
num_channels = tao+1;
buf_size = 1;

kpd = zeros(1, length(p));
N = zeros(1, length(p));
N(end) = 1000;
kpd(end) = 0;
k = 0;
for pi=p(1:end-1)
    k = k + 1;
    buf = zeros(1, buf_size);
    buf_size_now = buf_size;
    messages_in_queue = 1:n;
    messages_in_queue([1,2,3]) = 0;
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
        if rand() > pi
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
    N(k) = num_sends / n;
    kpd(k) = n / num_sends;
end
figure;
subplot(2, 1, 1);
plot(p, N, 'r');
xlabel('Pe');
ylabel('среднее N');
axis([0, 1.1, 0, 15]);
xticks(0:0.2:1);
grid('On');
subplot(2, 1, 2);
plot(p, kpd, 'b');
xlabel('Pe');
ylabel('КПД');
grid('On');
