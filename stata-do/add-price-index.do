use "$work_data/price-index.dta", clear
rename index value
generate p = "pall"
generate widcode = "inyixx999i"
tempfile priceindex
save "`priceindex'"

use "$work_data/convert-to-real-output.dta", clear
drop if (widcode == "inyixx999i") | (widcode == "icpixx999i")

append using "`priceindex'"
sort iso widcode p year

label data "Generated by add-price-index.do"
save "$work_data/add-price-index-output.dta", replace
