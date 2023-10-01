INTERFACE zif_c8a009_types
  PUBLIC .
  TYPES: BEGIN OF ts_sel_criteria
        , bukrs TYPE bukrs
        , werks_rng TYPE RANGE OF werks_d
        , lgort_rng TYPE RANGE OF lgort_d
        , matnr_rng TYPE RANGE OF matnr
        , budat_rng TYPE RANGE OF budat
    , END OF ts_sel_criteria
    .
ENDINTERFACE.
