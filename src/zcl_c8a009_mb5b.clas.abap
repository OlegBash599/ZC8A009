CLASS zcl_c8a009_mb5b DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.


    METHODS constructor .
    METHODS export2mem
      IMPORTING
        !it_bestand TYPE ANY TABLE .
    METHODS read_stock_on_date
      IMPORTING !is_sel_criteria TYPE zif_c8a009_types=>ts_sel_criteria
      EXPORTING !et_stock        TYPE zttc8a009_mb5b_list_output .
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS mc_stock_on_date TYPE char22 VALUE 'ZCL_C8A009_MB5B_MEM_ID'.
    DATA mt_stock2mem TYPE zttc8a009_mb5b_list_output.
ENDCLASS.



CLASS zcl_c8a009_mb5b IMPLEMENTATION.


  METHOD constructor.
    " log open
  ENDMETHOD.


  METHOD export2mem.

    DATA ls_stock2mem TYPE zsc8a009_mb5b_list_output.
    FIELD-SYMBOLS <fs_bestand_stock_line> TYPE any.

    CLEAR mt_stock2mem.

    LOOP AT it_bestand ASSIGNING <fs_bestand_stock_line>.
      MOVE-CORRESPONDING <fs_bestand_stock_line> TO ls_stock2mem.
      APPEND ls_stock2mem TO mt_stock2mem.
    ENDLOOP.

    EXPORT stock_on_date = mt_stock2mem
        TO MEMORY ID mc_stock_on_date.

  ENDMETHOD.


  METHOD read_stock_on_date.

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


    SUBMIT zrep_c8a009_rm07mlbd
        WITH bukrs IN lt_rng_bukrs
        WITH werks IN is_sel_criteria-werks_rng
        WITH lgort IN is_sel_criteria-lgort_rng
        WITH matnr IN is_sel_criteria-matnr_rng
        WITH budat IN is_sel_criteria-budat_rng
        WITH p2mem eq abap_true
        AND RETURN
        .

    IMPORT stock_on_date = mt_stock2mem
        FROM MEMORY ID mc_stock_on_date.
    IF sy-subrc EQ 0.
      FREE MEMORY ID mc_stock_on_date.
    ENDIF.

    et_stock = mt_stock2mem.
    CLEAR mt_stock2mem.
  ENDMETHOD.
ENDCLASS.
