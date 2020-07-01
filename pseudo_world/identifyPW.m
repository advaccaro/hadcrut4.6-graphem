%identifyPW.m

function PW = identifyPW(raw, worldnum,datatype)

if worldnum == 1
	if strcmp(datatype,'sst') == 1
	PW = raw.PW1_sst;
	elseif strcmp(datatype,'lsat') == 1
	PW = raw.PW1_lsat;
	end
elseif worldnum == 2
	if strcmp(datatype,'sst') == 1
	PW = raw.PW2_sst;
	elseif strcmp(datatype,'lsat') == 1
	PW = raw.PW2_lsat;
	end
elseif worldnum == 3
	if strcmp(datatype, 'sst') == 1
	PW = raw.PW3_sst;
	elseif strcmp(datatype, 'lsat') == 1
	PW = raw.PW3_lsat;
	end
elseif worldnum == 4
	if strcmp(datatype, 'sst') == 1
	PW = raw.PW4_sst;
	elseif strcmp(datatype, 'lsat') == 1
	PW = raw.PW4_lsat;
	end
end
