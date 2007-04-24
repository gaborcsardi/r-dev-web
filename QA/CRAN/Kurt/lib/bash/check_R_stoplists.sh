## We know that we cannot "really" install some of the packages ...
## In addition, we try not to run code in packages which call lamboot
## (Rmpi, RScaLAPACK) to something similar (rpvm?).
## We currently use '--install=fake' for these.
## Finally, checking some of the packages (CoCo, dse, ...) takes too
## long.
## <FIXME>
## As of 2006-10-16, we had
##   pkgs_install_fake_too_long="MFDA|MarkedPointProcess|RGtk2|RandVar|aod|aster|distrEx|dprep|gWidgetsRGtk2|gamlss|hoa|ks|pscl|rattle|tgp|twang"
## and thus
##   gamlss.nl gamlss.tr tsfa
## in pkgs_install_fake_cannot_run as the latter depend on something
## which takes too long.
## Timings on an Intel(R) Pentium(R) M processor 1.80GHz gave:
##
##                                   Total    User System Status
## tgp_1.1-11.tar.gz               1886.61 1860.91  25.70     OK
## aster_0.6-2.tar.gz              1142.43 1051.26  91.17     OK
## RGtk2_2.8.6.tar.gz               608.58  586.68  21.90     OK
## hoa_1.1-0.tar.gz                 590.20  580.56   9.64     OK
## dprep_1.0.tar.gz                 386.69  379.19   7.50     OK
## gamlss_1.4-0.tar.gz              336.08  330.20   5.88     OK
## ks_1.4.3.tar.gz                  303.61  298.60   5.01     OK
## gWidgetsRGtk2_0.0-7.tar.gz       127.25  124.19   3.06     OK
## distrEx_0.4-3.tar.gz             121.21  117.58   3.63     OK
## RandVar_0.4-2.tar.gz              93.70   90.92   2.78  ERROR
## MarkedPointProcess_0.2.2.tar.gz   43.84   41.40   2.44     OK
## MFDA_1.1-0.tar.gz                 42.91   41.09   1.82     OK
## aod_1.1-13.tar.gz                 41.12   39.51   1.61     OK
## rattle_2.1.57.tar.gz              31.14   29.72   1.42     OK
##
## so it seems we can try only excluding aster/pscl/tgp for the time
## being ...
pkgs_install_fake_cannot_run="BRugs|ROracle|RmSQL|RScaLAPACK|RWinEdt|Rlsf|Rmpi|httpRequest|mimR|prim|rcdd|rcom|rpvm|snowFT|snpXpert|sound|spectrino|taskPR|tcltk2|tdm|titan|wnominate|xlsReadWrite"
## Reasons:
## * clustTool (1.0) hangs the whole daily check process (most likely
##   because installing it loads Rcmdr which attempts interaction about
##   installing additional required/suggested packages.
## * titan requires interaction.
## * gamlss.nl depends on gamlss (takes too long).
## * gamlss.tr depends on gamlss (takes too long).
## * mimR depends on rcom.
## * prim depends on ks (takes too long).
## * snpXpert depends on tcltk2.
## * sound requires access to audio devices.
## * spectrino depends on rcom.
## * tcltk2 only works on Windows.
## * tdm depends on BRugs.
## * tsfa depends on dse (takes too long).
## * wnominate depends on pscl (takes too long).
## pkgs_install_fake_too_long="MFDA|MarkedPointProcess|RGtk2|RandVar|aod|aster|distrEx|dprep|gWidgetsRGtk2|gamlss|hoa|ks|pscl|rattle|tgp|twang"
pkgs_install_fake_too_long="GenABEL|RJaCGH|RQuantLib|analogue|aster|ensembleBMA|ks|np|pscl|sna|tgp|twang"
## Note that
## * RandVar depends on distrEx.
## * gWidgetsRGtk2 depends on RGtk2.
## * rattle depends on RGtk2.
## </FIXME>

