*----------------------------------------------------------------------*
*
*   INCLUDE RM07MLDD for report RM07MLBD
*
*----------------------------------------------------------------------*

* correction Nov. 2006 TW                                   "n999530
* plant description should appear behind plant number but   "n999530
* nevertheless the plant description should not be vissible "n999530
* for all possible selection combinations the transaction   "n999530
* MB5L could be started for.                                "n999530

* correction Aug. 2005 MM                                   "n856424
* - the fields "entry time", "entry date", and "User" are   "n856424
*   are not filled filled for price change documents        "n856424

* MB5B improved regarding accessibilty                      "n773673
*----------------------------------------------------------------------*
* Improvements :                        Dec. 2003 MM        "n599218
* - print the page numbers                                  "n599218
* - send warning M7 393 when user deletes the initial       "n599218
*   display variant                                         "n599218
* - new categories for scope of list                        "n599218
* - enable this report to run in the webreporting mode      "n599218
*----------------------------------------------------------------------*

* representation of tied empties improved    August 2002 MM "n547170

* report RM07MLBD and its includes improved  May 2002       "n497992
* - customizing table for FI summariation                   "n497992
* - consider special gain/loss-handling of IS-OIL           "n497992
* - the length of sum fields for values was increased       "n497992
* - ignore quantity unit and currency key in working tables "n497992

*----------------------------------------------------------------------*
* report RM07MLBD and its includes improved  Nov 2001       "n451923
*----------------------------------------------------------------------*
* error for split valuation and valuated special stock      "n450764
*----------------------------------------------------------------------*
* report RM07MLBD and its includes improved  May 10th, 2001 "n400992
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
* - the length of sum fields for quantities has been increased
*   to advoid decimal overflow
*----------------------------------------------------------------------*

*------------------------ DATENTYPEN ----------------------------------*

* Typen für Sonderbestände:
TYPES: BEGIN OF MSLB_TYP,
         WERKS LIKE MSLB-WERKS,
         MATNR LIKE MSLB-MATNR,
         SOBKZ LIKE MSLB-SOBKZ,
         LBLAB LIKE MSLB-LBLAB,
         LBINS LIKE MSLB-LBINS,
         LBEIN LIKE MSLB-LBEIN,
         LBUML LIKE MSLB-LBUML.                             "1421484
ENHANCEMENT-POINT EHP605_RM07MLDD_01 SPOTS ES_RM07MLBD STATIC .
TYPES: END OF MSLB_TYP.

TYPES: BEGIN OF CMSLB_TYP.
         INCLUDE TYPE MSLB_TYP.
TYPES:   CHARG LIKE MSLB-CHARG.
TYPES: END OF CMSLB_TYP.

TYPES: BEGIN OF MSKU_TYP,
         WERKS LIKE MSKU-WERKS,
         MATNR LIKE MSKU-MATNR,
         SOBKZ LIKE MSKU-SOBKZ,
         KULAB LIKE MSKU-KULAB,
         KUINS LIKE MSKU-KUINS,
         KUEIN LIKE MSKU-KUEIN,
         KUUML LIKE MSKU-KUUML.                             "1421484
ENHANCEMENT-POINT EHP605_RM07MLDD_02 SPOTS ES_RM07MLBD STATIC .
TYPES: END OF MSKU_TYP.

TYPES: BEGIN OF CMSKU_TYP.
         INCLUDE TYPE MSKU_TYP.
TYPES:   CHARG LIKE MSKU-CHARG.
TYPES: END OF CMSKU_TYP.

TYPES: BEGIN OF MSPR_TYP,
         WERKS LIKE MSPR-WERKS,
         LGORT LIKE MSPR-LGORT,
         MATNR LIKE MSPR-MATNR,
         SOBKZ LIKE MSPR-SOBKZ,
         PRLAB LIKE MSPR-PRLAB,
         PRINS LIKE MSPR-PRINS,
         PRSPE LIKE MSPR-PRSPE,
         PREIN LIKE MSPR-PREIN.
ENHANCEMENT-POINT EHP605_RM07MLDD_03 SPOTS ES_RM07MLBD STATIC .
TYPES: END OF MSPR_TYP.

TYPES: BEGIN OF CMSPR_TYP.
         INCLUDE TYPE MSPR_TYP.
TYPES:   CHARG LIKE MSPR-CHARG.
TYPES: END OF CMSPR_TYP.
ENHANCEMENT-POINT RM07MLDD_01 SPOTS ES_RM07MLBD STATIC.

TYPES: BEGIN OF MKOL_TYP,
        WERKS LIKE MKOL-WERKS,
        LGORT LIKE MKOL-LGORT,
        MATNR LIKE MKOL-MATNR,
        SOBKZ LIKE MKOL-SOBKZ,
        SLABS LIKE MKOL-SLABS,
        SINSM LIKE MKOL-SINSM,
        SEINM LIKE MKOL-SEINM,
        SSPEM LIKE MKOL-SSPEM.
ENHANCEMENT-POINT EHP605_RM07MLDD_04 SPOTS ES_RM07MLBD STATIC .
TYPES: END OF MKOL_TYP.

TYPES: BEGIN OF CMKOL_TYP.
         INCLUDE TYPE MKOL_TYP.
TYPES:   CHARG LIKE MKOL-CHARG.
TYPES: END OF CMKOL_TYP.

TYPES: BEGIN OF MSKA_TYP,
        WERKS LIKE MSKA-WERKS,
        LGORT LIKE MSKA-LGORT,
        MATNR LIKE MSKA-MATNR,
        SOBKZ LIKE MSKA-SOBKZ,
        KALAB LIKE MSKA-KALAB,
        KAINS LIKE MSKA-KAINS,
        KASPE LIKE MSKA-KASPE,
        KAEIN LIKE MSKA-KAEIN.
ENHANCEMENT-POINT EHP605_RM07MLDD_05 SPOTS ES_RM07MLBD STATIC .
TYPES: END OF MSKA_TYP.

TYPES: BEGIN OF CMSKA_TYP.
         INCLUDE TYPE MSKA_TYP.
TYPES:   CHARG LIKE MSKA-CHARG.
TYPES: END OF CMSKA_TYP.

*------------------------- TABELLEN -----------------------------------*

TABLES:  BKPF,                 "Buchhaltungsbelegkopf
         BSIM,                 "Buchhaltungsbelege
         MAKT,                 "Materialkurztext
         MARA,                 "allg. zum Material
         MARD,                 "Materialbestände auf Lagerortebene
         MCHB,                 "Chargenbestände auf Lagerortebene
         MCHA,                                                   "134317
         MBEW,                 "Bewertungssegment
         EBEW,                 "bewerteter Sonderbestand 'E'
         QBEW,                 "bewerteter Sonderbestand 'Q'
         MKOL,                 "Sonderbestand Lieferantenkonsignation
         MKPF,                 "Materialbelegköpfe
         MSEG,                 "Materialbelege
         MSKA,                 "Auftragsbestand
         MSKU,                 "Sonderbestand Kundenkonsignation
         MSLB,                 "Sonderbestand Lohnbearbeitung
         MSPR,                 "Projektbestand
         RPGRI,                "Texttabelle Gruppierung Bewegungsarten
         T001,                 "Prüftabelle Buchungskreise
         T001K,                "Prüftabelle Bewertungskreise
         T001W,                "Prüftabelle Werke
         T001L,                "Prüftabelle Lagerorte
         T134M,                "Prüftabelle Materialart
         T156M,                "Mengenstrings
         T156S,                "Bewegungsarten
         TCURM,                "Bewertungskreisebene
         BSEG,
         ACCHD.

