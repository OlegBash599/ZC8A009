CLASS zcl_c8a009_mb5b_v2std DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS read_stock_on_date
      IMPORTING !is_sel_criteria TYPE zif_c8a009_types=>ts_sel_criteria
      EXPORTING !et_stock        TYPE stock_inventory_tt .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_C8A009_MB5B_V2STD IMPLEMENTATION.


  METHOD read_stock_on_date.
    "IMPORTING !is_sel_criteria TYPE zif_c8a009_types=>ts_sel_criteria
    "EXPORTING !et_stock        TYPE stock_inventory_tt .

    DATA lt_rng_bukrs TYPE RANGE OF bukrs.
    DATA ls_rng_bukrs LIKE LINE OF lt_rng_bukrs.

    IF is_sel_criteria IS INITIAL.
      MESSAGE s000(cl) WITH 'Not enough sel.criteria'.
      RETURN.
    ENDIF.

    IF is_sel_criteria-bukrs IS INITIAL.
      MESSAGE s000(cl) WITH 'Company Code must be filled'.
      RETURN.
    ELSE.
      ls_rng_bukrs = 'IEQ'.
      ls_rng_bukrs-low = is_sel_criteria-bukrs.
      APPEND ls_rng_bukrs TO lt_rng_bukrs.
    ENDIF.


    SUBMIT rm07mlbd
        WITH bukrs IN lt_rng_bukrs
        WITH werks IN is_sel_criteria-werks_rng
        WITH lgort IN is_sel_criteria-lgort_rng
        WITH matnr IN is_sel_criteria-matnr_rng
        WITH budat IN is_sel_criteria-budat_rng
        WITH p_aut EQ abap_true
        AND RETURN
        .

    IMPORT lt_bestand TO et_stock
        FROM MEMORY ID cl_mm_im_aut_master=>gc_memory_id_rm07mlbd.
    IF sy-subrc EQ 0.
      FREE MEMORY ID cl_mm_im_aut_master=>gc_memory_id_rm07mlbd.
    ENDIF.


  ENDMETHOD.
ENDCLASS.
