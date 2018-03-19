% (C) Ing. Jiri Bucek, Petr Vyleta

more off
tic
disp load

tracesLengthFile = fopen('traceLength.txt','r');
traceLength      = fscanf(tracesLengthFile, '%d');
numOfTraces      = 200; %200
startPoint       = 0; %0
points           = traceLength;
plaintextLength  = 16;

traces = tracesInput('traces.bin', traceLength, startPoint ,points, numOfTraces);
toc
disp('mean correction')
mm     = mean(mean(traces));
tm     = mean(traces, 2);
traces = traces - tm(:,ones(1,size(traces,2))) + mm;
toc

%kontrola zarovnani
%plot(traces(:,1:200)')

disp('load text')
inputs = plaintextInput('plaintext.txt', plaintextLength, numOfTraces);

disp('power hypotheses')
load tab.mat

disp('**** Add your code to complete the analysis here ****')

%plot(traces([1:30,70:100,150:190],:)')
plot(traces(1,1:30000)')

keyHypo = (0:255);
keyMat = repmat(keyHypo,numOfTraces,1);

fistByteVector=inputs(:,1)';
firstByteMat = repmat(fistByteVector,256,1)';

firstCipherByteHypo=bitxor(keyMat,firstByteMat);

SubBytes(firstCipherByteHypo + 1);

firstByteCipherHW = byte_Hamming_weight(firstCipherByteHypo + 1);

%pearson correlation traces and firstByteCipherHW

firstByteCorMat = zeros(256, 27000);
%for i = 1:256
%    for j = 1:27000
%        firstByteCorMat(i,j) = corr(firstByteCipherHW(:,i), traces(:, j));
%    end
%end

firstByteCorMat = corr(firstByteCipherHW, traces);

highestCorCoef = max(firstByteCorMat(:))
[key, time] = find(ismember(firstByteCorMat, highestCorCoef))