* for checking the FI summarization                        "n497992
tables : ttypv,     "customizing table FI summarization    "n497992
         ttypvx.    "customizing table FI summarization    "2197941

tables : SSCRFIELDS. "for the definition of pushbuttons    "n599218

*-------------------- DATENDEKLARATIONEN ------------------------------*

DATA: IT001   TYPE IMREP_T001_TYP      OCCURS 0 WITH HEADER LINE.
DATA: IT001K  TYPE IMREP_T001K_TYP     OCCURS 0 WITH HEADER LINE.
DATA: IT001W  TYPE IMREP_T001W_TYP     OCCURS 0 WITH HEADER LINE.
DATA: IT001L  TYPE IMREP_T001L_TYP     OCCURS 0 WITH HEADER LINE.
DATA: ORGAN   TYPE IMREP_ORGAN_TYP     OCCURS 0 WITH HEADER LINE.
DATA: HEADER  TYPE IMREP_MATHEADER_TYP OCCURS 0 WITH HEADER LINE.

*------------------------ Prüftabellen --------------------------------*

DATA: BEGIN OF IT134M OCCURS 100,
        BWKEY LIKE T134M-BWKEY,
        MTART LIKE T134M-MTART,
        MENGU LIKE T134M-MENGU,
        WERTU LIKE T134M-WERTU,
      END OF IT134M.

DATA: BEGIN OF IT156 OCCURS 100,
        BWART LIKE T156S-BWART,
        WERTU LIKE T156S-WERTU,
        MENGU LIKE T156S-MENGU,
        SOBKZ LIKE T156S-SOBKZ,
        KZBEW LIKE T156S-KZBEW,
        KZZUG LIKE T156S-KZZUG,
        KZVBR LIKE T156S-KZVBR,
        BUSTM LIKE T156S-BUSTM,
        BUSTW LIKE T156S-BUSTW,                                  "147374
        LBBSA LIKE T156M-LBBSA,
        BWAGR like t156s-BWAGR,
      END OF IT156.

DATA: BEGIN OF IT156W OCCURS 100,                                "149448
        BUSTW LIKE T156W-BUSTW,                                  "149448
        XBGBB LIKE T156W-XBGBB,                                  "149448
      END OF IT156W.                                             "149448

DATA: BEGIN OF IT156X OCCURS 100,
        BUSTM LIKE T156S-BUSTM,
        LBBSA LIKE T156M-LBBSA,
      END OF IT156X.

*--------------- übergeordnete Materialtabellen -----------------------*

* working table with material short texts / contains only   "n451923
* the necessary fields                                      "n451923
TYPES : BEGIN OF STYPE_MAKT,                                "n451923
           MATNR             LIKE      MAKT-MATNR,          "n451923
           MAKTX             LIKE      MAKT-MAKTX,          "n451923
        END OF STYPE_MAKT,                                  "n451923
                                                            "n451923
        STAB_MAKT            TYPE STANDARD TABLE OF         "n451923
                             STYPE_MAKT WITH DEFAULT KEY.   "n451923
                                                            "n451923
DATA : G_S_MAKT              TYPE  STYPE_MAKT,              "n451923
       G_T_MAKT              TYPE  STAB_MAKT.               "n451923

DATA: BEGIN OF IMARA OCCURS 100,
        MATNR LIKE MARA-MATNR,
        MEINS LIKE MARA-MEINS,
        MTART LIKE MARA-MTART.
ENHANCEMENT-POINT EHP605_RM07MLDD_06 SPOTS ES_RM07MLBD STATIC .
DATA: END OF IMARA.

* definition of working area for valuation tables improved  "n450764
TYPES : BEGIN OF STYPE_MBEW,                                "n450764
          MATNR              LIKE      MBEW-MATNR,          "n450764
          BWKEY              LIKE      MBEW-BWKEY,          "n450764
          BWTAR              LIKE      MBEW-BWTAR,          "n450764
          LBKUM(09)          TYPE P    DECIMALS 3,          "n450764
          SALK3(09)          TYPE P    DECIMALS 2,          "n450764
          MEINS              LIKE      MARA-MEINS,          "n450764
          WAERS              LIKE      T001-WAERS,          "n450764
          BWTTY              LIKE      MBEW-BWTTY,          "n1227439
        END OF STYPE_MBEW,                                  "n450764
                                                            "n450764
        STAB_MBEW            TYPE STANDARD TABLE OF         "n450764
                             STYPE_MBEW WITH DEFAULT KEY.   "n450764
                                                            "n450764
DATA: G_S_MBEW               TYPE  STYPE_MBEW,              "n450764
      G_T_MBEW               TYPE  STAB_MBEW.               "n450764

DATA: BEGIN OF IMCHA OCCURS 100,                               "n1404822
        MATNR LIKE MCHA-MATNR,                                 "n1404822
        WERKS LIKE MCHA-WERKS,                                 "n1404822
        CHARG LIKE MCHA-CHARG,                                 "n1404822
      END OF IMCHA.

TYPES : BEGIN OF STYPE_ACCDET,
          MBLNR       LIKE MSEG-MBLNR,
          MJAHR       LIKE MSEG-MJAHR,
          ZEILE       LIKE MSEG-ZEILE,
          MATNR       LIKE MSEG-MATNR,
          WERKS       LIKE MSEG-WERKS,
          BUKRS       LIKE MSEG-BUKRS,
          KTOPL       LIKE T001-KTOPL,
          BWKEY       LIKE T001W-BWKEY,
          BWMOD       LIKE T001K-BWMOD,
          BWTAR       LIKE MSEG-BWTAR,
          SOBKZ       LIKE MSEG-SOBKZ,
          KZBWS       LIKE MSEG-KZBWS,
          XOBEW       LIKE MSEG-XOBEW,
          MAT_PSPNR   LIKE MSEG-MAT_PSPNR,
          MAT_KDAUF   LIKE MSEG-MAT_KDAUF,
          MAT_KDPOS   LIKE MSEG-MAT_KDPOS,
          LIFNR       LIKE MSEG-LIFNR,
          BKLAS       LIKE MBEW-BKLAS,
          HKONT       LIKE BSEG-HKONT,
        END OF STYPE_ACCDET.

*--------------- Materialtabellen auf Lagerortebene -------------------*

DATA: BEGIN OF IMARD OCCURS 100,    "aktueller Materialbestand
        WERKS LIKE MARD-WERKS,      "Werk
        MATNR LIKE MARD-MATNR,      "Material
        LGORT LIKE MARD-LGORT,      "Lagerort
        LABST LIKE MARD-LABST,      "frei verwendbarer Bestand
        UMLME LIKE MARD-UMLME,      "Umlagerungsbestand
        INSME LIKE MARD-INSME,      "Qualitätsprüfbestand
        EINME LIKE MARD-EINME,      "nicht frei verwendbarer Bestand
        SPEME LIKE MARD-SPEME,      "gesperrter Bestand
        RETME LIKE MARD-RETME,      "gesperrter Bestand
        KLABS LIKE MARD-KLABS,      "frei verw. Konsignationsbestand
        LBKUM LIKE MBEW-LBKUM,      "bewerteter Bestand
        SALK3(09)            TYPE P    DECIMALS 2,          "n497992
        WAERS LIKE T001-WAERS.      "Währungseinheit
