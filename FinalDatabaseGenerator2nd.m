clc;
clear;

modulationTypes = categorical(["qam4" , "qam16" , "qam32" , "qam64", "psk4" , "psk16" , "psk32" , "psk64"]);
dataDirectory = fullfile("C:\","Users\","ido57\","OneDrive\","Desktop\","פרויקט גמר\","Matlab Codes\","ModClassDataFileslowestsnr");
fileNameRoot = "frame";
SNR = [-5 -0 5];
numFramesPerModType = 600;
numModulationTypes = length(modulationTypes);
tic
% Check if data files exist
dataFilesExist = false;
if exist(dataDirectory,'dir')
  files = dir(fullfile(dataDirectory,sprintf("%s*",fileNameRoot)));
  if length(files) == numModulationTypes*numFramesPerModType
    dataFilesExist = true;
  end
end

if ~dataFilesExist
  disp("Generating data and saving in data files...")
  [success,msg,msgID] = mkdir(dataDirectory);
  if ~success
    error(msgID,msg)
  end
  for modType = 1:numModulationTypes
      fprintf('%s - Generating %s frames\n', ...
      datestr(toc/86400,'HH:MM:SS'), modulationTypes(modType))
      label = modulationTypes(modType);
      
    for snr=1:3
    for p=1:numFramesPerModType
      frame = modgenerator(modulationTypes(modType),SNR(snr));

      fileName = fullfile(dataDirectory,...
      sprintf("%s%s%s%01d%s%03d",fileNameRoot,modulationTypes(modType),'_',SNR(snr),'_',p));
      save(fileName,"frame","label")
    end
    end
  end
else
  disp("Data files exist. Skip data generation.")
end
