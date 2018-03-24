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

disp('load text')
inputs = plaintextInput('plaintext.txt', plaintextLength, numOfTraces);

disp('power hypotheses')
load tab.mat

disp('**** Add your code to complete the analysis here ****')

keyHypo = (0:255);
keyMat = repmat(keyHypo,numOfTraces,1);
key_final=zeros(16,1);

for i = 1:16
    
ByteVector=inputs(:,i)';
ByteMat = repmat(ByteVector,256,1)';
CipherByteHypo=bitxor(keyMat,ByteMat);

PowerConsumption = byte_Hamming_weight(SubBytes(CipherByteHypo + 1) + 1);

%Pearson correlation

ByteCorMat = myCorrcoef(PowerConsumption, traces);
highestCorCoef = max(ByteCorMat(:));
[key, time] = find(ismember(ByteCorMat, highestCorCoef));
    if i==1
        x=1:38000;
        right_guess=ByteCorMat(key,1:38000);
        wrong_guess_1=ByteCorMat(1,1:38000);
        wrong_guess_2=ByteCorMat(8,1:38000);
        plot(x,right_guess,x,wrong_guess_1,x,wrong_guess_2);
        ylim([-1,1]);
    end
key_final(i) = keyHypo(key);
end

for i = 1:16
    key_hexa=dec2hex(key_final(i))
end