ENHANCEMENT-POINT EHP605_RM07MLDD_07 SPOTS ES_RM07MLBD STATIC .
DATA: END OF IMARD.

DATA: BEGIN OF IMCHB OCCURS 100,    "aktueller Chargenbestand
        WERKS LIKE MCHB-WERKS,
        MATNR LIKE MCHB-MATNR,
        LGORT LIKE MCHB-LGORT,
        CHARG LIKE MCHB-CHARG,
        CLABS LIKE MCHB-CLABS,      "frei verwendbarer Chargenbestand
        CUMLM LIKE MCHB-CUMLM,      "Umlagerungsbestand
        CINSM LIKE MCHB-CINSM,      "Qualitätsprüfbestand
        CEINM LIKE MCHB-CEINM,      "nicht frei verwendbarer Bestand
        CSPEM LIKE MCHB-CSPEM,      "gesperrter Bestand
        CRETM LIKE MCHB-CRETM.      "gesperrter Bestand
ENHANCEMENT-POINT EHP605_RM07MLDD_08 SPOTS ES_RM07MLBD STATIC .
DATA: END OF IMCHB.

*-------------------------- Sonderbestände ----------------------------*

DATA: XMSLB  TYPE CMSLB_TYP OCCURS 0 WITH HEADER LINE.
DATA: IMSLB  TYPE CMSLB_TYP OCCURS 0 WITH HEADER LINE.
DATA: IMSLBX TYPE MSLB_TYP  OCCURS 0 WITH HEADER LINE.

DATA: XMSKU  TYPE CMSKU_TYP OCCURS 0 WITH HEADER LINE.
DATA: IMSKU  TYPE CMSKU_TYP OCCURS 0 WITH HEADER LINE.
DATA: IMSKUX TYPE MSKU_TYP  OCCURS 0 WITH HEADER LINE.

DATA: XMSPR  TYPE CMSPR_TYP OCCURS 0 WITH HEADER LINE.
DATA: IMSPR  TYPE CMSPR_TYP OCCURS 0 WITH HEADER LINE.
DATA: IMSPRX TYPE MSPR_TYP  OCCURS 0 WITH HEADER LINE.

DATA: XMKOL  TYPE CMKOL_TYP OCCURS 0 WITH HEADER LINE.
DATA: IMKOL  TYPE CMKOL_TYP OCCURS 0 WITH HEADER LINE.
DATA: IMKOLX TYPE MKOL_TYP  OCCURS 0 WITH HEADER LINE.

DATA: XMSKA  TYPE CMSKA_TYP OCCURS 0 WITH HEADER LINE.
DATA: IMSKA  TYPE CMSKA_TYP OCCURS 0 WITH HEADER LINE.
DATA: IMSKAX TYPE MSKA_TYP  OCCURS 0 WITH HEADER LINE.

* global working table for the FI doc headers BKPF          "n856424
types : BEGIN OF stype_bkpf,                                "n856424
          bukrs              LIKE  bkpf-bukrs,              "n856424
          belnr              LIKE  bkpf-belnr,              "n856424
          gjahr              LIKE  bkpf-gjahr,              "n856424
          blart              LIKE  bkpf-blart,              "n856424
          budat              LIKE  bkpf-budat,              "n856424
          awkey              LIKE  bkpf-awkey,              "n856424
          cpudt              like  bkpf-cpudt,              "n856424
          cputm              like  bkpf-cputm,              "n856424
          usnam              like  bkpf-usnam,              "n856424
          awtyp              like  bkpf-awtyp,              "n856424
        END OF stype_bkpf.                                  "n856424
                                                            "n856424
* global working table for the FI doc items BSEG
types : BEGIN OF stype_bseg,
          bukrs              LIKE  bseg-bukrs,
          belnr              LIKE  bseg-belnr,
          gjahr              LIKE  bseg-gjahr,
          buzei              LIKE  bseg-buzei,
          hkont              LIKE  bseg-hkont,
        END OF stype_bseg.

field-symbols : <g_fs_bkpf>  type  stype_bkpf.              "n856424
                                                            "n856424
data : g_t_bkpf    type  hashed table of stype_bkpf         "n856424
                         with unique key bukrs belnr gjahr. "n856424
data : g_t_bseg    type  hashed table of stype_bseg
                         with unique key bukrs belnr gjahr buzei.

*--------------- Summations- und Bestandstabellen ---------------------*

DATA: BEGIN OF BESTAND OCCURS 100,
        BWKEY LIKE MBEW-BWKEY,
        WERKS LIKE MSEG-WERKS,
        MATNR LIKE MSEG-MATNR,
        CHARG LIKE MSEG-CHARG,
*(DEL)  endmenge like mard-labst,          "Bestand zu 'datum-high' XJD
        ENDMENGE(09) TYPE P DECIMALS 3,    "Bestand zu 'datum-high' XJD
*(DEL)  anfmenge like mard-labst,          "Bestand zu 'datum-low'  XJD
        ANFMENGE(09) TYPE P DECIMALS 3,   "Bestand zu 'datum-low'   XJD
        MEINS LIKE MARA-MEINS,             "Mengeneinheit
*       values at date-low and date-high                    "n497992
        endwert(09)          TYPE P    DECIMALS 2,          "n497992
        anfwert(09)          TYPE P    DECIMALS 2,          "n497992

*(DEL)  soll  like mseg-menge,                                     "XJD
        SOLL(09) TYPE P DECIMALS 3,                                "XJD
*(DEL)  haben like mseg-menge,                                     "XJD
        HABEN(09) TYPE P DECIMALS 3,                               "XJD
        SOLLWERT(09)         TYPE P    DECIMALS 2,          "n497992
        HABENWERT(09)        TYPE P    DECIMALS 2,          "n497992
        WAERS LIKE T001-WAERS.             "Währungsschlüssel
ENHANCEMENT-POINT RM07MLDD_02 SPOTS ES_RM07MLBD STATIC.
DATA:
      END OF BESTAND.

DATA: BEGIN OF BESTAND1 OCCURS 100,
        BWKEY LIKE MBEW-BWKEY,
        WERKS LIKE MSEG-WERKS,
        MATNR LIKE MSEG-MATNR,
        CHARG LIKE MSEG-CHARG,
*(DEL)  endmenge like mard-labst,          "Bestand zu 'datum-high' XJD
        ENDMENGE(09) TYPE P DECIMALS 3,    "Bestand zu 'datum-high' XJD
*(DEL)  anfmenge like mard-labst,          "Bestand zu 'datum-low'  XJD
        ANFMENGE(09) TYPE P DECIMALS 3,    "Bestand zu 'datum-low'  XJD
        MEINS LIKE MARA-MEINS,             "Mengeneinheit
        ENDWERT(09)          TYPE P    DECIMALS 2,          "n497992
        ANFWERT(09)          TYPE P    DECIMALS 2,          "n497992
*(DEL)  soll  like mseg-menge,                                     "XJD
        SOLL(09) TYPE P DECIMALS 3,                                "XJD
*(DEL)  haben like mseg-menge,                                     "XJD
        HABEN(09) TYPE P DECIMALS 3,                               "XJD
        SOLLWERT(09)         TYPE P    DECIMALS 2,          "n497992
        HABENWERT(09)        TYPE P    DECIMALS 2,          "n497992
        WAERS LIKE T001-WAERS.             "Währungsschlüssel
