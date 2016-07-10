/*
E. Lawrence project on relationship between DC and Congress

Cory Maks
George Washinton University
Using Stata 13.1

Extracting U.S. House votes about DC (Peltzman classification)
DW-NOMINATE issue codes from: http://voteview.com/dw-nominate_textfile.html
*/

*cd
use h01_113_codes_12.dta, clear

sort cong
drop if cong<50
drop var31
*drop if cong<80
*no DC bills until 80


tostring rcnum, gen(rcnum3)
gen vote="V"+rcnum3
label var vote "Roll call number (string)"



gen dc_pe=0
replace dc_pe=1 if pelt1==11
replace dc_pe=1 if pelt2==11



gen yeas=i1+i2+i3
gen nays=i4+i5+i6
gen perct_vote=yeas/(yeas+nays)



gen postGing=.
replace postGing=1 if cong>=104
replace postGing=0 if cong<104


tab dc_pe clausen
ttest perct_vote if clausen==1, by(dc_pe)
ttest perct_vote if clausen==2, by(dc_pe)
ttest perct_vote if clausen==4, by(dc_pe)
ttest perct_vote if clausen==1 & dc_pe==1, by(postGing)
ttest perct_vote if clausen==2 & dc_pe==1, by(postGing)
ttest perct_vote if clausen==4 & dc_pe==1, by(postGing)


foreach n of numlist 50/112{
	list vote if dc_pe==1 & cong==`n', clean noobs
	}
