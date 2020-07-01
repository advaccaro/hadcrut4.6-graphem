%identifyPWtruth.m

function PW = identifyPWtruth(truth, worldnum,datatype)

if worldnum == 1
	if strcmp(datatype,'sst') == 1
	PW = truth.PW1_sst_truth;
	elseif strcmp(datatype,'lsat') == 1
	PW = truth.PW1_lsat_truth;
	end
elseif worldnum == 2
	if strcmp(datatype,'sst') == 1
	PW = truth.PW2_sst_truth;
	elseif strcmp(datatype,'lsat') == 1
	PW = truth.PW2_lsat_truth;
	end
elseif worldnum == 3
	if strcmp(datatype, 'sst') == 1
	PW = truth.PW3_sst_truth;
	elseif strcmp(datatype, 'lsat') == 1
	PW = truth.PW3_lsat_truth;
	end
elseif worldnum == 4
	if strcmp(datatype, 'sst') == 1
	PW = truth.PW4_sst_truth;
	elseif strcmp(datatype, 'lsat') == 1
	PW = truth.PW4_lsat_truth;
	end
end
