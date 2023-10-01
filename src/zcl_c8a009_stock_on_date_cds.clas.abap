CLASS zcl_c8a009_stock_on_date_cds DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS read_stock_on_date
      IMPORTING !is_sel_criteria TYPE zif_c8a009_types=>ts_sel_criteria
      EXPORTING !et_stock        TYPE stock_inventory_tt .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS _valid_input
      IMPORTING !is_sel_criteria TYPE zif_c8a009_types=>ts_sel_criteria
      RETURNING VALUE(rv_val)    TYPE abap_bool.
ENDCLASS.



CLASS ZCL_C8A009_STOCK_ON_DATE_CDS IMPLEMENTATION.


  METHOD read_stock_on_date.
    "IMPORTING !is_sel_criteria TYPE zif_c8a009_types=>ts_sel_criteria
    " EXPORTING !et_stock        TYPE stock_inventory_tt .

    DATA lt_stock_on_date TYPE STANDARD TABLE OF C_MaterialStockByKeyDate.
    DATA ls_stock_inventory TYPE stock_inventory_s.
    FIELD-SYMBOLS <fs_stock_on_date> TYPE C_MaterialStockByKeyDate.
    DATA lv_key_date TYPE budat.

    CLEAR et_stock .
    IF _valid_input( is_sel_criteria ) EQ abap_false.
      RETURN.
    ENDIF.
    lv_key_date = VALUE #( is_sel_criteria-budat_rng[ 1 ]-low OPTIONAL ).

    SELECT *
      FROM C_MaterialStockByKeyDate( P_Language = @sy-langu, P_KeyDate = @lv_key_date )
      WITH PRIVILEGED ACCESS
      WHERE Plant IN @is_sel_criteria-werks_rng
        AND StorageLocation IN @is_sel_criteria-lgort_rng
        AND Material IN @is_sel_criteria-matnr_rng
        INTO TABLE @lt_stock_on_date
      .

    LOOP AT lt_stock_on_date ASSIGNING <fs_stock_on_date>.
      CLEAR ls_stock_inventory.
      ls_stock_inventory-bwkey = <fs_stock_on_date>-plant.
      ls_stock_inventory-werks = <fs_stock_on_date>-plant.
      ls_stock_inventory-matnr = <fs_stock_on_date>-material.
      ls_stock_inventory-charg = <fs_stock_on_date>-batch.
      ls_stock_inventory-endmenge = <fs_stock_on_date>-MatlWrhsStkQtyInMatlBaseUnit.
      ls_stock_inventory-anfmenge = <fs_stock_on_date>-MatlWrhsStkQtyInMatlBaseUnit.
      ls_stock_inventory-meins = <fs_stock_on_date>-MaterialBaseUnit.
      ls_stock_inventory-soll = 0.
      ls_stock_inventory-haben = 0.
      ls_stock_inventory-maktx = 0.
      APPEND ls_stock_inventory TO et_stock .
    ENDLOOP.


  ENDMETHOD.


  METHOD _valid_input.
    "IMPORTING !is_sel_criteria TYPE zif_c8a009_types=>ts_sel_criteria
    "RETURNING VALUE(rv_val)    TYPE abap_bool.
    DATA lv_key_date TYPE budat.

    rv_val = abap_false.

    IF is_sel_criteria IS INITIAL.
      MESSAGE s000(cl) WITH 'Not enough sel.criteria'.
      RETURN.
    ENDIF.


    lv_key_date = VALUE #( is_sel_criteria-budat_rng[ 1 ]-low OPTIONAL ).
    IF lv_key_date IS INITIAL.
      MESSAGE s000(cl) WITH 'Key date must be filled'.
      RETURN.
    ENDIF.

    rv_val = abap_true.
  ENDMETHOD.
ENDCLASS.
