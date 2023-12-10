*"* use this source file for your ABAP unit test classes
CLASS ltc DEFINITION DEFERRED.
CLASS zcl_c8a009_mb5b_via_spool DEFINITION LOCAL FRIENDS ltc.

CLASS ltc DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PUBLIC SECTION.
    METHODS stock_by_bukrs_matnr FOR TESTING.
    METHODS _parse_qty FOR TESTING.
    METHODS _parse_amount FOR TESTING.

  PRIVATE SECTION.
    DATA lo_cut TYPE REF TO zcl_c8a009_mb5b_via_spool.

ENDCLASS.


CLASS ltc IMPLEMENTATION.
  METHOD stock_by_bukrs_matnr.

    DATA ls_sel_criteria TYPE zif_c8a009_types=>ts_sel_criteria.
    DATA lt_stock        TYPE zttc8a009_mb5b_list_output .

    ls_sel_criteria-bukrs = '3000'.
    ls_sel_criteria-werks_rng = VALUE #( ( sign = 'I' option = 'EQ' low = '3000' ) ). " T001W
    ls_sel_criteria-matnr_rng = VALUE #(
                                          ( sign = 'I' option = 'EQ' low = '1268' )
                                          ( sign = 'I' option = 'EQ' low = '1267' )
                                          ( sign = 'I' option = 'EQ' low = '1397' )
                                        ).
    ls_sel_criteria-budat_rng = VALUE #( ( sign = 'I' option = 'EQ' low = '20200101' ) ).

    BREAK-POINT.

    CREATE OBJECT lo_cut.

    lo_cut->read_stock_on_date(
      EXPORTING
        is_sel_criteria = ls_sel_criteria
      IMPORTING
        et_stock        = lt_stock
    ).

  ENDMETHOD.

  METHOD _parse_qty.
    DATA lv_str_in TYPE string VALUE '  123.456,80'.
    DATA lv_qty TYPE menge_d.

    CREATE OBJECT lo_cut.

    lo_cut->_parse_qty( EXPORTING iv_qty_str = lv_str_in
                        IMPORTING ev         = lv_qty   ).
  ENDMETHOD.

  METHOD _parse_amount.
    DATA lv_str_in TYPE string VALUE '  123.456,80'.
    DATA lv_str_in2 TYPE string VALUE '  123.456,80-'.
    DATA lv_amount TYPE dmbtr.

    CREATE OBJECT lo_cut.

    lo_cut->_parse_amount( EXPORTING iv_amount_str = lv_str_in
                           IMPORTING ev            = lv_amount   ).
  ENDMETHOD.


ENDCLASS.
