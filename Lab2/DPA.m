% (C) Ing. Jiri Bucek, Petr Vyleta

more off
tic
disp load

tracesLengthFile = fopen('traceLength.txt','r');
traceLength      = fscanf(tracesLengthFile, '%d');
numOfTraces      = 200;
startPoint       = 0;
points           = traceLength;
plaintextLength  = 16;

traces = tracesInput('traces.bin', traceLength, startPoint ,points, numOfTraces);
toc
disp('mean correction')
mm     = mean(mean(traces));
tm     = mean(traces, 2);
traces = traces - tm(:,ones(1,size(traces,2))) + mm;
toc

plot (traces);
disp('load text')
inputs = plaintextInput('plaintext.txt', plaintextLength, numOfTraces);

disp('power hypotheses')
load tab.mat

disp('**** Add your code to complete the analysis here ****')

keyHypo = (0:255);
keyMat = repmat(keyHypo,numOfTraces,1);
key_final=zeros(16,1);
correct_key=[202, 254, 186, 190, 163, 88, 119, 204, 17, 0, 186, 34, 107, 111, 107, 111];

for i = 1:16
    
ByteVector=inputs(:,i)';
ByteMat = repmat(ByteVector,256,1)';
CipherByteHypo=bitxor(keyMat,ByteMat);
after_sbox=SubBytes(CipherByteHypo + 1);

% Hamming Weight
PowerConsumption_HW= byte_Hamming_weight( after_sbox + 1);

% Hamming Distance

PowerConsumption_HD= bitxor(1, after_sbox +1 );

% Single bit
 PowerConsumption = bitget(after_sbox,5);
     
%Pearson correlation

ByteCorMat = myCorrcoef(PowerConsumption, traces);
highestCorCoef = max(ByteCorMat(:));
[key, time] = find(ismember(ByteCorMat, highestCorCoef));
key_final(i) = keyHypo(key);

%Traces first byte

%     if i==1
%         x=1:38000;
%         right_guess=ByteCorMat(key,1:38000);
%         wrong_guess_1=ByteCorMat(9,1:38000);
%         wrong_guess_2=ByteCorMat(128,1:38000);
%         plot(x,right_guess,x,wrong_guess_1,x,wrong_guess_2);
%         ylim([-1,1]);
%     end

% Find order of the correct key from the best candidate

% ByteCorMatSort=sort(ByteCorMat,2,'descend');
% [B,I] = sort(ByteCorMatSort(:,1),'descend');
% order=find(ismember(I,correct_key(i)+1))
end

% for i = 1:16
%     key_hexa=dec2hex(key_final(i))
% end
