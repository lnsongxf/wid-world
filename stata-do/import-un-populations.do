*! TB 07/07/2016

// Both sexes, all ages ----------------------------------------------------- //

import excel "$un_data/populations/wpp/unpopulationseries19502100wpp2015_pop_f01_1_total_population_both_sexes.xls", ///
	cellrange(B17) firstrow case(lower) clear

// Correct column names
foreach v of varlist f-bs {
	local year: var label `v'
	if ("`year'" == "") {
		drop `v'
	}
	else {
		rename `v' value`year'
	}
}

// Identify countries
countrycode majorarearegioncountryora, generate(iso) from("wpp")
drop variant majorarearegioncountryora notes countrycode

reshape long value, i(iso) j(year)
drop if value >= .
replace value = 1e3*value

generate age = "all"
generate sex = "both"

tempfile unpop
save "`unpop'", replace

// Both sexes, age groups --------------------------------------------------- //

import excel "$un_data/populations/wpp/WPP2015_POP_F15_1_ANNUAL_POPULATION_BY_AGE_BOTH_SEXES.xls", ///
	cellrange(B17) firstrow case(lower) clear

// Correct column names
foreach v of varlist g-ab {
	destring `v', replace ignore("…")

	local age: var label `v'
	local age = subinstr("`age'", "-", "_", 1)
	local age = subinstr("`age'", "+", "", 1)
	if ("`age'" == "") {
		drop `v'
	}
	else {
		rename `v' value`age'
	}
}

// Identify countries
countrycode majorarearegioncountryora, generate(iso) from("wpp")
drop variant majorarearegioncountryora notes countrycode

// Calculate value for 80+ when we only have the detail
replace value80 = value80_84 + value85_89 + value90_94 ///
	+ value95_99 + value100 if (value80 >= .)

// Calculate other population categories
generate valuechildren = value0_4 + value5_9 + value10_14 + value15_19
generate valueadults = value20_24 + value25_29 + value30_34 + value35_39 + ///
	value40_44 + value45_49 + value50_54 + value55_59 + value60_64 + ///
	value65_69 + value70_74 + value75_79 + value80
generate value20_39 = value20_24 + value25_29 + value30_34 + value35_39
generate value40_59 = value40_44 + value45_49 + value50_54 + value55_59
generate value60 = value60_64 + value65_69 + value70_74 + value75_79 + value80
generate value20_64 = value20_24 + value25_29 + value30_34 + value35_39 + ///
	value40_44 + value45_49 + value50_54 + value55_59 + value60_64
generate value65 = value65_69 + value70_74 + value75_79 + value80

rename referencedateasof1july year
reshape long value, i(iso year) j(age) string
drop if value >= .
replace value = 1e3*value

generate sex = "both"
	
append using "`unpop'"
save "`unpop'", replace

// Men, age groups ---------------------------------------------------------- //

import excel "$un_data/populations/wpp/WPP2015_POP_F15_2_ANNUAL_POPULATION_BY_AGE_MALE.xls", ///
	cellrange(B17) firstrow case(lower) clear

// Correct column names
foreach v of varlist g-ab {
	destring `v', replace ignore("…")

	local age: var label `v'
	local age = subinstr("`age'", "-", "_", 1)
	local age = subinstr("`age'", "+", "", 1)
	if ("`age'" == "") {
		drop `v'
	}
	else {
		rename `v' value`age'
	}
}

// Identify countries
countrycode majorarearegioncountryora, generate(iso) from("wpp")
drop variant majorarearegioncountryora notes countrycode

// Calculate value for 80+ when we only have the detail
replace value80 = value80_84 + value85_89 + value90_94 ///
	+ value95_99 + value100 if (value80 >= .)

// Calculate other population categories
generate valuechildren = value0_4 + value5_9 + value10_14 + value15_19
generate valueadults = value20_24 + value25_29 + value30_34 + value35_39 + ///
	value40_44 + value45_49 + value50_54 + value55_59 + value60_64 + ///
	value65_69 + value70_74 + value75_79 + value80
generate value20_39 = value20_24 + value25_29 + value30_34 + value35_39
generate value40_59 = value40_44 + value45_49 + value50_54 + value55_59
generate value60 = value60_64 + value65_69 + value70_74 + value75_79 + value80
generate value20_64 = value20_24 + value25_29 + value30_34 + value35_39 + ///
	value40_44 + value45_49 + value50_54 + value55_59 + value60_64
generate value65 = value65_69 + value70_74 + value75_79 + value80
generate value20_29 = value20_24 + value25_29
generate value30_39 = value30_34 + value35_39
generate value40_49 = value40_44 + value45_49
generate value50_59 = value50_54 + value55_59
generate value60_69 = value60_64 + value65_69
generate value70_79 = value70_74 + value75_79
generate value80_89 = value80_84 + value85_89
generate value90_99 = value90_94 + value95_99

// Generate entire men population
generate valueall = value0_4 + value5_9 + value10_14 + value15_19 + value20_24 ///
	+ value25_29 + value30_34 + value35_39 + value40_44 + value45_49 + value50_54 ///
	+ value55_59 + value60_64 + value65_69 + value70_74 + value75_79 + value80

rename referencedateasof1july year
reshape long value, i(iso year) j(age) string
drop if value >= .
replace value = 1e3*value
generate sex = "men"
	
append using "`unpop'"
save "`unpop'", replace

// Women, age groups -------------------------------------------------------- //

