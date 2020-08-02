function xk = cw_krig(data2d, dist, lats, lons)
	[ntime, nspace] = size(data2d);
	cov = prepare_cov2(lats, lons, dist);
	xk = nan(size(data2d));
	for i = 1:ntime
		xk(i,:) = interpolate2(data2d, cov);
		keyboard;
	end


end

function cov = prepare_cov2(lats, lons, dist) %dist = 1000
	nlat = length(lats);
	nlon = length(lons);
	xs = deg2rad(lats);
	ys = deg2rad(lons);
	% xs = deg2rad( ((0:nlat-1)+.5)*180/nlat-90.0);
	% ys = deg2rad( ((0:nlon-1)+.5)*360/nlon-180.0);
	keyboard;
	nspace = nlat * nlon;
	las = repelem(xs,len(ys));
	lns = repmat(ys, [1 length(xs)]);
	dists = zeros(nspace, nspace);
	for i = 1:nspace
	    dists(i,:) = 6371.0*acos( clip( sin(las(i))*sin(las) + cos(las(i)).*cos(las).*cos(lns(i)-lns), -1.0, 1.0 ) );
	end
	cov = exp(-dists/dist);
end

function xk = cw_krig3d(tobs, tfrac, dist)
	[ntime, nlat, nlon] = size(tobs);
	tmap0 = reshape(tobs(1,:,:), [nlat, nlon]);

	% calculate area weights
	w = prepare_areas(tmap0);

	% covariance matrix
	cov = prepare_cov(tmap0, dist);

	% interpolate
	results = {};
	for i = 1:ntime
		tmap = reshape(tobs(i,:,:), [nlat, nlon]);
		result = interpolate(tmap, cov);
		results{i} = result;
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

function y = clip(x,bl,bu)
  % return bounded value clipped between bl and bu
  y=min(max(x,bl),bu);
end

% prepare a list of intercell distances for flattened maps
function cov = prepare_cov(tmap, dist) %dist = 1000
	[nlat, nlon] = size(tmap);
	xs = deg2rad( ((0:nlat-1)+.5)*180/nlat-90.0);
	ys = deg2rad( ((0:nlon-1)+.5)*360/nlon-180.0);
	las = repelem(xs,len(ys));
	lns = repmat(ys, [1 length(xs)]);
	dists = zeros(numel(tmap), numel(tmap));
	for i = 1:numel(tmap)
	    dists(i,:) = 6371.0*acos( clip( sin(las(i))*sin(las) + cos(las(i)).*cos(las).*cos(lns(i)-lns), -1.0, 1.0 ) );
	end
	cov = exp(-dists/dist);
end

function flattened = flatten(fatten)
	flattened = reshape(fatten.',1,[]);
end

function result = interpolate2(data, cov)
	% here data is 2d (time x space)
	unobsflag = isnan(data);
	obsflag = ~isnan(data);
	tmp = cov(obsflag,:);
	a1 = tmp(:,obsflag);
	b = tmp(:,unobsflag);
	c = data(obsflag);
	a2 = vertcat( horzcat(a1, ones(size(a1,1), 1)), horzcat(ones(1, size(a1,2)), 0)	);
	b2 = vertcat(b, ones(1,size(b,2)));
	c2 = horzcat(c, zeros(1));
	%solve for basis function weights
	x = linsolve(a2,b2);
	% calculate temperatures and store
	% t = dot(c2,x);
	t = c2*x;
	result = data;
	result(unobsflag) = t;
end

function result = interpolate(tmap, cov)
	% set up matrices
	data = flatten(tmap);
	unobsflag = isnan(data);
	obsflag = ~isnan(data);
	tmp = cov(obsflag,:);
	a1 = tmp(:,obsflag);
	b = tmp(:,unobsflag);
	c = data(obsflag);
	a2 = vertcat( horzcat(a1, ones(size(a1,1), 1)), horzcat(ones(1, size(a1,2)), 0)	);
	b2 = vertcat(b, ones(1,size(b,2)));
	c2 = horzcat(c, zeros(1));
	%solve for basis function weights
	x = linsolve(a2,b2);
	% calculate temperatures and store
	% t = dot(c2,x);
	t = c2*x;
	result = data;
	result(unobsflag) = t;
	result = reshape(result, size(tmap)); %CHECK THIS RESHAPE
end

function r = rms(x)
	r = sqrt(mean(square(x)));;
end

function tn = gta1(t, cov)
	data = flatten(t);
	unobsflag = isnan(data);
	obsflag = ~(unobsflag);
	y = data(obsflag);
	w = cov(obsflag,:);
	w = w(:,obsflag);
	% Solve for gls mean
	wi = pinv(w);
	swi = sum(wi,1);
	tn = dot(swi,y)/sum(swi);
end

function data2d = reshape2d(flat, nlat, nlon)
	data2d = reshape(flat, [nlat, nlon])';
end