## <NOTE>
## We really have a problem for check runs on beren, which take very
## close to a full day.  Try to save more time, but undo eventually ...
## Actually, it seems that also for more recent ix86 systems, we are
## getting very close to a full day now (2007-01-15).  Grrr.
case ${FQDN} in
  beren.wu-wien.ac.at)
    pkgs_install_fake_too_long="${pkgs_install_fake_too_long}|RandomFields|arules|dse|fields|svcR|feature|pvclust|mlmRev|mprobit|latentnet|plsgenomics|spatstat|ProbForecastGOP|SoPhy|verification"
    ## Note:
    ## * ProbForecastGOP and SoPhy depend on RandomFields
    ## * verification depends on fields
    ;;
  anduin.wu-wien.ac.at|aragorn.wu-wien.ac.at|eragon.wu-wien.ac.at)
    pkgs_install_fake_too_long="${pkgs_install_fake_too_long}|SpherWave|VGAM|dprep|dse|fields|glmc|hoa|mlmRev"
    ## These take too long.  Now add dependencies as well:
    pkgs_install_fake_too_long="${pkgs_install_fake_too_long}|Geneland|GeoXp|ProbForecastGOP|VDCutil|WeedMap|Zelig|rflowcyt|tsfa|verification"
    ## Note offending reverse dependencies (including Suggests):
    ## * VGAM: Zelig
    ## * Zelig: VDCutil
    ## * dse: tsfa
    ## * fields: Geneland GeoXp ProbForecastGOP SpherWave verification
    ##           WeedMap rflowcyt
    ;;
esac
## </NOTE>

pkgs_install_fake_regexp="^(${pkgs_install_fake_cannot_run}|${pkgs_install_fake_too_long})\$"

## Also, packages may depend on packages not in CRAN (e.g., in BioC or
## CRAN/Devel).  For such packages, we really have to use
## '--install=no'.  (A fake install still assumes that top-level
## require() calls can be honored.)
pkgs_install_no_regexp='^(CoCo|GOSim|GeneNT|LMGene|NORMT3|ProbeR|RBloomberg|RGrace|SAGx|SLmisc|bcp|caMassClass|lsa|pcalg|rsbml)$'
## Reasons:
## * CoCo takes "too long", but fails with --install=fake (at least on
##   when R CMD check is run from cron, as for the daily checking).
## * GOSim depends on GOstats (@BioC).
## * GeneNT depends on graph (@BioC).
## * LMGene depends on Biobase (@BioC).
## * NORMT3 keeps exploding memory on x86_64.
## * ProbeR depends on affy (@BioC).
## * RBloomberg depends on RDCOMClient (@Omegahat).
## * RGrace depends on RGtk (@Omegahat).
## * SAGx depends on Biobase (@BioC).
## * SLmisc depends on geneplotter (@BioC).
## * bcp depends on DNAcopy (@BioC).
## * caMassClass depends on PROcess (@BioC).
## * lsa depends on Rstem (@Omegahat).
## * pcalg depends on graph (@BioC).
## * rsbml depends on graph (@BioC).

## Note that packages with a non-CRAN Suggests can "fully" be tested as
## _R_CHECK_FORCE_SUGGESTS_=FALSE is used.  At some point of time, these
## packages were as follows.
## * DDHFm suggests vsn (@BioC).
## * DescribeDisplay depends on ggplot.
## * GeneNet suggests graph and Rgraphviz (@BioC).
## * GeneTS depends on GeneNet.
## * SciViews/svWidgets suggests tcltk2.
## * VDCutil depends on Zelig.
## * Zelig suggests VGAM ("nowhere").
## * accuracy suggests Zelig.
## * boolean suggests Zelig.
## * caTools suggests ROC (@BioC).
## * ggplot suggests hexbin (@BioC)
## * limma suggests vsn (@BioC).
## * proto suggests graph (@BioC).

## Also note that there are packages with examples/tests/vignettes
## taking so long that it makes the whole process take more than a day.
## Should really have separate lists for these ...

