use "$work_data/add-france-data-output.dta", clear

keep if inlist(iso, "US", "FR")
keep if inlist(substr(widcode, 1, 6), "anninc", "aptinc")
keep if p == "pall"

generate sixlet = substr(widcode, 1, 6)
generate pop = substr(widcode, 7, .)
replace pop = "992i" if (pop == "992j")

duplicates drop iso year sixlet pop, force

drop widcode currency

reshape wide value, i(iso year pop) j(sixlet) string

generate coef = valueaptinc/valueanninc
drop if missing(coef)

keep iso year coef
tempfile coef
save "`coef'"

label data "Generated by calibrate-dina.do"
use "$work_data/add-france-data-output.dta", clear

generate tochange = 1
replace tochange = 0 if !inlist(iso, "US", "FR")
replace tochange = 0 if !inlist(substr(widcode, 1, 1), "a", "t", "o") | !strpos(widcode, "in")
replace tochange = 0 if inlist(substr(widcode, 2, 1), "h", "n")
replace tochange = 0 if substr(widcode, 2, 2) == "fi"

merge n:1 iso year using "`coef'", nogenerate

replace value = value*coef if tochange

drop coef tochange

label data "Generated by calibrate-dina.do"
save "$work_data/calibrate-dina-output.dta", replace