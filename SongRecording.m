song = audiorecorder(44100,16,1);
song.StartFcn = 'disp(''Start Speaking.'')';
song.StopFcn= 'disp(''Stop recording'')';
recordblocking(song,10);
play(song);
audio = getaudiodata(song);
fileID = fopen('song.txt','w');
for x = 1: length(audio)
    cache = audio(x)*10000;
    cache = int64(cache);
    if cache < 255
        cache= cache;
    else
        cache = 0;
    end

    formatSpec = '15''d%3d: duty=%3d; \r\n';
    fprintf(fileID,formatSpec,x-1,cache);
   
end
 fclose(fileID);