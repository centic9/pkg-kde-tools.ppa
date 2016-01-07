# Fill a kde-l10n:all substvar for all packages, allowing an easy Breaks/Replaces when KF5 packages ship translations files anew
# l10npkgs_firstversion_ok, if it exists, MUST contain the first fixed version of src:kde-l10n (4:5 for example)

l10npkgs_pkgs := $(shell dh_listpackages)
l10npkgs_subst_hooks := $(foreach t,binary-indep binary-arch binary,pre_$(t)_dh_gencontrol)

ifneq (,$(l10npkgs_firstversion_ok))

l10npkgs_prefix := kde-l10n
l10npkgs_fixed_version_comma := (<< $(l10npkgs_firstversion_ok)),
l10npkgs_langs := ar bg bs ca ca-valencia cs da de el engb eo es et eu fa fi fr ga gl he hi hr hu ia id is it ja kk km ko lt lv mr nb nds nl nn pa pl pt ptbr ro ru sk sl sr sv tr ug uk wa zhcn zhtw
l10npkgs_packages_rels := $(patsubst %,$(l10npkgs_prefix)-% $(l10npkgs_fixed_version_comma),$(l10npkgs_langs))

l10npkgs_firstversion_ok:
	echo 'kde-l10n:all=$(l10npkgs_packages_rels)' | \
	    tee -a $(foreach pkg,$(l10npkgs_pkgs),debian/$(pkg).substvars) > /dev/null

$(l10npkgs_subst_hooks): l10npkgs_firstversion_ok
.PHONY: l10npkgs_firstversion_ok

endif