import excel "$un_data/populations/wpp/WPP2015_POP_F15_3_ANNUAL_POPULATION_BY_AGE_FEMALE.xls", ///
	cellrange(B17) firstrow case(lower) clear

// Correct column names
foreach v of varlist g-ab {
	destring `v', replace ignore("…")

	local age: var label `v'
	local age = subinstr("`age'", "-", "_", 1)
	local age = subinstr("`age'", "+", "", 1)
	if ("`age'" == "") {
		drop `v'
	}
	else {
		rename `v' value`age'
	}
}

// Identify countries
countrycode majorarearegioncountryora, generate(iso) from("wpp")
drop variant majorarearegioncountryora notes countrycode

// Calculate value for 80+ when we only have the detail
replace value80 = value80_84 + value85_89 + value90_94 ///
	+ value95_99 + value100 if (value80 >= .)

// Calculate other population categories
generate valuechildren = value0_4 + value5_9 + value10_14 + value15_19
generate valueadults = value20_24 + value25_29 + value30_34 + value35_39 + ///
	value40_44 + value45_49 + value50_54 + value55_59 + value60_64 + ///
	value65_69 + value70_74 + value75_79 + value80
generate value20_39 = value20_24 + value25_29 + value30_34 + value35_39
generate value40_59 = value40_44 + value45_49 + value50_54 + value55_59
generate value60 = value60_64 + value65_69 + value70_74 + value75_79 + value80
generate value20_64 = value20_24 + value25_29 + value30_34 + value35_39 + ///
	value40_44 + value45_49 + value50_54 + value55_59 + value60_64
generate value65 = value65_69 + value70_74 + value75_79 + value80
generate value20_29 = value20_24 + value25_29
generate value30_39 = value30_34 + value35_39
generate value40_49 = value40_44 + value45_49
generate value50_59 = value50_54 + value55_59
generate value60_69 = value60_64 + value65_69
generate value70_79 = value70_74 + value75_79
generate value80_89 = value80_84 + value85_89
generate value90_99 = value90_94 + value95_99

// Generate entire women population
generate valueall = value0_4 + value5_9 + value10_14 + value15_19 + value20_24 ///
	+ value25_29 + value30_34 + value35_39 + value40_44 + value45_49 + value50_54 ///
	+ value55_59 + value60_64 + value65_69 + value70_74 + value75_79 + value80

rename referencedateasof1july year
reshape long value, i(iso year) j(age) string
drop if value >= .
replace value = 1e3*value
generate sex = "women"

append using "`unpop'"
save "`unpop'", replace


// Add previsions for current year that are missing ----------------------------------------------------- //

import delimited "$un_data/populations/wpp/WPP2015_DB04_Population_By_Age_Annual.csv", ///
	delimit(",") case(lower) clear

keep if time==$pastyear

// Identify countries
countrycode location, generate(iso) from("wpp")
drop location locid varid variant midperiod sexid

// Calculate population for 80+
replace pop_80_100 = pop_80_84 + pop_85_89 + pop_90_94 + pop_95_99 + pop_100 if mi(pop_80_100)
rename pop_80_100 pop_80

// Calculate other population categories
generate pop_children = pop_0_4 + pop_5_9 + pop_10_14 + pop_15_19
generate pop_adults = pop_20_24 + pop_25_29 + pop_30_34 + pop_35_39 + ///
	pop_40_44 + pop_45_49 + pop_50_54 + pop_55_59 + pop_60_64 + ///
	pop_65_69 + pop_70_74 + pop_75_79 + pop_80
generate pop_20_39 = pop_20_24 + pop_25_29 + pop_30_34 + pop_35_39
generate pop_40_59 = pop_40_44 + pop_45_49 + pop_50_54 + pop_55_59
generate pop_60 = pop_60_64 + pop_65_69 + pop_70_74 + pop_75_79 + pop_80
generate pop_20_64 = pop_20_24 + pop_25_29 + pop_30_34 + pop_35_39 + ///
	pop_40_44 + pop_45_49 + pop_50_54 + pop_55_59 + pop_60_64
generate pop_65 = pop_65_69 + pop_70_74 + pop_75_79 + pop_80
generate pop_20_29 = pop_20_24 + pop_25_29
generate pop_30_39 = pop_30_34 + pop_35_39
generate pop_40_49 = pop_40_44 + pop_45_49
generate pop_50_59 = pop_50_54 + pop_55_59
generate pop_60_69 = pop_60_64 + pop_65_69
generate pop_70_79 = pop_70_74 + pop_75_79
generate pop_80_89 = pop_80_84 + pop_85_89
generate pop_90_99 = pop_90_94 + pop_95_99

// Generate entire population
generate pop_all = pop_0_4 + pop_5_9 + pop_10_14 + pop_15_19 + pop_20_24 ///
	+ pop_25_29 + pop_30_34 + pop_35_39 + pop_40_44 + pop_45_49 + pop_50_54 ///
	+ pop_55_59 + pop_60_64 + pop_65_69 + pop_70_74 + pop_75_79 + pop_80

reshape long pop_, i(time sex iso) j(age) string
rename pop_ value
drop if mi(value)
replace value = 1e3*value

// One should have 38 age decompositions
qui tab age
assert `r(r)'==38

// Recode and rename
rename time year
replace sex="both" if sex=="Both"
replace sex="women" if sex=="Female"
replace sex="men" if sex=="Male"

append using "`unpop'"
duplicates drop

label data "Generated by import-un-populations.do"
save "$work_data/un-population.dta", replace