ENHANCEMENT-POINT EHP605_RM07MLDD_09 SPOTS ES_RM07MLBD STATIC .
DATA: END OF BESTAND1.

DATA: BEGIN OF SUM_MAT OCCURS 100,
        WERKS LIKE MSEG-WERKS,
        MATNR LIKE MSEG-MATNR,
        SHKZG LIKE MSEG-SHKZG,
        MENGE(09) TYPE P DECIMALS 3.                               "XJD
ENHANCEMENT-POINT EHP605_RM07MLDD_10 SPOTS ES_RM07MLBD STATIC .
DATA: END OF SUM_MAT.

TYPES: BEGIN OF TY_SUM_CHAR,                                   "2296009
        WERKS LIKE MSEG-WERKS,
        MATNR LIKE MSEG-MATNR,
        CHARG LIKE MSEG-CHARG,
        SHKZG LIKE MSEG-SHKZG,
        MENGE(09) TYPE P DECIMALS 3.                               "XJD
ENHANCEMENT-POINT EHP605_RM07MLDD_11 SPOTS ES_RM07MLBD STATIC .
TYPES: END OF TY_SUM_CHAR.                                     "2296009

TYPES TTY_SUM_CHAR TYPE SORTED TABLE OF TY_SUM_CHAR            "2296009
      WITH UNIQUE KEY WERKS MATNR CHARG SHKZG.                 "2296009

DATA: SUM_CHAR TYPE TTY_SUM_CHAR WITH HEADER LINE.             "2296009

DATA: BEGIN OF WEG_MAT OCCURS 100,
        WERKS LIKE MSEG-WERKS,
        LGORT LIKE MSEG-LGORT,                             " P30K140665
        MATNR LIKE MSEG-MATNR,
        SHKZG LIKE MSEG-SHKZG,
        MENGE(09) TYPE P DECIMALS 3.                               "XJD
ENHANCEMENT-POINT EHP605_RM07MLDD_12 SPOTS ES_RM07MLBD STATIC .
DATA: END OF WEG_MAT.

TYPES: BEGIN OF TY_WEG_CHAR,                                   "2296009
        WERKS LIKE MSEG-WERKS,
        MATNR LIKE MSEG-MATNR,
        LGORT LIKE MSEG-LGORT,                             " P30K140665
        CHARG LIKE MSEG-CHARG,
        SHKZG LIKE MSEG-SHKZG,
        MENGE(09) TYPE P DECIMALS 3.                               "XJD
ENHANCEMENT-POINT EHP605_RM07MLDD_13 SPOTS ES_RM07MLBD STATIC .
TYPES: END OF TY_WEG_CHAR.                                     "2296009

TYPES TTY_WEG_CHAR TYPE SORTED TABLE OF TY_WEG_CHAR            "2296009
      WITH UNIQUE KEY WERKS MATNR LGORT CHARG SHKZG.           "2296009

DATA: WEG_CHAR TYPE TTY_WEG_CHAR WITH HEADER LINE.             "2296009

DATA: BEGIN OF MAT_SUM OCCURS 100,
        BWKEY LIKE MBEW-BWKEY,
        WERKS LIKE MSEG-WERKS,
        MATNR LIKE MSEG-MATNR,
        SHKZG LIKE MSEG-SHKZG,
        MENGE(09) TYPE P DECIMALS 3,                               "XJD
        DMBTR(09)            type p    decimals 3.          "n497992
ENHANCEMENT-POINT EHP605_RM07MLDD_14 SPOTS ES_RM07MLBD STATIC .
DATA: END OF MAT_SUM.

DATA: BEGIN OF MAT_SUM_BUK OCCURS 100,
        BWKEY LIKE MBEW-BWKEY,
        MATNR LIKE MSEG-MATNR,
        SHKZG LIKE MSEG-SHKZG,
        MENGE(09) TYPE P DECIMALS 3,                               "XJD
        DMBTR(09)            type p    decimals 3.          "n497992
ENHANCEMENT-POINT EHP605_RM07MLDD_15 SPOTS ES_RM07MLBD STATIC .
DATA: END OF MAT_SUM_BUK.

DATA: BEGIN OF MAT_WEG OCCURS 100,
        BWKEY LIKE MBEW-BWKEY,
        WERKS LIKE MSEG-WERKS,
        MATNR LIKE MSEG-MATNR,
        SHKZG LIKE MSEG-SHKZG,
        MENGE(09) TYPE P DECIMALS 3,                               "XJD
        DMBTR(09)            type p    decimals 3.          "n497992
ENHANCEMENT-POINT EHP605_RM07MLDD_16 SPOTS ES_RM07MLBD STATIC .
DATA: END OF MAT_WEG.

DATA: BEGIN OF MAT_WEG_BUK OCCURS 100,
        BWKEY LIKE MBEW-BWKEY,
        MATNR LIKE MSEG-MATNR,
        SHKZG LIKE MSEG-SHKZG,
        MENGE(09) TYPE P DECIMALS 3,                               "XJD
        DMBTR(09)            type p    decimals 3.          "n497992
ENHANCEMENT-POINT EHP605_RM07MLDD_17 SPOTS ES_RM07MLBD STATIC .
DATA: END OF MAT_WEG_BUK.

*----------------------- Feldleisten ----------------------------------*

DATA: BEGIN OF LEISTE,
        WERKS LIKE MSEG-WERKS,
        BWKEY LIKE MBEW-BWKEY,
        MATNR LIKE MSEG-MATNR,
        CHARG LIKE MSEG-CHARG,
      END OF LEISTE.

*------------------------ Hilfsfelder ---------------------------------*

DATA: CURM LIKE TCURM-BWKRS_CUS,
      BUKR LIKE T001-BUKRS,
      BWKR LIKE T001K-BWKEY,
      WERK LIKE T001W-WERKS,
      NAME LIKE T001W-NAME1,
      LORT LIKE T001L-LGORT,
      WAER LIKE T001-WAERS,
      INDEX_0 LIKE SY-TABIX,
      INDEX_1 LIKE SY-TABIX,
      INDEX_2 LIKE SY-TABIX,
      INDEX_3 LIKE SY-TABIX,
      INDEX_4 LIKE SY-TABIX,
      AKTDAT LIKE SY-DATLO,
      SORTFIELD(30),
      MATERIAL(30),

      new_BWAGR like t156s-BWAGR,
      old_BWAGR like t156s-BWAGR,
      LEER(1) TYPE C,
      COUNTER LIKE SY-TABIX,
      INHALT(10) TYPE N.

DATA: JAHRLOW(4) TYPE C,
      MONATLOW(2) TYPE C,
      TAGLOW(2) TYPE C,
      JAHRHIGH(4) TYPE C,
      MONATHIGH(2) TYPE C,
      TAGHIGH(2) TYPE C.

* zur Berechtigungsprüfung:
DATA ACTVT03 LIKE TACT-ACTVT VALUE '03'.         "anzeigen

*-------------------- FELDER FÜR LISTVIEWER ---------------------------*

