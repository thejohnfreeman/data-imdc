# The year at the end of the range of data. Assume this to be the year before
# the current one.
year ?= $(shell expr $(shell date +%Y) - 1)

date := $(shell date --iso-8601)

notebook :
	poetry run jupyter notebook

data : displacements disasters

displacements-${year}.xlsx :
	curl -L \
		"https://api.idmcdb.org/api/displacement_data/xlsx?year=2008&year=${year}&range=true&ci=IDMCWSHSOLO009&filename=IDMC_Internal_Displacement_Conflict-Violence_Disasters_2008_${year}.xlsx" \
		-o $@

displacements.xlsx : displacements-${year}.xlsx
	ln -sf $^ $@

displacements : displacements.xlsx
	libreoffice --headless --convert-to csv $^ --outdir $@

disasters-${year}.xlsx :
	curl -L \
		"https://api.idmcdb.org/api/disaster_data/xlsx?year=2008&year=${year}&range=true&ci=IDMCWSHSOLO009&filename=IDMC_Internal_Displacement_Disasters_Events_2008_${year}.xlsx" \
		-o $@

disasters.xlsx : disasters-${year}.xlsx
	ln -sf $^ $@

disasters : disasters.xlsx
	libreoffice --headless --convert-to csv $^ --outdir $@
