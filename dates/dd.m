function dat = dd(year, month, day)
% dd  Matlab serial date numbers that can be used to construct daily tseries objects.
%
% Syntax
% =======
%
%     dat = dd(year, month, day)
%     dat = dd(year, month, 'end')
%     dat = dd(year, month)
%     dat = dd(year)
%
% Output arguments
% =================
%
% * `dat` [ numeric ] - IRIS serial date numbers.
%
% Input arguments
% ================
%
% * `year` [ numeric ] - year.
%
% * `month` [ numeric | char | cellstr ] - Calendar month in year; if
% missing, `month` is `1` by default; `month` can be also specified as a
% three-letter English abbreviation: `'Jan'`, `'Feb'`, ... `'Dec'`.
%
% * `day` [ numeric ] - Calendar day in month; if missing, `day` is `1` by
% default; `'end'` means the end day of the respective month.
%
% Description
% ============
%
% Example
% ========
%
%     >> d = dd(2010, 12, 3)
%     d =
%           734475
%     >> dat2str(d)
%     ans =
%         '2010-Dec-03'
%

% -IRIS Macroeconomic Modeling Toolbox
% -Copyright (c) 2007-2018 IRIS Solutions Team

%--------------------------------------------------------------------------

if nargin<2
    month = 1;
end

if ischar(month)
    month = cellstr(month);
end

if iscellstr(month)
    monthList = { 'jan', 'feb', 'mar', 'apr', 'may', 'jun', ...
                  'jul', 'aug', 'sep', 'oct', 'nov', 'dec'  };
    temp = month;
    month = nan(size(temp));
    for i = 1 : numel(month)
        month(i) = find(strncmpi(temp{i}, monthList, 3));
    end
end

% Patch Matlab bug when months are nonpositive
index = month<=0;
if any(index)
    if numel(year)==1 && numel(month)>1
        year = repmat(year, size(month));
    elseif numel(month)==1 && numel(year)>1
        month = repmat(month, size(year));
        index = repmat(index, size(year));
    end
    yearOffset = ceil(month(index)/12) - 1;
    year(index) = year(index) + yearOffset;
    month(index) = mod(month(index)-1, 12) + 1;
end

if nargin<3
    day = 1;
elseif strcmpi(day, 'end')
    day = eomday(year, month);
end

dat = datenum(year, month, day);
dat = DateWrapper(dat);

end