DATA: REPID      LIKE SY-REPID.
DATA: FIELDCAT   TYPE SLIS_T_FIELDCAT_ALV.
DATA: XHEADER    TYPE SLIS_T_LISTHEADER WITH HEADER LINE.
DATA: KEYINFO    TYPE SLIS_KEYINFO_ALV.
DATA: COLOR      TYPE SLIS_T_SPECIALCOL_ALV WITH HEADER LINE.
DATA: LAYOUT     TYPE SLIS_LAYOUT_ALV.
DATA: EVENTS     TYPE SLIS_T_EVENT WITH HEADER LINE.
DATA: EVENT_EXIT TYPE SLIS_T_EVENT_EXIT WITH HEADER LINE.
DATA: SORTTAB    TYPE SLIS_T_SORTINFO_ALV WITH HEADER LINE.
DATA: FILTTAB    TYPE SLIS_T_FILTER_ALV WITH HEADER LINE.
*data: extab      type slis_t_extab with header line.              "XJD

* Listanzeigevarianten
DATA: VARIANTE        LIKE DISVARIANT,                " Anzeigevariante
      DEF_VARIANTE    LIKE DISVARIANT,                " Defaultvariante
      VARIANT_EXIT(1) TYPE C,
      VARIANT_SAVE(1) TYPE C,
      VARIANT_DEF(1)  TYPE C.

* save the name of the default display variant              "n599218
data: alv_default_variant    like  disvariant-variant.      "n599218

* Gruppen Positionsfelder
DATA: GRUPPEN TYPE SLIS_T_SP_GROUP_ALV WITH HEADER LINE.

* structure for print ALV print parameters
DATA: G_S_PRINT              TYPE      SLIS_PRINT_ALV.

*----------------------------------------------------------------------*

* working area : get the field names of a structure
type-pools : sydes.

data : g_t_td                type      sydes_desc,
       g_s_typeinfo          type      sydes_typeinfo,
       g_s_nameinfo          type      sydes_nameinfo.

* new definitions for table organ
types : begin of stype_organ,
          keytype(01)        type c,
          keyfield           like      t001w-werks,
          bwkey              like      t001k-bwkey,
          werks              like      t001w-werks,
          bukrs              like      t001-bukrs,
          ktopl              like      t001-ktopl,
          bwmod              like      t001k-bwmod,
          waers              like      t001-waers,
        end of stype_organ,

        stab_organ           type standard table of stype_organ
                             with key keytype keyfield bwkey werks.

data : g_s_organ             type      stype_organ,
       g_t_organ             type      stab_organ
                                       with header line.

* buffer table for check authority for plants
types : begin of stype_auth_plant,
           werks             like      mseg-werks,
           ok(01)            type c,
        end of stype_auth_plant.

types : stab_auth_plant      type standard table of
                             stype_auth_plant with key werks.
data : g_t_auth_plant        type stab_auth_plant with header line.

* for the assignment of the MM and FI documents             "n443935
types : begin of stype_bsim_lean,                           "n443935
          bukrs like bkpf-bukrs,                            "n443935
          bwkey like bsim-bwkey,                            "n443935
          matnr like bsim-matnr,                            "n443935
          bwtar like bsim-bwtar,                            "n443935
          shkzg like bsim-shkzg,                            "n443935
          meins like bsim-meins,                            "n443935
          budat like bsim-budat,                            "n443935
          blart like bsim-blart,                            "n443935
          buzei              like      bsim-buzei,          "n497992
                                                            "n443935
          awkey like bkpf-awkey,                            "n443935
          belnr like bsim-belnr,                            "n443935
          gjahr like bsim-gjahr,                            "n443935
          menge like bsim-menge,                            "n443935
          dmbtr like bsim-dmbtr,                            "n443935
          accessed           type c,                        "n443935
          tabix              like  sy-tabix,                "n443935
        end of stype_bsim_lean,                             "n443935
                                                            "n443935
        stab_bsim_lean       type standard table of         "n443935
                             stype_bsim_lean                "n443935
                             with default key.              "n443935

data : g_t_bsim_lean         type  stab_bsim_lean,          "n443935
       g_s_bsim_lean         type  stype_bsim_lean,         "n443935
       g_t_bsim_work         type  stab_bsim_lean,          "n443935
       g_s_bsim_work         type  stype_bsim_lean.         "n443935

* for the control break                                     "n443935
types : begin of stype_mseg_group,                          "n443935
          mblnr              like  mkpf-mblnr,              "n443935
          mjahr              like  mkpf-mjahr,              "n443935
          bukrs              like  bkpf-bukrs,              "n443935
          bwkey              like  bsim-bwkey,              "n443935
          matnr              like  mseg-matnr,              "n443935
          bwtar              like  mseg-bwtar,              "n443935
          shkzg              like  mseg-shkzg,              "n443935
          meins              like  mseg-meins,              "n443935
          budat              like  mkpf-budat,              "n443935
          blart              like  mkpf-blart,              "n443935
        end of stype_mseg_group.                            "n443935
                                                            "n443935
data : g_s_mseg_old          type  stype_mseg_group,        "n443935
       G_S_MSEG_NEW          TYPE  STYPE_MSEG_GROUP.        "n443935
                                                            "n443935
* Structure to separate AWKEY into MBLNR/MJAHR in a         "n443935
* clean way.                                                "n443935
  data: begin of matkey,                                    "n443935
          mblnr like mkpf-mblnr,                            "n443935
          mjahr like mkpf-mjahr,                            "n443935
        end of matkey.                                      "n443935

* global contants
constants : c_space(01)      type c    value ' ',
            c_bwkey(01)      type c    value 'B',
            c_error(01)      type c    value 'E',
            c_no_error(01)   type c    value 'N',
            c_werks(01)      type c    value 'W',
            c_no_space(01)   type c    value 'N',
            c_space_only(01) type c    value 'S',
            c_tilde(01)      type c    value '~',
            c_check(01)      type c    value 'C',
            c_take(01)       type c    value 'T',
            c_out(01)        type c    value c_space,
            c_no_out(01)     type c    value 'X'.

* for the use of the pushbutton                             "n599218
constants : c_show(01)       TYPE C    VALUE 'S',           "n599218
            C_hide(01)       TYPE C    VALUE 'H'.           "n599218

* for the field catalog
data : g_s_fieldcat          type      slis_fieldcat_alv,
       g_f_tabname           type      slis_tabname,
       g_f_col_pos           type i.

* global used fields
data : g_flag_delete(01)     type c,
       g_flag_authority(01)  type c,
       g_f_cnt_lines         type i,
       g_f_cnt_lines_bukrs   type i,
       g_f_cnt_lines_werks   type i,
       g_f_cnt_before        type i,
       g_f_cnt_after         type i.

* working fields for the headlines and page numbers         "n599218
data : g_f_cnt_bestand_total type i,                        "n599218
       g_f_cnt_bestand_curr  type i.                        "n599218
                                                            "n599218
data : begin of g_s_header_77,                              "n599218
           date(10)          type c,                        "n599218
           filler_01(01)     type c,                        "n599218
           title(59)         type c,                        "n599218
           filler_02(01)     type c,                        "n599218
           page(06)          type c,                        "n599218
       end of g_s_header_77,                                "n599218
                                                            "n599218
       begin of g_s_header_91,                              "n599218
           date(10)          type c,                        "n599218
           filler_01(01)     type c,                        "n599218
           title(73)         type c,                        "n599218
           filler_02(01)     type c,                        "n599218
           page(06)          type c,                        "n599218
       end of g_s_header_91.                                "n599218
                                                            "n599218
data : g_end_line_77(77)     type c,                        "n599218
       g_end_line_91(91)     type c.                        "n599218
                                                            "n599218
* for the scope of list                                     "n599218
data : g_cnt_empty_parameter type i.                        "n599218
data : g_flag_status_liu(01) type c    value 'H'.           "n599218
                                                            "n599218
