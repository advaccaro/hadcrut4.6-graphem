function [t1,t2,t3,t4] = estimators(tobs, tfrac, dist)
	% % flag missing values
	% tobs(tobs < - 90 | tobs > 490) = NaN;
	% calculate area weights
	w = prepare_areas(tobs(1,:,:));

	% covariance matrix
	cov = prepare_cov(tobs(1,:,:), dist);

	% calculate temperatures
	for m = 1:size(tobs,1)
		% make masked map
		t = tobs(m,:,:);
		% calculate means
		t1 = meana(t,w);
		t2 = meanh(t,w);
		t3 = meanh(t,w);
		t4 = gta1(t,cov);
		keyboard;
	end
end

function weights = prepare_areas(tmap)
	w = zeros(size(tmap));
	[ny,nx] = size(tmap);
	for i = 1:ny
		w(i,:) =  sind(180.0*i/ny-90.0) - sind(180.0*(i-1)/ny-90.0);
	end
	weights = w/sum(sum(w));
end

% prepare a list of intercell distances for flattened maps
function cov = prepare_cov(tmap, dist) %dist = 1000
	xs = deg2rad( ((0:size(tmap,1)-1)+.5)*180/size(tmap,1)-90.0);
	ys = deg2rad( ((0:size(tmap,2)-1)+.5)*360/size(tmap,2)-180.0);
	las = repelem(xs,len(ys));
	lns = repmat(ys, [1 length(xs)]);
	dists = zeros(numel(tmap), numel(tmap));
	for i = 1:numel(tmap)
		keyboard
		% ST = dbstack; dbstop('in', ST(1).file, 'at', str2num(ST(1).line+1));
	    dists(i,:) = 6371.0*acos( clip( sin(las(i))*sin(las) + cos(las(i)).*cos(las).*cos(lns(i)-lns), -1.0, 1.0 ) );
	end
	cov = exp(-dists/dist);
end

function tn = meana(t,w)
	wm = w;
	tm = t;
	wm(isnan(t)) = 0.0;
	tm(isnan(t)) = 0.0;
	tn = sum(wm*tm)/sum(wm);
end

function tn = meanh(t,w)
	wm = w;
	tm = t;
	wm(isnan(t)) = 0.0;
	tm(isnan(t)) = 0.0;
	n2 = size(t,1)/2;
	tn = 0.5*(sum(wm(1:n2,:) * tm(1:n2,:)) / sum(wm(1:n2,:)) + sum(wm(n2+1:end,:) * tm(n2+1:end))/sum(wm(n2+1:end,:)));
end

function tn = meanz(t,w)
	wm = w;
	tm = t;
	tm = reshape(repelem(nmean(tm,2), size(t,2))', size(wm)); %THE RESHAPE IN THIS LINE COULD BE INCORRECT
	wm(isnan(tm)) = 0.0;
	tm(isnan(tm)) = 0.0;
	tn = sum(wm * tm) / sum(wm);
end

% calculate GTA1 estimator for a given map using the correlation matrix
function tn = gta1(t, cov)
	data = flatten(t);
	unobsflag = isnan(data);
	obsflag = ~(unobsflag);
	y = data(obsflag);
	w = cov(obsflag,:);
	w = w(:,obsflag);
	% Solve for gls mean
	wi = pinv(w);
	sqi = sum(wi,1);
	tn = dot(swi,y)/sum(swi);
end

function STOP
  ST = dbstack;
  if length(ST) < 2; return; end
  dbstop('in', ST(2).file, 'at', str2num(ST(2).line+1));
end
