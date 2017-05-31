import excel "$wb_data/global-economic-monitor/GDP Deflator at Market Prices, LCU.xlsx", ///
	clear allstring
sxpose, clear

ds _var1, not
foreach v of varlist `r(varlist)'{
	local year = `v'[1]
	rename `v' value`year'
}
drop in 1
dropmiss, force

destring value*, replace force ignore(",")
rename _var1 country

countrycode country, generate(iso) from("wb gem")
drop country

reshape long value, i(iso) j(date) string
generate year = substr(date, 1, 4)
destring year, replace

collapse (mean) value (count) nobs=value, by(iso year)
drop if nobs != 4
drop nobs

rename value def_gem

label data "Generated by import-wb-gem-deflator.do"
save "$work_data/wb-gem-deflator.dta", replace