* flag to be set when INITIALIZATION was processed          "n599218
data g_flag_initialization(01) type c.                      "n599218
                                                            "n599218
* flag for activate ALV ivterface check                     "n599218
data g_flag_i_check(01)      type c.                        "n599218

data : g_f_bwkey             like  mbew-bwkey,              "n443935
       g_f_tabix             like  sy-tabix,                "n443935
       g_f_tabix_start       like  sy-tabix,                "n443935
       g_cnt_loop            like  sy-tabix,                "n443935
       g_cnt_mseg_entries    like  sy-tabix,                "n443935
       g_cnt_bsim_entries    like  sy-tabix,                "n443935
       g_cnt_mseg_done       like  sy-tabix.                "n443935

* for the processing of tied empties                        "n497992
data : g_f_werks_retail      like      t001w-werks.         "n497992

* reference procedures for checking FI summarization        "n497992
ranges : g_ra_awtyp          for  ttypv-awtyp,              "n497992
         g_ra_bukrs          for  ttypvx-bukrs.             "2197941

* global range tables for the database selection
ranges : g_ra_bwkey          for t001k-bwkey,    "valuation area
         g_ra_werks          for t001w-werks,    "plant
         g_ra_sobkz          for mseg-sobkz,     "special st. ind.
         g_ra_lgort          for mseg-lgort.     "storage location

* global range tables for the creation of table g_t_organ
ranges : g_0000_ra_bwkey     for t001k-bwkey,    "valuation area
         g_0000_ra_werks     for t001w-werks,    "plant
         g_0000_ra_bukrs     for t001-bukrs.     "company code

* internal range for valuation class restriction
ranges : iBKLAS     for MBEW-BKLAS.

* global table with the material numbers as key for reading MAKT
types : begin of stype_mat_key,
          matnr              like      mara-matnr,
        end of   stype_mat_key.

types : stab_mat_key         type standard table of stype_mat_key
                             with key matnr.

data: g_t_mat_key            type      stab_mat_key
                             with header line.

* global table with the key for the FI documents BKPF
types : begin of stype_bkpf_key,
          bukrs              like      bkpf-bukrs,
          belnr              like      bkpf-belnr,
          gjahr              like      bkpf-gjahr,
        end of   stype_bkpf_key.

* global table with the key for the FI documents BSEG
types : begin of stype_bseg_key,
          bukrs              like      bseg-bukrs,
          belnr              like      bseg-belnr,
          gjahr              like      bseg-gjahr,
          buzei              like      bseg-buzei,
        end of   stype_bseg_key.

types : stab_bkpf_key        type standard table of stype_bkpf_key
                             with key bukrs belnr gjahr.
types : stab_bseg_key        type standard table of stype_bseg_key
                             with key bukrs belnr gjahr buzei.

data: g_t_bkpf_key           type      stab_bkpf_key
                             with header line.
data: g_t_bseg_key           type      stab_bseg_key
                             with header line.

* separate time depending authorization for tax auditor     "n486477
* define working areas for time depending authority check   "n486477
data : g_f_budat             like      bsim-budat,          "n486477
       G_F_BUDAT_WORK        LIKE      BSIM-BUDAT.          "n486477
                                                            "n486477
types : begin of stype_bukrs,                               "n486477
          bukrs              like      t001-bukrs,          "n486477
        end of stype_bukrs,                                 "n486477
                                                            "n486477
        stab_bukrs           type standard table of         "n486477
                             stype_bukrs with default key.  "n486477
                                                            "n486477
data : g_t_bukrs             type  stab_bukrs,              "n486477
       g_s_bukrs             type  stype_bukrs.             "n486477
                                                            "n486477
TYPES : BEGIN OF STYPE_WORK,                                "n486477
          WERKS              LIKE      T001W-WERKS,         "n486477
          BWKEY              LIKE      T001K-BWKEY,         "n486477
          BUKRS              LIKE      T001-BUKRS,          "n486477
        END OF STYPE_WORK.                                  "n486477
                                                            "n486477
DATA : G_S_T001W             TYPE  STYPE_WORK,              "n486477
       G_T_T001W             TYPE  STYPE_WORK   OCCURS 0,   "n486477
       G_S_T001K             TYPE  STYPE_WORK,              "n486477
       G_T_T001K             TYPE  STYPE_WORK   OCCURS 0.   "n486477
                                                            "n486477
data : g_flag_tpcuser(01)    type c,                        "n486477
*      1 = carry out the special checks for this user       "n486477
       g_f_repid             like  sy-repid.                "n497992

* for the representation of tied empties                    "n547170
* range table for special indicators of field MSEG-XAUTO    "n547170
ranges : g_ra_xauto          for  MSEG-XAUTO.               "n547170
                                                            "n547170
data   : g_f_zeile           like  mseg-zeile.              "n547170
                                                            "n547170
types : begin of stype_mseg_xauto,                          "n547170
           mblnr             like  mseg-mblnr,              "n547170
           mjahr             like  mseg-mjahr,              "n547170
           zeile             like  mseg-zeile,              "n547170
           matnr             like  mseg-matnr,              "n547170
           xauto             like  mseg-xauto,              "n547170
        end of stype_mseg_xauto,                            "n547170
                                                            "n547170
        stab_mseg_xauto      type standard table of         "n547170
                             stype_mseg_xauto               "n547170
                             with default key.              "n547170
                                                            "n547170
* working area for the previous entry                       "n547170
data : g_s_mseg_pr           type  stype_mseg_xauto,        "n547170
                                                            "n547170
* table for the original MM doc posting lines               "n547170
       g_s_mseg_or           type  stype_mseg_xauto,        "n547170
       g_t_mseg_or           type  stab_mseg_xauto,         "n547170
                                                            "n547170
* table for the keys of the original MM doc lines           "n547170
       g_s_mseg_key          type  stype_mseg_xauto,        "n547170
       g_t_mseg_key          type  stab_mseg_xauto.         "n547170

*----------------------------------------------------------------------*
* new data definitions
*----------------------------------------------------------------------*

*   for the selection of the reversal movements only in release >=45B
      DATA: BEGIN OF STORNO OCCURS 0,
              MBLNR LIKE MSEG-MBLNR,
              MJAHR LIKE MSEG-MJAHR,
              ZEILE LIKE MSEG-ZEILE,
              SMBLN LIKE MSEG-SMBLN,
              SJAHR LIKE MSEG-SJAHR,
              SMBLP LIKE MSEG-SMBLP,
            END OF STORNO.

* working fields for reading structures from DDIC           "n599218 A
* and check whether IS-OIL is active                        "n599218 A
types : stab_x031l           type standard table of x031l   "n599218 A
                             with default key.              "n599218 A
                                                            "n599218 A
data : g_s_x031l             type x031l,                    "n599218 A
       g_t_x031l             type stab_x031l.               "n599218 A
                                                            "n599218 A
data : g_f_dcobjdef_name     like dcobjdef-name,            "n599218 A
       g_flag_is_oil_active(01)        type c,              "n599218 A
       g_cnt_is_oil          type i.                        "n599218 A

data : g_flag_found(01)      type c.

data : g_f_butxt             like  t001-butxt,
       g_f_tabname_totals    like dcobjdef-name,
       g_f_tabname_belege    like dcobjdef-name.

data : begin of g_save_params,
         werks               like  mseg-werks,
         matnr               like  mseg-MATNR,
         charg               like  mseg-charg,
         belnr               like  bseg-belnr,
         bukrs               like  bseg-bukrs,
         gjahr               like  bseg-gjahr,
       end of g_save_params.

DATA: g_t_EVENTS_totals_flat TYPE SLIS_T_EVENT WITH HEADER LINE.
DATA: EVENTS_hierseq         TYPE SLIS_T_EVENT WITH HEADER LINE.

DATA: g_t_FIELDCAT_totals_hq           TYPE SLIS_T_FIELDCAT_ALV,
      g_t_FIELDCAT_totals_flat         TYPE SLIS_T_FIELDCAT_ALV.

data: fieldcat_hierseq       TYPE SLIS_T_FIELDCAT_ALV.

DATA: g_s_keyinfo_totals_hq  TYPE slis_keyinfo_alv.

DATA: g_s_SORTTAB            TYPE SLIS_SORTINFO_ALV,
      g_t_SORTTAB            TYPE SLIS_T_SORTINFO_ALV.

DATA: g_s_SORT_totals_hq     TYPE SLIS_SORTINFO_ALV,
      g_t_SORT_totals_hq     TYPE SLIS_T_SORTINFO_ALV.

DATA: g_s_VARI_sumhq         LIKE DISVARIANT,
      g_s_VARI_sumhq_def     LIKE DISVARIANT,
      g_s_VARI_sumfl         LIKE DISVARIANT,
      g_s_VARI_sumfl_def     LIKE DISVARIANT.

* contains the a structure with the max. number of fields of
* the database table MSEG, but those lines are comment lines
* with a '*'. The customer can achtivate those lines.
* The activated fields will be selected from the database table
* and are hidden in the list. With the settings in the display
* variant the can be shown.
INCLUDE                      RM07MLBD_CUST_FIELDS.

* common types structure for working tables
* a) g_t_mseg_lean   results form database selection
* b) g_t_beleg       data table for ALV
TYPES : BEGIN OF STYPE_MSEG_LEAN,
          MBLNR             LIKE      MKPF-MBLNR,
           MJAHR             LIKE      MKPF-MJAHR,
           VGART             LIKE      MKPF-VGART,
           BLART             LIKE      MKPF-BLART,
           BUDAT             LIKE      MKPF-BUDAT,
           CPUDT             LIKE      MKPF-CPUDT,
           CPUTM             LIKE      MKPF-CPUTM,
           USNAM             LIKE      MKPF-USNAM,
* process 'goods receipt/issue slip' as hidden field        "n450596
           XABLN             LIKE      MKPF-XABLN,          "n450596

           LBBSA             LIKE      T156M-LBBSA,
           BWAGR             LIKE      T156S-BWAGR,
           BUKRS             LIKE      T001-BUKRS,

           BELNR             LIKE      BKPF-BELNR,
           GJAHR             LIKE      BKPF-GJAHR,
           BUZEI             LIKE      BSEG-BUZEI,
           HKONT             LIKE      BSEG-HKONT,

           WAERS             LIKE      MSEG-WAERS,
           ZEILE             LIKE      MSEG-ZEILE,
           BWART             LIKE      MSEG-BWART,
           MATNR             LIKE      MSEG-MATNR,
           WERKS             LIKE      MSEG-WERKS,
           LGORT             LIKE      MSEG-LGORT,
           CHARG             LIKE      MSEG-CHARG,
           BWTAR             LIKE      MSEG-BWTAR,
           KZVBR             LIKE      MSEG-KZVBR,
           KZBEW             LIKE      MSEG-KZBEW,
           SOBKZ             LIKE      MSEG-SOBKZ,
           KZZUG             LIKE      MSEG-KZZUG,
           BUSTM             LIKE      MSEG-BUSTM,
           BUSTW             LIKE      MSEG-BUSTW,
           MENGU             LIKE      MSEG-MENGU,
           WERTU             LIKE      MSEG-WERTU,
           SHKZG             LIKE      MSEG-SHKZG,
           MENGE             LIKE      MSEG-MENGE,
           MEINS             LIKE      MSEG-MEINS,
           DMBTR             LIKE      MSEG-DMBTR,
           DMBUM             LIKE      MSEG-DMBUM,
           XAUTO             LIKE      MSEG-XAUTO,
           KZBWS             LIKE      MSEG-KZBWS,
           XOBEW             LIKE      MSEG-XOBEW,
           SGT_SCAT          LIKE      MSEG-SGT_SCAT,
*          special flag for retail                          "n497992
           retail(01)        type c,                        "n497992

* define the fields for the IO-OIL specific functions       "n599218 A
*          mseg-oiglcalc     CHAR          1                "n599218 A
*          mseg-oiglsku      QUAN         13                "n599218 A
           oiglcalc(01)      type  c,                       "n599218 A
           oiglsku(07)       type  p  decimals 3,           "n599218 A
           insmk             like      mseg-insmk,          "n599218 A

* the following fields are used for the selection of
* the reversal movements
          SMBLN    LIKE      MSEG-SMBLN,    " No. doc
          SJAHR    LIKE      MSEG-SJAHR,    " Year          "n497992
          SMBLP    LIKE      MSEG-SMBLP.    " Item in doc
ENHANCEMENT-POINT EHP605_RM07MLDD_18 SPOTS ES_RM07MLBD STATIC .
* additional fields : the user has the possibility to activate
* these fields in the following include report
          INCLUDE           TYPE      STYPE_MB5B_ADD.
TYPES : END OF STYPE_MSEG_LEAN.

TYPES: STAB_MSEG_LEAN        TYPE STANDARD TABLE OF STYPE_MSEG_LEAN
                             WITH KEY MBLNR MJAHR.

types : begin of stype_bestand_key,
          matnr              like  mseg-matnr,
          werks              like  mseg-werks,
          bwkey              like  mbew-bwkey,
          charg              like  mseg-charg,
        end of stype_bestand_key.

data : g_s_bestand_key       type  stype_bestand_key.

* data tables with the results for the ALV
TYPES : BEGIN OF STYPE_BELEGE,
          bwkey              like      mbew-bwkey.
          INCLUDE            TYPE      STYPE_MSEG_LEAN.
TYPES :   FARBE_pro_feld     TYPE      SLIS_T_SPECIALCOL_ALV,
          farbe_pro_zeile(03)          type c.
TYPES : END OF STYPE_BELEGE.

TYPES : STAB_BELEGE          TYPE STANDARD TABLE OF STYPE_BELEGE
                             WITH KEY  BUDAT MBLNR ZEILE.

DATA : G_T_BELEGE            TYPE   STAB_BELEGE WITH HEADER LINE,
       G_T_BELEGE1           TYPE   STAB_BELEGE WITH HEADER LINE,
       G_T_BELEGE_UC         TYPE   STAB_BELEGE WITH HEADER LINE.

* new output tables for to list in total mode
types : begin of stype_totals_header,
          BWKEY              LIKE      MBEW-BWKEY,
          WERKS              LIKE      MSEG-WERKS,
          matnr              like      mbew-matnr,
          CHARG              LIKE      MSEG-CHARG,
          sobkz              like      mslb-sobkz,

          NAME1              like      T001W-NAME1,
          maktx              like      makt-maktx,
        end of stype_totals_header.

Types:  begin of stype_totals_item,
          BWKEY              LIKE      MBEW-BWKEY,
          WERKS              LIKE      MSEG-WERKS,
          matnr              like      mbew-matnr,
          CHARG              LIKE      MSEG-CHARG,

          counter            type  i,
          stock_type(40)     type  c,
          menge(09)          TYPE  P   DECIMALS 3,
          MEINS              LIKE      MARA-MEINS,
          wert(09)           TYPE  P   DECIMALS 2.
ENHANCEMENT-POINT EHP605_RM07MLDD_19 SPOTS ES_RM07MLBD STATIC .
types:    WAERS LIKE T001-WAERS,             "Währungsschlüssel
          color              TYPE      SLIS_T_SPECIALCOL_ALV,
        end of stype_totals_item.

types:  stab_totals_header   type standard table of
                             stype_totals_header
                             with default key,

        stab_totals_item     type standard table of
                             stype_totals_item
                             with default key.

data : g_s_totals_header     type stype_totals_header,
       g_t_totals_header     type stab_totals_header.

data : g_s_totals_item       type stype_totals_item,
       g_t_totals_item       type stab_totals_item.

* new output table for flat list in total mode
types : begin of stype_totals_flat,
          matnr              like      mbew-matnr,
          maktx              like      makt-maktx,
          BWKEY              LIKE      MBEW-BWKEY,
          WERKS              LIKE      MSEG-WERKS,
          CHARG              LIKE      MSEG-CHARG,
          sobkz              like      mslb-sobkz,
          name1              like      t001w-name1,         "n999530

          start_date         like      sy-datlo,
          end_date           like      sy-datlo,

          ANFMENGE(09)       TYPE P    DECIMALS 3,
          MEINS              LIKE      MARA-MEINS,
          SOLL(09)           TYPE P DECIMALS 3,
          HABEN(09)          TYPE P DECIMALS 3,
          ENDMENGE(09)       TYPE P DECIMALS 3.
ENHANCEMENT-POINT EHP605_RM07MLDD_20 SPOTS ES_RM07MLBD STATIC .
types:    anfwert(09)        TYPE P    DECIMALS 2,
          WAERS LIKE T001-WAERS,             "Währungsschlüssel
          SOLLWERT(09)       TYPE P    DECIMALS 2,
          HABENWERT(09)      TYPE P    DECIMALS 2,
          endwert(09)        TYPE P    DECIMALS 2,
          color              TYPE      SLIS_T_SPECIALCOL_ALV,
        end of stype_totals_flat,

        stab_totals_flat     type standard table of stype_totals_flat
                             with default key.

data : g_s_totals_flat       type  stype_totals_flat,
       g_t_totals_flat       type  stab_totals_flat.

* for the colorizing of the numeric fields
data : g_s_COLOR             TYPE  SLIS_SPECIALCOL_ALV,
       g_t_color             TYPE  SLIS_T_SPECIALCOL_ALV.

data : g_s_layout_totals_hq   TYPE SLIS_LAYOUT_ALV,
       g_s_layout_totals_flat type slis_layout_alv.

data : g_f_length            type i,
       g_f_length_max        type i.

data : g_offset_header       type i,
       g_offset_qty          type i,
       g_offset_unit         type i,
       g_offset_value        type i,
       g_offset_curr         type i.

types : begin of stype_date_line,
         text(133)           type c,
         datum(10)           type c,
        end of stype_date_line.

data : g_date_line_from      type  stype_date_line,
       g_date_line_to        type  stype_date_line.

data : begin of g_text_line,
         filler(02)          type  c,
         text(133)           type  c,
       end of g_text_line.

* interface structure for new TOP_OF_PAGE and the detail list
types : begin of stype_bestand.
          include structure  bestand.
types : end of stype_bestand.

types : stab_bestand         type standard table of stype_bestand
                             with default key.

data : g_s_bestand           type  stype_bestand,
       g_s_bestand_detail    type  stype_bestand,
       g_t_bestand_detail    type  stab_bestand.

data : l_f_meins_external       type  mara-meins.           "n1018717


* global working areas data from MSEG and MKPF
FIELD-SYMBOLS : <G_FS_MSEG_LEAN>       TYPE STYPE_MSEG_LEAN.
DATA : G_S_MSEG_LEAN         TYPE STYPE_MSEG_LEAN,
       G_S_MSEG_UPDATE       TYPE STYPE_MSEG_LEAN,          "n443935
       G_T_MSEG_LEAN         TYPE STAB_MSEG_LEAN.

* working table for the control break                       "n451923
types : begin of stype_mseg_work.                           "n451923
          include            type      stype_mseg_lean.     "n451923
types :    tabix             like      sy-tabix,            "n451923
        end of stype_mseg_work,                             "n451923
                                                            "n451923
        stab_mseg_work       type standard table of         "n451923
                             stype_mseg_work                "n451923
                             with default key.              "n451923
                                                            "n451923
data : g_t_mseg_work         type  stab_mseg_work,          "n443935
       g_s_mseg_work         type  stype_mseg_work.         "n443935

* working table for the requested field name from MSEG and MKPF
TYPES: BEGIN OF STYPE_FIELDS,
           FIELDNAME           TYPE      NAME_FELD,
       END OF STYPE_FIELDS.

TYPES: STAB_FIELDS           TYPE STANDARD TABLE OF STYPE_FIELDS
                             WITH KEY FIELDNAME.

DATA: G_T_MSEG_FIELDS        TYPE      STAB_FIELDS,
      G_S_MSEG_FIELDS        TYPE      STYPE_FIELDS.

* working table for the requested numeric fields of MSEG
types : begin of stype_color_fields,
           FIELDNAME           TYPE      NAME_FELD,
         type(01)            type c,
       end of stype_color_fields,

       stab_color_fields     type standard table of
                             stype_color_fields
                             with default key.

data: g_t_color_fields       type      stab_color_fields
                             with header line.

DATA: BEGIN OF IMSWEG OCCURS 1000,
        MBLNR LIKE MSEG-MBLNR,
        MJAHR LIKE MSEG-MJAHR,
        ZEILE LIKE MSEG-ZEILE,
        MATNR LIKE MSEG-MATNR,
        CHARG LIKE MSEG-CHARG,
        BWTAR LIKE MSEG-BWTAR,
        WERKS LIKE MSEG-WERKS,
        LGORT LIKE MSEG-LGORT,
        SOBKZ LIKE MSEG-SOBKZ,
        BWART LIKE MSEG-BWART,
        SHKZG LIKE MSEG-SHKZG,
        XAUTO LIKE MSEG-XAUTO,
        MENGE LIKE MSEG-MENGE,
        MEINS LIKE MSEG-MEINS,
        DMBTR LIKE MSEG-DMBTR,
        DMBUM LIKE MSEG-DMBUM,
        BUSTM LIKE MSEG-BUSTM,
        BUSTW LIKE MSEG-BUSTW,                               "147374

* define the fields for the IO-OIL specific functions       "n599218 A
*       mseg-oiglcalc        CHAR          1                "n599218 A
*       mseg-oiglsku         QUAN         13                "n599218 A
        oiglcalc(01)         type  c,                       "n599218 A
        oiglsku(07)          type  p  decimals 3,           "n599218 A
        insmk                like      mseg-insmk.          "n599218 A
ENHANCEMENT-POINT EHP605_RM07MLDD_21 SPOTS ES_RM07MLBD STATIC .
DATA:
      END OF IMSWEG.

* User settings for the checkboxes                          "n547170
  DATA: oref_settings TYPE REF TO cl_mmim_userdefaults.     "n547170
